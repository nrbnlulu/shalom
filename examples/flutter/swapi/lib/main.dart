import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetFilms.shalom.dart';
import 'dio_transport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAPI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FilmsPage(),
    );
  }
}

class FilmsPage extends StatefulWidget {
  const FilmsPage({super.key});

  @override
  State<FilmsPage> createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  List<GetFilms_allFilms_films> _films = [];
  bool _isLoading = true;
  String? _error;
  late ShalomCtx _ctx;

  @override
  void initState() {
    super.initState();
    _ctx = ShalomCtx.withCapacity();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dioClient = dio.Dio();
      final transport = DioTransport(dioClient);
      final httpLink = HttpLink(
        transportLayer: transport,
        url: 'https://swapi-graphql.netlify.app/graphql',
      );

      final requestable = RequestGetFilms();
      final request = requestable.toRequest();

      await for (final response in httpLink.request(request: request, headers: {})) {
        if (response is GraphQLData) {
          final data = response.data;
          final responseObj = GetFilmsResponse.fromResponse(data, ctx: _ctx);
          setState(() {
            _films = responseObj.allFilms?.films?.whereType<GetFilms_allFilms_films>().toList() ?? [];
            _isLoading = false;
          });
        } else if (response is LinkErrorResponse) {
          setState(() {
            _error = 'Error: ${response.errors}';
            _isLoading = false;
          });
        }
        break; // Only take the first response
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SWAPI Films'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _films.length,
                  itemBuilder: (context, index) {
                    final film = _films[index];
                    return ListTile(
                      title: Text(film.title ?? 'Unknown'),
                      subtitle: Text('Director: ${film.director ?? 'Unknown'}\nEpisode: ${film.episodeID ?? 'Unknown'}'),
                      trailing: Text(film.releaseDate ?? 'Unknown'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchFilms,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}