# Quickstart

This walkthrough is a hands-on tutorial for the AniList Flutter example in
`examples/anilist`. The same approach works for any Dart or Flutter app.

## 1. Add your schema and operations

The AniList example keeps these files in `examples/anilist/lib/graphql`. They are
already checked in, so you can open and inspect them:

```graphql
# examples/anilist/lib/graphql/schema.graphql (excerpt)
type Page {
  pageInfo: PageInfo
  media: [Media]
}

type PageInfo {
  currentPage: Int
  lastPage: Int
  hasNextPage: Boolean
}
```

```graphql
# examples/anilist/lib/graphql/operations.gql
fragment MediaCard on Media {
  id
  title {
    romaji
    english
  }
  coverImage {
    large
  }
  episodes
  format
}

query GetAnimePage($page: Int!, $perPage: Int!) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      currentPage
      hasNextPage
      lastPage
    }
    media(type: ANIME, sort: POPULARITY_DESC) {
      ...MediaCard
    }
  }
}
```

## 2. (Optional) Add `shalom.yml`

The AniList example keeps generated Dart files in `lib`:

```yml
schema_output_path: "./lib"
custom_scalars: {}
```

## 3. Run codegen

```bash
shalom generate --path examples/anilist
```

Shalom will emit Dart files under `lib/graphql/__graphql__` for this example.

## 4. Create a client and request data

The AniList example wires the client like this:

```dart
final transport = DioTransport(dioClient);
final httpLink = HttpLink(
  transportLayer: transport,
  url: 'https://graphql.anilist.co/',
);
final ctx = ShalomCtx.withCapacity();
final client = ShalomClient(ctx: ctx, link: httpLink);
```

Then issue a request using the generated request class:

```dart
final response = await client.requestOnce(
  requestable: RequestGetAnimePage(
    variables: GetAnimePageVariables(page: 1, perPage: 10),
  ),
);
```

## 5. Read typed data

The generated response exposes your selections as typed fields:

```dart
switch (response) {
  case GraphQLData():
    final media = response.data.Page?.media;
    // Build UI from the list
  case GraphQLError():
    // handle GraphQL errors
  case LinkExceptionResponse():
    // handle transport errors
}
```

## 6. Run the example app

From the example directory:

```bash
cd examples/anilist
flutter run
```

## 7. Why streams?

Shalom normalizes response data, so changes in one operation can update the cached
data used by another. Using streams lets your UI react to those updates. See
`normalized-cache.md` for details.
