// ignore_for_file: unused_import
import 'package:shalom/shalom.dart';

/// Register all @Query and @Fragment operations with the Shalom client.
Future<void> registerShalomDefinitions(ShalomRuntimeClient client) async {
  await client.registerFragment(
    document: r'''
fragment FilmWidget on Film @observe {
      title
      director
      episodeID
      releaseDate
    }
''',
  );
  await client.registerOperation(
    document: r'''
query FilmsPage ($after: String, $first: Int, $before: String, $last: Int)@observe {
    allFilms(
        after: $after
        first: $first
        before: $before
        last: $last
    ) {
      films {
        ...FilmWidget
      }
    }
}
''',
  );
}
