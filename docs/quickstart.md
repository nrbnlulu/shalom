# Quickstart

This walkthrough is a hands-on tutorial for the SWAPI Flutter example in
`examples/flutter/swapi`. The same approach works for any Dart or Flutter app.

## 1. Add your schema and operations

The SWAPI example keeps these files in `examples/flutter/swapi/lib`. They are
already checked in, so you can open and inspect them:

```graphql
# examples/flutter/swapi/lib/schema.graphql (excerpt)
schema {
  query: Query
}

scalar Date

type Query {
  allFilms: FilmConnection
}

type FilmConnection {
  films: [Film]
}

type Film {
  id: ID
  title: String
  director: String
  episodeID: Int
  releaseDate: Date
}
```

```graphql
# examples/flutter/swapi/lib/operations.gql
query GetFilms {
  allFilms {
    films {
      id
      title
      director
      episodeID
      releaseDate
    }
  }
}
```

## 2. (Optional) Add `shalom.yml`

The SWAPI example keeps generated Dart files in `lib` and registers a custom
scalar for `Date`:

```yml
schema_output_path: "./lib"

custom_scalars:
  Date:
    graphql_name: "Date"
    output_type:
      import_path: "package:swapi/custom_scalars.dart"
      symbol_name: "SwapiDate"
    impl_symbol:
      import_path: "package:swapi/custom_scalars.dart"
      symbol_name: "swapiDateScalarImpl"
```

See the scalar implementation in `examples/flutter/swapi/lib/custom_scalars.dart`.

## 3. Run codegen

```bash
shalom generate --path examples/flutter/swapi
```

Shalom will emit Dart files under `__graphql__` in your Dart package.

## 4. Create a client and request data

The SWAPI example wires the client like this:

```dart
final transport = DioTransport(dioClient);
final httpLink = HttpLink(
  transportLayer: transport,
  url: 'https://swapi-graphql.netlify.app/graphql',
);
final ctx = ShalomCtx.withCapacity();
final client = ShalomClient(ctx: ctx, link: httpLink);
```

Then issue a request using the generated request class:

```dart
yield* client.request(requestable: RequestGetFilms());
```

## 5. Read typed data

The generated response exposes your selections as typed fields:

```dart
switch (result) {
  case GraphQLData():
    final films = result.data.allFilms?.films;
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
cd examples/flutter/swapi
flutter run
```

## 7. Why streams?

Shalom normalizes response data, so changes in one operation can update the cached
data used by another. Using streams lets your UI react to those updates. See
`normalized-cache.md` for details.
