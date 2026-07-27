import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:shalom_core/shalom_core.dart';

import 'dio_transport.dart';
import 'graphql/__graphql__/GetAnimeDetails.shalom.dart';
import 'graphql/__graphql__/GetAnimePage.shalom.dart';

const _endpoint = 'https://graphql.anilist.co/';
const _pageSize = 10;
const _characterPageSize = 12;

void main() {
  runApp(const AniListApp());
}

class AniListApp extends StatefulWidget {
  const AniListApp({super.key});

  @override
  State<AniListApp> createState() => _AniListAppState();
}

class _AniListAppState extends State<AniListApp> {
  late final dio.Dio _dioClient;
  late final ShalomClient _client;

  @override
  void initState() {
    super.initState();
    _dioClient = dio.Dio();
    final transport = DioTransport(_dioClient);
    final httpLink = HttpLink(transportLayer: transport, url: _endpoint);
    final ctx = ShalomCtx.withCapacity();
    _client = ShalomClient(ctx: ctx, link: httpLink);
  }

  @override
  void dispose() {
    _dioClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniList Shalom Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF59E0B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: AnimeListPage(client: _client),
    );
  }
}

class AnimeListPage extends StatefulWidget {
  final ShalomClient client;

  const AnimeListPage({super.key, required this.client});

  @override
  State<AnimeListPage> createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  final List<GetAnimePage_Page_media?> _items = [];
  int _nextPage = 1;
  bool _hasNextPage = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    if (_isLoading || !_hasNextPage) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final variables = GetAnimePageVariables(
      page: _nextPage,
      perPage: _pageSize,
    );

    final response = await widget.client.requestOnce(
      requestable: RequestGetAnimePage(variables: variables),
    );

    if (!mounted) return;

    switch (response) {
      case GraphQLData():
        final page = response.data.Page;
        final media = page?.media ?? [];
        _items.addAll(media);
        final pageInfo = page?.pageInfo;
        _hasNextPage = pageInfo?.hasNextPage ?? false;
        _nextPage = (pageInfo?.currentPage ?? _nextPage) + 1;
        break;
      case GraphQLError():
        _error = response.errors.toString();
        break;
      case LinkExceptionResponse():
        _error = response.errors.toString();
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Anime'), centerTitle: false),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _items.clear();
            _nextPage = 1;
            _hasNextPage = true;
          });
          await _fetchNextPage();
        },
        child: _error != null
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: _items.length + (_hasNextPage ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : FilledButton(
                                onPressed: _fetchNextPage,
                                child: const Text('Load more'),
                              ),
                      ),
                    );
                  }

                  final media = _items[index];
                  if (media == null) {
                    return const SizedBox.shrink();
                  }

                  final title =
                      media.title?.english ?? media.title?.romaji ?? 'Untitled';
                  final subtitleParts = <String>[
                    if (media.format != null) media.format!.name,
                    if (media.episodes != null) '${media.episodes} eps',
                  ];
                  final subtitle = subtitleParts.join(' • ');

                  return ListTile(
                    leading: _CoverImage(url: media.coverImage?.large),
                    title: Text(title),
                    subtitle: subtitle.isEmpty ? null : Text(subtitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AnimeDetailsPage(
                            client: widget.client,
                            mediaId: media.id!,
                            title: title,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class AnimeDetailsPage extends StatefulWidget {
  final ShalomClient client;
  final int mediaId;
  final String title;

  const AnimeDetailsPage({
    super.key,
    required this.client,
    required this.mediaId,
    required this.title,
  });

  @override
  State<AnimeDetailsPage> createState() => _AnimeDetailsPageState();
}

class _AnimeDetailsPageState extends State<AnimeDetailsPage> {
  GetAnimeDetails_Media? _media;
  final List<GetAnimeDetails_Media_characters_nodes?> _characters = [];
  int _nextCharacterPage = 1;
  bool _hasMoreCharacters = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetails(initial: true);
  }

  Future<void> _fetchDetails({required bool initial}) async {
    if (_isLoading || (_isLoadingMore && !initial)) {
      return;
    }

    setState(() {
      if (initial) {
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
      _error = null;
    });

    final variables = GetAnimeDetailsVariables(
      id: widget.mediaId,
      page: _nextCharacterPage,
      perPage: _characterPageSize,
    );

    final response = await widget.client.requestOnce(
      requestable: RequestGetAnimeDetails(variables: variables),
    );

    if (!mounted) return;

    switch (response) {
      case GraphQLData():
        final media = response.data.Media;
        _media ??= media;
        final characters = media?.characters;
        _characters.addAll(characters?.nodes ?? []);
        final pageInfo = characters?.pageInfo;
        _hasMoreCharacters = pageInfo?.hasNextPage ?? false;
        _nextCharacterPage = (pageInfo?.currentPage ?? _nextCharacterPage) + 1;
        break;
      case GraphQLError():
        _error = response.errors.toString();
        break;
      case LinkExceptionResponse():
        _error = response.errors.toString();
        break;
    }

    setState(() {
      _isLoading = false;
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!),
          ),
        ),
      );
    }

    final media = _media;
    if (media == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('No data found.')),
      );
    }

    final title = media.title?.english ?? media.title?.romaji ?? widget.title;
    final description = media.description ?? 'No description available.';
    final episodes = media.episodes?.toString() ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CoverImage(url: media.coverImage?.large, size: 120),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Episodes: $episodes'),
                    if (media.format != null)
                      Text('Format: ${media.format!.name}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Synopsis', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 24),
          Text(
            'Streaming Episodes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (media.streamingEpisodes == null ||
              media.streamingEpisodes!.isEmpty)
            const Text('No streaming episodes listed.')
          else
            ...media.streamingEpisodes!.map(
              (episode) => _StreamingEpisodeTile(episode: episode),
            ),
          const SizedBox(height: 24),
          Text('Characters', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (_characters.isEmpty)
            const Text('No characters found.')
          else
            ..._characters.map(
              (character) => _CharacterTile(character: character),
            ),
          if (_hasMoreCharacters)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: _isLoadingMore
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: () => _fetchDetails(initial: false),
                        child: const Text('Load more characters'),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String? url;
  final double size;

  const _CoverImage({this.url, this.size = 56});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size * 1.4,
        color: const Color(0xFF262626),
        child: const Icon(Icons.movie_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url!,
        width: size,
        height: size * 1.4,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  final GetAnimeDetails_Media_characters_nodes? character;

  const _CharacterTile({required this.character});

  @override
  Widget build(BuildContext context) {
    if (character == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: _CoverImage(url: character!.image?.large, size: 48),
      title: Text(character!.name?.full ?? 'Unknown'),
    );
  }
}

class _StreamingEpisodeTile extends StatelessWidget {
  final GetAnimeDetails_Media_streamingEpisodes? episode;

  const _StreamingEpisodeTile({required this.episode});

  @override
  Widget build(BuildContext context) {
    if (episode == null) {
      return const SizedBox.shrink();
    }

    final subtitleParts = <String>[
      if (episode!.site != null) episode!.site!,
      if (episode!.url != null) episode!.url!,
    ];

    return ListTile(
      leading: _CoverImage(url: episode!.thumbnail, size: 48),
      title: Text(episode!.title ?? 'Episode'),
      subtitle: subtitleParts.isEmpty ? null : Text(subtitleParts.join(' • ')),
    );
  }
}
