import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shalom_core/shalom_core.dart';
import 'package:swapi/state.dart';
import '__graphql__/GetFilms.shalom.dart';

// Type alias for the specific film type for better readability

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'SWAPI Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: FilmsPage(),
      ),
    );
  }
}

class FilmsPage extends StatelessWidget {
  const FilmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SWAPI Films')),
      body: NewWidget(),
    );
  }
}

class NewWidget extends ConsumerWidget {
  const NewWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final result = ref.watch(filmsProvider);
    return result.when(
      data: (result) {
        switch (result) {
          case GraphQLData():
            {
              final films = result.data.allFilms?.films;
              if (films == null || films.isEmpty) {
                return const Center(child: Text('No films found'));
              }
              return FilmsList(films: films);
            }
          case GraphQLError():
            return Text("graphql errors: ${result.errors}");
          case LinkExceptionResponse():
            {
              return Text("link errors: ${result.errors}");
            }
        }
      },
      error: (error, stackTrace) {
        return Text("error: $error");
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class FilmsList extends StatelessWidget {
  // Use the type alias 'FilmItem' for a cleaner signature
  final List<GetFilms_allFilms_films?> films;

  const FilmsList({super.key, required this.films});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];

        // Handle null items in the list gracefully
        if (film == null) {
          return const ListTile(title: Text('Invalid film data'));
        }

        return ListTile(
          title: Text(film.title ?? 'No Title'),
          subtitle: Text(
            'Director: ${film.director ?? 'Unknown'}\nEpisode: ${film.episodeID ?? 'N/A'}',
          ),
          trailing: Text(film.releaseDate ?? 'Unknown Date'),
          isThreeLine: true,
        );
      },
    );
  }
}

class SnapshotHandler<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(BuildContext context, T data) dataBuilder;

  const SnapshotHandler({
    Key? key,
    required this.snapshot,
    required this.dataBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (snapshot.hasData) {
      return dataBuilder(context, snapshot.data as T);
    }
    return const Center(child: CircularProgressIndicator());
  }
}
