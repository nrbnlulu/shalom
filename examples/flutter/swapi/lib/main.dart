import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shalom/shalom.dart' as shalom show Some;
import 'package:shalom_flutter/widgets/shalom_provider.dart';
import 'package:swapi/__graphql__/FilmWidget.shalom.dart';
import 'package:swapi/__graphql__/FilmsPage.widget.shalom.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import 'package:swapi/state.dart' show shalomRuntimeProvider;

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
        home: Consumer(
          builder: (ctx, ref, child) {
            final client = ref.watch(shalomRuntimeProvider);
            if (client.isLoading) {
              debugPrint("loading runtime...");
              return const CircularProgressIndicator();
            }
            if (client.hasError) {
              return Text("error: ${client.error}");
            }

            return ShalomProvider(
              client: client.asData!.value,
              child: FilmsPage(
                variables: FilmsPageVariables(first: shalom.Some(10)),
              ),
            );
          },
        ),
      ),
    );
  }
}

@Query(r"""
    ($after: String, $first: Int, $before: String, $last: Int){
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
""")
class FilmsPage extends $FilmsPage {
  const FilmsPage({super.key, required super.variables});

  @override
  Widget buildError(BuildContext context, Object error) {
    return Text("error: $error");
  }

  @override
  Widget buildLoading(BuildContext context) {
    debugPrint("loading films page");
    return CircularProgressIndicator();
  }

  @override
  Widget buildData(BuildContext context, FilmsPageData data) {
    return Scaffold(
      appBar: AppBar(title: const Text('SWAPI Films')),
      body: ListView.builder(
        itemCount: data.allFilms?.films?.length ?? 0,
        itemBuilder: (context, index) {
          final film = data.allFilms?.films?[index];
          return film != null ? FilmWidget(ref: film) : null;
        },
      ),
    );
  }
}

@Fragment(r"""
    on Film {
      title
      director
      episodeID
      releaseDate
    }
    """)
class FilmWidget extends $FilmWidget {
  const FilmWidget({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, FilmWidgetData film) {
    return ListTile(
      title: Text(film.title ?? 'No Title'),
      subtitle: Text(
        'Director: ${film.director ?? 'Unknown'}\nEpisode: ${film.episodeID ?? 'N/A'}',
      ),
      trailing: Text(film.releaseDate ?? 'Unknown Date'),
      isThreeLine: true,
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
