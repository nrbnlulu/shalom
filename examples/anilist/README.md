# AniList Example

This example shows how to use Shalom with the AniList GraphQL API. It queries
popular anime series, supports pagination, and shows a detail screen with
streaming episodes and characters.

## Run the demo

From the repo root:

```bash
./rust/target/debug/shalom generate --path examples/anilist
```

Then:

```bash
cd examples/anilist
flutter pub get
flutter run
```
