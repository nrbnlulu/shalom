# app.py
from __future__ import annotations

import asyncio
import os
import uuid
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import AsyncGenerator, Optional

import httpx
import strawberry
import uvicorn
from litestar import Litestar
from strawberry.litestar import make_graphql_controller

# ----------------------------
# Config
# ----------------------------

KLIPY_API_KEY = os.environ.get("KLIPY_API_KEY")

# KLIPY is Tenor-compatible enough for this demo.
# Example:
# GET https://api.klipy.com/v2/search?key=...&q=office&limit=20&pos=0
KLIPY_SEARCH_URL = "https://api.klipy.com/v2/search"


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
# Klipy client
# ----------------------------


def parse_klipy_gif(raw: dict) -> Gif:
    """
    Parses Tenor/KLIPY v2-style GIF response objects.
    """
    gif_id = str(raw.get("id") or uuid.uuid4())
    title = (
        raw.get("content_description")
        or raw.get("title")
        or raw.get("h1_title")
        or "Untitled GIF"
    )

    media_formats = raw.get("media_formats") or {}

    gif_format = (
        media_formats.get("gif")
        or media_formats.get("mediumgif")
        or media_formats.get("tinygif")
        or {}
    )

    preview_format = (
        media_formats.get("tinygif")
        or media_formats.get("nanogif")
        or media_formats.get("gifpreview")
        or gif_format
        or {}
    )

    url = gif_format.get("url") or raw.get("url") or ""
    preview_url = preview_format.get("url") or url

    return Gif(
        id=gif_id,
        title=title,
        url=url,
        preview_url=preview_url,
    )


async def search_klipy_gifs(query: str, offset: int, limit: int) -> GifSearchPage:
    if not KLIPY_API_KEY:
        raise RuntimeError("Missing KLIPY_API_KEY environment variable")

    async with httpx.AsyncClient(timeout=10.0) as client:
        response = await client.get(
            KLIPY_SEARCH_URL,
            params={
                # KLIPY/Tenor-compatible API uses `key`, not `api_key`.
                "key": KLIPY_API_KEY,
                "q": query,
                "limit": limit,
                # KLIPY/Tenor pagination is cursor-ish via `pos`.
                # For this demo GraphQL API, we expose it as offset-based pagination.
                "pos": str(offset),
                "media_filter": "gif,tinygif,nanogif",
                "contentfilter": "medium",
            },
            headers={
                "accept": "application/json",
                "user-agent": "strawberry-litestar-gif-demo/1.0",
            },
        )

    content_type = response.headers.get("content-type", "")
    body_preview = response.text[:500]

    if response.status_code >= 400:
        raise RuntimeError(
            f"KLIPY request failed: status={response.status_code}, "
            f"content_type={content_type}, body={body_preview!r}"
        )

    if "json" not in content_type.lower():
        raise RuntimeError(
            f"KLIPY returned non-JSON response: status={response.status_code}, "
            f"content_type={content_type}, body={body_preview!r}"
        )

    payload = response.json()

    raw_items = payload.get("results") or payload.get("data") or []
    items = [parse_klipy_gif(item) for item in raw_items]

    # KLIPY/Tenor v2 usually returns `next`.
    # Because the API is cursor-ish, this demo cannot know total_count.
    next_pos = payload.get("next")
    has_next_page = bool(next_pos) and len(items) > 0

    return GifSearchPage(
        items=items,
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

        return await search_klipy_gifs(
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
