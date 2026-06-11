# app.py
from __future__ import annotations

import asyncio
import json
import uuid
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import AsyncGenerator, Optional
from urllib.parse import quote_plus

import httpx
import strawberry
import uvicorn
from bs4 import BeautifulSoup
from litestar import Litestar
from strawberry.litestar import make_graphql_controller

# ----------------------------
# Bing scraper config
# ----------------------------

_BING_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "en-US,en;q=0.9",
}

_BING_COOKIES = {
    "SRCHHPGUSR": "ADLT=OFF",
}

_EXT_TO_KEY = {
    ".gif": "gif_url",
    ".mp4": "mp4_url",
    ".webm": "webm_url",
    ".webp": "webp_url",
}


# ----------------------------
# In-memory state
# ----------------------------


@dataclass
class GifModel:
    id: str
    title: str
    url: str
    preview_url: Optional[str] = None


@dataclass
class AlbumModel:
    id: str
    name: str
    gifs: list[GifModel] = field(default_factory=list)


albums_by_id: dict[str, AlbumModel] = {}
state_lock = asyncio.Lock()

# Each subscriber gets its own queue.
album_event_subscribers: set[asyncio.Queue["AlbumEvent"]] = set()


async def publish_album_event(event: "AlbumEvent") -> None:
    dead_queues: list[asyncio.Queue[AlbumEvent]] = []

    for queue in album_event_subscribers:
        try:
            queue.put_nowait(event)
        except asyncio.QueueFull:
            dead_queues.append(queue)

    for queue in dead_queues:
        album_event_subscribers.discard(queue)


# ----------------------------
# Strawberry GraphQL types
# ----------------------------


@strawberry.type
class Gif:
    id: str
    title: str
    url: str
    preview_url: Optional[str] = None


@strawberry.type
class Album:
    id: str
    name: str
    gifs: list[Gif]
    tag: str = "booz"



@strawberry.type
class GifSearchPage:
    items: list[Gif]
    offset: int
    limit: int
    total_count: Optional[int]
    has_next_page: bool


@strawberry.enum
class AlbumEventKind(Enum):
    ALBUM_CREATED = "ALBUM_CREATED"
    GIF_ADDED_TO_ALBUM = "GIF_ADDED_TO_ALBUM"
    GIF_REMOVED_FROM_ALBUM = "GIF_REMOVED_FROM_ALBUM"


@strawberry.type
class AlbumEvent:
    kind: AlbumEventKind
    album: Album
    gif: Optional[Gif] = None


def to_gif(model: GifModel) -> Gif:
    return Gif(
        id=model.id,
        title=model.title,
        url=model.url,
        preview_url=model.preview_url,
    )


def to_album(model: AlbumModel) -> Album:
    return Album(
        id=model.id,
        name=model.name,
        gifs=[to_gif(gif) for gif in model.gifs],
    )


# ----------------------------
# Bing scraper
# ----------------------------


def _media_key(url: str) -> str:
    lower = url.lower().split("?")[0]
    for ext, key in _EXT_TO_KEY.items():
        if lower.endswith(ext):
            return key
    return "gif_url"


def _extract_gifs_from_html(html: str) -> list[dict]:
    soup = BeautifulSoup(html, "html.parser")
    items = []
    for el in soup.find_all("a", class_="iusc"):
        raw = el.get("m", "")
        if not raw:
            continue
        try:
            m = json.loads(raw)
        except json.JSONDecodeError:
            continue
        entry: dict = {}
        name = m.get("t") or m.get("desc")
        if name:
            entry["name"] = name
        murl = m.get("murl", "")
        if murl:
            entry[_media_key(murl)] = murl
        turl = m.get("turl", "")
        if turl:
            entry["preview_url"] = turl
        if entry:
            items.append(entry)
    return items


async def search_bing_gifs(query: str, offset: int, limit: int) -> GifSearchPage:
    q = quote_plus(query)
    first = offset + 1  # Bing uses 1-based start index
    url = (
        f"https://www.bing.com/images/search"
        f"?q={q}&qft=+filterui:photo-animatedgif&form=IRFLTR&first={first}"
    )

    async with httpx.AsyncClient(
        headers=_BING_HEADERS,
        cookies=_BING_COOKIES,
        timeout=15.0,
        follow_redirects=True,
    ) as client:
        response = await client.get(url)

    response.raise_for_status()
    raw_items = _extract_gifs_from_html(response.text)

    page_items = raw_items[:limit]
    has_next_page = len(raw_items) > limit

    gifs = []
    for item in page_items:
        gif_url = (
            item.get("gif_url")
            or item.get("mp4_url")
            or item.get("webm_url")
            or item.get("webp_url")
            or ""
        )
        gifs.append(Gif(
            id=str(uuid.uuid4()),
            title=item.get("name") or "Untitled GIF",
            url=gif_url,
            preview_url=item.get("preview_url") or gif_url,
        ))

    return GifSearchPage(
        items=gifs,
        offset=offset,
        limit=limit,
        total_count=None,
        has_next_page=has_next_page,
    )


