import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetFilms.shalom.dart';
import 'dio_transport.dart';

// Type alias for the specific film type for better readability

void main() {
  final dioClient = dio.Dio();
  final transport = DioTransport(dioClient);
  final httpLink = HttpLink(
    transportLayer: transport,  
    url: 'https://swapi-graphql.netlify.app/graphql',
  );
  final ctx = ShalomCtx.withCapacity();
  final client = ShalomClient(ctx: ctx, link: httpLink);
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ShalomClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAPI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FilmsPage(client: client),
    );
  }
}

//
// --- Refined FilmsPage ---
//
// 1. Converted to StatefulWidget to create and hold the stream in its state.
//    This prevents re-creating the stream on every build.
//
class FilmsPage extends StatefulWidget {
  final ShalomClient client;
  const FilmsPage({super.key, required this.client});

  @override
  State<FilmsPage> createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  // 2. Store the request and stream as state variables.
  //    'late final' ensures they are initialized once in initState.
  late final RequestGetFilms requestable;
  late final Stream<GraphQLResponse<GetFilmsResponse>> stream;

  @override
  void initState() {
    super.initState();
    // 3. Initialize the request and stream here.
    //    This is called only once when the widget is first created.
    requestable = RequestGetFilms();
    stream = widget.client.request(requestable: requestable);
  }

  @override
  Widget build(BuildContext context) {
    // 4. The StreamBuilder now uses the state's 'stream' variable.
    return StreamBuilder<GraphQLResponse<GetFilmsResponse>>(
      stream: stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: const Text('SWAPI Films')),
          body: SnapshotHandler(
            snapshot: snapshot,
            dataBuilder: (context, result) {
              switch (result) {
                case GraphQLData():
                  {
                    final films = result.data.allFilms?.films;

                    // Handle the case where films list is null or empty
                    if (films == null || films.isEmpty) {
                      return const Center(child: Text('No films found'));
                    }

                    // Delegate the list rendering to a clean, dedicated widget
                    return FilmsList(films: films);
                  }
                case LinkExceptionResponse():
                  {
                    return Text("link errors: ${result.errors}");
                  }
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // 9. Refresh triggers a new request on the *same* stream.
              //    The StreamBuilder will automatically pick up the new event if the data has changed.
              widget.client.request(requestable: requestable);
            },
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
        );
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
