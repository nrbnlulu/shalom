import 'dart:async' show StreamSubscription;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shalom/shalom.dart' as shalom show Some, None;
import 'package:shalom_flutter/widgets/shalom_provider.dart';
import 'package:swapi/__graphql__/FilmWidget.shalom.dart';
import 'package:swapi/__graphql__/FilmsPage.widget.shalom.dart';
import 'package:swapi/__graphql__/PlanetWidget.shalom.dart';
import 'package:swapi/__graphql__/PlanetsPage.widget.shalom.dart';
import 'package:swapi/__graphql__/PersonWidget.shalom.dart';
import 'package:swapi/__graphql__/PeoplePage.widget.shalom.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import 'package:swapi/state.dart' show shalomRuntimeProvider;

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
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (client.hasError) {
              return Scaffold(body: Center(child: Text("error: ${client.error}")));
            }
            return ShalomProvider(
              client: client.asData!.value,
              child: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _pages = [
    FilmsPage(variables: FilmsPageVariables()),
    PlanetsPage(variables: PlanetsPageVariables()),
    PeoplePage(variables: PeoplePageVariables()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Films'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Planets'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
        ],
      ),
    );
  }
}

// ─── Films ────────────────────────────────────────────────────────────────────

@Query(r"""
    ($after: String, $first: Int){
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
""")
class FilmsPage extends $FilmsPage {
  const FilmsPage({super.key, required super.variables});

  @override
  State<$FilmsPage> createState() => _FilmsPageState();

  @override
  Widget buildLoading(BuildContext context) => throw UnimplementedError();
  @override
  Widget buildError(BuildContext context, Object error) => throw UnimplementedError();
  @override
  Widget buildData(BuildContext context, FilmsPageData data) => throw UnimplementedError();
}

class _FilmsPageState extends State<FilmsPage> {
  final _scrollController = ScrollController();
  final _refs = <FilmWidgetRef>[];
  StreamSubscription<FilmsPageData>? _sub;
  String? _endCursor;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_refs.isEmpty && !_isLoadingMore) _loadPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasNextPage &&
        !_isLoadingMore) {
      _loadPage(after: _endCursor);
    }
  }

  void _loadPage({String? after}) {
    _sub?.cancel();
    setState(() => _isLoadingMore = true);
    final vars = FilmsPageVariables(
      first: shalom.Some(5),
      after: after != null ? shalom.Some(after) : const shalom.None(),
    );
    _sub = ShalomScope.of(context)
        .request<FilmsPageData>(
          name: 'FilmsPage',
          variables: vars.toJson(),
          decoder: FilmsPageData.fromCache,
        )
        .listen(
          (data) {
            _sub?.cancel();
            final connection = data.allFilms;
            if (connection == null) return;
            final newRefs = connection.edges
                    ?.whereType<FilmsPage_allFilms_edges>()
                    .map((e) => e.node)
                    .whereType<FilmWidgetRef>()
                    .toList() ??
                [];
            setState(() {
              _refs.addAll(newRefs);
              _hasNextPage = connection.pageInfo.hasNextPage;
              _endCursor = connection.pageInfo.endCursor;
              _isLoadingMore = false;
              _error = null;
            });
          },
          onError: (e) => setState(() {
            _error = e;
            _isLoadingMore = false;
          }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Films')),
        body: Center(child: Text('Error: $_error')),
      );
    }
    if (_refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Films')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Films')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _refs.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _refs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return FilmWidget(ref: _refs[index]);
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
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading...'));

  @override
  Widget buildError(BuildContext context, Object error) =>
      ListTile(title: Text('Error: $error'));

  @override
  Widget buildData(BuildContext context, FilmWidgetData film) {
    return ListTile(
      title: Text(film.title ?? 'Unknown'),
      subtitle: Text('Director: ${film.director ?? 'Unknown'}\nEpisode: ${film.episodeID ?? 'N/A'}'),
      trailing: Text(film.releaseDate ?? ''),
      isThreeLine: true,
    );
  }
}

// ─── Planets ──────────────────────────────────────────────────────────────────

@Query(r"""
    ($after: String, $first: Int){
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
""")
class PlanetsPage extends $PlanetsPage {
  const PlanetsPage({super.key, required super.variables});

  @override
  State<$PlanetsPage> createState() => _PlanetsPageState();

  @override
  Widget buildLoading(BuildContext context) => throw UnimplementedError();
  @override
  Widget buildError(BuildContext context, Object error) => throw UnimplementedError();
  @override
  Widget buildData(BuildContext context, PlanetsPageData data) => throw UnimplementedError();
}

class _PlanetsPageState extends State<PlanetsPage> {
  final _scrollController = ScrollController();
  final _refs = <PlanetWidgetRef>[];
  StreamSubscription<PlanetsPageData>? _sub;
  String? _endCursor;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_refs.isEmpty && !_isLoadingMore) _loadPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasNextPage &&
        !_isLoadingMore) {
      _loadPage(after: _endCursor);
    }
  }

  void _loadPage({String? after}) {
    _sub?.cancel();
    setState(() => _isLoadingMore = true);
    final vars = PlanetsPageVariables(
      first: shalom.Some(5),
      after: after != null ? shalom.Some(after) : const shalom.None(),
    );
    _sub = ShalomScope.of(context)
        .request<PlanetsPageData>(
          name: 'PlanetsPage',
          variables: vars.toJson(),
          decoder: PlanetsPageData.fromCache,
        )
        .listen(
          (data) {
            _sub?.cancel();
            final connection = data.allPlanets;
            if (connection == null) return;
            final newRefs = connection.edges
                    ?.whereType<PlanetsPage_allPlanets_edges>()
                    .map((e) => e.node)
                    .whereType<PlanetWidgetRef>()
                    .toList() ??
                [];
            setState(() {
              _refs.addAll(newRefs);
              _hasNextPage = connection.pageInfo.hasNextPage;
              _endCursor = connection.pageInfo.endCursor;
              _isLoadingMore = false;
              _error = null;
            });
          },
          onError: (e) => setState(() {
            _error = e;
            _isLoadingMore = false;
          }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Planets')),
        body: Center(child: Text('Error: $_error')),
      );
    }
    if (_refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Planets')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Planets')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _refs.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _refs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return PlanetWidget(ref: _refs[index]);
        },
      ),
    );
  }
}

