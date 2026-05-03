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
  await client.registerFragment(
    document: r'''
fragment PlanetWidget on Planet @observe {
      name
      climates
      terrains
      population
      diameter
    }
''',
  );
  await client.registerFragment(
    document: r'''
fragment PersonWidget on Person @observe {
      name
      birthYear
      gender
      height
      mass
      eyeColor
      hairColor
    }
''',
  );
  await client.registerOperation(
    document: r'''
query FilmsPage ($after: String, $first: Int)@observe {
    allFilms(after: $after first: $first) {
      edges {
        node {
          ...FilmWidget
        }
        cursor
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
}
''',
  );
  await client.registerOperation(
    document: r'''
query PlanetsPage ($after: String, $first: Int)@observe {
    allPlanets(after: $after first: $first) {
      edges {
        node {
          ...PlanetWidget
        }
        cursor
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
}
''',
  );
  await client.registerOperation(
    document: r'''
query PeoplePage ($after: String, $first: Int)@observe {
    allPeople(after: $after first: $first) {
      edges {
        node {
          ...PersonWidget
        }
        cursor
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
}
''',
  );
}