# ----------------------------
# Query / Mutation / Subscription
# ----------------------------


@strawberry.type
class Query:
    @strawberry.field
    async def search_gifs(
        self,
        query: str,
        offset: int = 0,
        limit: int = 20,
    ) -> GifSearchPage:
        limit = max(1, min(limit, 50))
        offset = max(0, offset)

        return await search_bing_gifs(
            query=query,
            offset=offset,
            limit=limit,
        )

    @strawberry.field
    async def albums(self) -> list[Album]:
        async with state_lock:
            return [to_album(album) for album in albums_by_id.values()]

    @strawberry.field
    async def album(self, id: str) -> Optional[Album]:
        async with state_lock:
            album = albums_by_id.get(id)
            return to_album(album) if album else None


@strawberry.type
class Mutation:
    @strawberry.mutation
    async def create_album(self, name: str) -> Album:
        album_model = AlbumModel(
            id=str(uuid.uuid4()),
            name=name,
        )

        async with state_lock:
            albums_by_id[album_model.id] = album_model
            album = to_album(album_model)

        await publish_album_event(
            AlbumEvent(
                kind=AlbumEventKind.ALBUM_CREATED,
                album=album,
                gif=None,
            )
        )

        return album

    @strawberry.mutation
    async def add_gif_to_album(
        self,
        album_id: str,
        gif_id: str,
        title: str,
        url: str,
        preview_url: Optional[str] = None,
    ) -> Album:
        gif_model = GifModel(
            id=gif_id,
            title=title,
            url=url,
            preview_url=preview_url,
        )

        async with state_lock:
            album_model = albums_by_id.get(album_id)

            if not album_model:
                raise ValueError(f"Album not found: {album_id}")

            # De-dupe by GIF id inside the album.
            if not any(existing.id == gif_id for existing in album_model.gifs):
                album_model.gifs.append(gif_model)

            album = to_album(album_model)
            gif = to_gif(gif_model)

        await publish_album_event(
            AlbumEvent(
                kind=AlbumEventKind.GIF_ADDED_TO_ALBUM,
                album=album,
                gif=gif,
            )
        )

        return album

    @strawberry.mutation
    async def remove_gif_from_album(
        self,
        album_id: str,
        gif_id: str,
    ) -> Album:
        async with state_lock:
            album_model = albums_by_id.get(album_id)

            if not album_model:
                raise ValueError(f"Album not found: {album_id}")

            removed_gif = next(
                (gif for gif in album_model.gifs if gif.id == gif_id),
                None,
            )

            album_model.gifs = [gif for gif in album_model.gifs if gif.id != gif_id]

            album = to_album(album_model)
            gif = to_gif(removed_gif) if removed_gif else None

        await publish_album_event(
            AlbumEvent(
                kind=AlbumEventKind.GIF_REMOVED_FROM_ALBUM,
                album=album,
                gif=gif,
            )
        )

        return album


@strawberry.type
class Subscription:
    @strawberry.subscription
    async def album_events(self) -> AsyncGenerator[AlbumEvent, None]:
        queue: asyncio.Queue[AlbumEvent] = asyncio.Queue(maxsize=100)
        album_event_subscribers.add(queue)

        try:
            while True:
                yield await queue.get()
        finally:
            album_event_subscribers.discard(queue)


schema = strawberry.Schema(
    query=Query,
    mutation=Mutation,
    subscription=Subscription,
)


def export_schema() -> None:
    Path("scm.graphql").write_text(
        schema.as_str(),
        encoding="utf-8",
    )


# Export every time the file is imported/run.
export_schema()


GraphQLController = make_graphql_controller(
    schema,
    path="/graphql",
    graphql_ide="graphiql",
)

app = Litestar(route_handlers=[GraphQLController])


if __name__ == "__main__":
    uvicorn.run(
        app,
        host="127.0.0.1",
        port=7000,
    )