@Fragment(r"""
    on Planet {
      name
      climates
      terrains
      population
      diameter
    }
    """)
class PlanetWidget extends $PlanetWidget {
  const PlanetWidget({super.key, required super.ref});

  @override
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading...'));

  @override
  Widget buildError(BuildContext context, Object error) =>
      ListTile(title: Text('Error: $error'));

  @override
  Widget buildData(BuildContext context, PlanetWidgetData planet) {
    final climates = planet.climates?.whereType<String>().join(', ') ?? 'Unknown';
    final terrains = planet.terrains?.whereType<String>().join(', ') ?? 'Unknown';
    final population = planet.population != null
        ? planet.population!.toStringAsFixed(0)
        : 'Unknown';
    return ListTile(
      title: Text(planet.name ?? 'Unknown'),
      subtitle: Text('Climate: $climates\nTerrain: $terrains'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Pop: $population', style: const TextStyle(fontSize: 11)),
          if (planet.diameter != null)
            Text('${planet.diameter} km', style: const TextStyle(fontSize: 11)),
        ],
      ),
      isThreeLine: true,
    );
  }
}

// ─── People ───────────────────────────────────────────────────────────────────

@Query(r"""
    ($after: String, $first: Int){
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
""")
class PeoplePage extends $PeoplePage {
  const PeoplePage({super.key, required super.variables});

  @override
  State<$PeoplePage> createState() => _PeoplePageState();

  @override
  Widget buildLoading(BuildContext context) => throw UnimplementedError();
  @override
  Widget buildError(BuildContext context, Object error) => throw UnimplementedError();
  @override
  Widget buildData(BuildContext context, PeoplePageData data) => throw UnimplementedError();
}

class _PeoplePageState extends State<PeoplePage> {
  final _scrollController = ScrollController();
  final _refs = <PersonWidgetRef>[];
  StreamSubscription<PeoplePageData>? _sub;
  String? _endCursor;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_refs.isEmpty && !_isLoadingMore) _loadPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasNextPage &&
        !_isLoadingMore) {
      _loadPage(after: _endCursor);
    }
  }

  void _loadPage({String? after}) {
    _sub?.cancel();
    setState(() => _isLoadingMore = true);
    final vars = PeoplePageVariables(
      first: shalom.Some(5),
      after: after != null ? shalom.Some(after) : const shalom.None(),
    );
    _sub = ShalomScope.of(context)
        .request<PeoplePageData>(
          name: 'PeoplePage',
          variables: vars.toJson(),
          decoder: PeoplePageData.fromCache,
        )
        .listen(
          (data) {
            _sub?.cancel();
            final connection = data.allPeople;
            if (connection == null) return;
            final newRefs = connection.edges
                    ?.whereType<PeoplePage_allPeople_edges>()
                    .map((e) => e.node)
                    .whereType<PersonWidgetRef>()
                    .toList() ??
                [];
            setState(() {
              _refs.addAll(newRefs);
              _hasNextPage = connection.pageInfo.hasNextPage;
              _endCursor = connection.pageInfo.endCursor;
              _isLoadingMore = false;
              _error = null;
            });
          },
          onError: (e) => setState(() {
            _error = e;
            _isLoadingMore = false;
          }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('People')),
        body: Center(child: Text('Error: $_error')),
      );
    }
    if (_refs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('People')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _refs.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _refs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return PersonWidget(ref: _refs[index]);
        },
      ),
    );
  }
}

@Fragment(r"""
    on Person {
      name
      birthYear
      gender
      height
      mass
      eyeColor
      hairColor
    }
    """)
class PersonWidget extends $PersonWidget {
  const PersonWidget({super.key, required super.ref});

  @override
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading...'));

  @override
  Widget buildError(BuildContext context, Object error) =>
      ListTile(title: Text('Error: $error'));

  @override
  Widget buildData(BuildContext context, PersonWidgetData person) {
    final height = person.height != null ? '${person.height} cm' : 'Unknown';
    final mass = person.mass != null ? '${person.mass!.toStringAsFixed(0)} kg' : 'Unknown';
    return ListTile(
      title: Text(person.name ?? 'Unknown'),
      subtitle: Text(
        'Born: ${person.birthYear ?? 'Unknown'} · ${person.gender ?? 'Unknown'}\n'
        'Eyes: ${person.eyeColor ?? 'Unknown'} · Hair: ${person.hairColor ?? 'Unknown'}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(height, style: const TextStyle(fontSize: 11)),
          Text(mass, style: const TextStyle(fontSize: 11)),
        ],
      ),
      isThreeLine: true,
    );
  }
}
