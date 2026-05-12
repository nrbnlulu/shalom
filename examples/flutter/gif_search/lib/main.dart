import 'dart:async' show StreamSubscription;
import 'package:flutter/material.dart';
import 'package:shalom/shalom.dart'
    as shalom
    show Some, None, ShalomRuntimeClient;
import 'package:shalom_annotations/shalom_annotations.dart';
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:gif_search/state.dart' show createShalomClient;

import 'package:gif_search/__graphql__/GifWidget.shalom.dart';
import 'package:gif_search/__graphql__/AlbumWidget.shalom.dart';
import 'package:gif_search/__graphql__/SearchGifsPage.widget.shalom.dart';
import 'package:gif_search/__graphql__/AlbumsPage.widget.shalom.dart';
import 'package:gif_search/__graphql__/CreateAlbumMutation.widget.shalom.dart';
import 'package:gif_search/__graphql__/AddGifToAlbumMutation.widget.shalom.dart';
import 'package:gif_search/__graphql__/RemoveGifFromAlbumMutation.widget.shalom.dart';
import 'package:shalom_flutter/widgets/shalom_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await shalom.ShalomRuntimeClient.initFlutterRustBridge();
  final client = createShalomClient();
  runApp(ShalomProvider(client: client, child: const MyApp()));
}

mixin class QueryWidgetDefaults {
  Widget buildLoading(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  Widget buildError(BuildContext context, Object error) {
    debugPrint('Shalom query error in $runtimeType: $error');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: $error',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ─── Home ─────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _pages = [_SearchTab(), _AlbumsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Albums',
          ),
        ],
      ),
    );
  }
}

// ─── Search Tab ───────────────────────────────────────────────────────────────

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _controller = TextEditingController();
  String _currentQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search GIFs…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (v) {
                final q = v.trim();
                if (q.isNotEmpty) setState(() => _currentQuery = q);
              },
            ),
          ),
          Expanded(
            child: _currentQuery.isEmpty
                ? const Center(child: Text('Enter a search term above'))
                : SearchGifsPage(
                    variables: SearchGifsPageVariables(
                      query: _currentQuery,
                      offset: 0,
                      limit: 20,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Album picker — used by the add-to-album dialog ──────────────────────────

class AlbumPickerQuery extends $AlbumsPage with QueryWidgetDefaults {
  final void Function(AlbumWidgetData album) onSelected;

  const AlbumPickerQuery({super.key, required this.onSelected});

  @override
  Widget buildData(BuildContext context, AlbumsPageData data) {
    if (data.albums.isEmpty) {
      return const Text('No albums yet. Create one first!');
    }
    final listHeight = (data.albums.length * 72.0).clamp(72.0, 360.0);
    return SizedBox(
      width: double.maxFinite,
      height: listHeight,
      child: ListView.builder(
        itemCount: data.albums.length,
        itemBuilder: (context, i) =>
            AlbumWidget(ref: data.albums[i], onTap: onSelected),
      ),
    );
  }
}

// ─── SearchGifsPage query widget ──────────────────────────────────────────────

@Query(r"""
  ($query: String!, $offset: Int!, $limit: Int!) {
    searchGifs(query: $query, offset: $offset, limit: $limit) {
      items {
        ...GifWidget
      }
      offset
      limit
      totalCount
      hasNextPage
    }
  }
""")
class SearchGifsPage extends $SearchGifsPage with QueryWidgetDefaults {
  const SearchGifsPage({super.key, required super.variables});

  @override
  State<$SearchGifsPage> createState() => _SearchGifsPageState();

  @override
  Widget buildData(BuildContext context, SearchGifsPageData data) =>
      throw UnimplementedError();
}

class _SearchGifsPageState extends State<SearchGifsPage> {
  final _scrollController = ScrollController();
  final _refs = <GifWidgetRef>[];
  bool _hasNextPage = true;
  int _nextOffset = 0;
  bool _isLoadingMore = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      _refs.clear();
      _hasNextPage = true;
      _nextOffset = 0;
      _isLoadingMore = false;
      _error = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_refs.isEmpty && !_isLoadingMore) _loadPage(offset: 0);
  }

  @override
  void didUpdateWidget(SearchGifsPage old) {
    super.didUpdateWidget(old);
    if (old.variables.query != widget.variables.query) {
      setState(() {
        _refs.clear();
        _hasNextPage = true;
        _nextOffset = 0;
        _isLoadingMore = false;
        _error = null;
      });
      _loadPage(offset: 0);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasNextPage &&
        !_isLoadingMore) {
      _loadPage(offset: _nextOffset);
    }
  }

  Future<void> _loadPage({required int offset}) async {
    setState(() => _isLoadingMore = true);
    final vars = SearchGifsPageVariables(
      query: widget.variables.query,
      offset: offset,
      limit: widget.variables.limit,
    );
    try {
      final data = await ShalomScope.of(context)
          .request<SearchGifsPageData>(
            name: 'SearchGifsPage',
            variables: vars.toJson(),
            decoder: SearchGifsPageData.fromCache,
          )
          .first;
      final page = data.searchGifs;
      final newRefs = page.items.whereType<GifWidgetRef>().toList();
      if (!mounted) return;
      setState(() {
        _refs.addAll(newRefs);
        _hasNextPage = page.hasNextPage;
        _nextOffset = _refs.length;
        _isLoadingMore = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _refs.isEmpty) {
      return Center(child: Text('Error: $_error'));
    }
    if (_refs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
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
        return GifWidget(ref: _refs[index]);
      },
    );
  }
}

// ─── GifWidget fragment ───────────────────────────────────────────────────────

@Fragment(r"""
  on Gif {
    id
    title
    url
    previewUrl
  }
""")
class GifWidget extends $GifWidget {
  const GifWidget({super.key, required super.ref});

  @override
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading…'));

  @override
  Widget buildError(BuildContext context, Object error) =>
      ListTile(title: Text('Error: $error'));

  @override
  Widget buildData(BuildContext context, GifWidgetData gif) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: gif.previewUrl != null
            ? Image.network(
                gif.previewUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              )
            : const Icon(Icons.gif, size: 40),
        title: Text(gif.title),
        subtitle: Text(gif.url, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.add_to_photos_outlined),
          tooltip: 'Add to album',
          onPressed: () => _showAddToAlbumDialog(context, gif),
        ),
      ),
    );
  }

  void _showAddToAlbumDialog(BuildContext context, GifWidgetData gif) {
    showDialog<void>(
      context: context,
      builder: (_) => _AddToAlbumDialog(gif: gif),
    );
  }
}

// ─── Albums Tab ───────────────────────────────────────────────────────────────

class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab();

  @override
  Widget build(BuildContext context) {
    return const AlbumsPage();
  }
}

// ─── AlbumsPage query widget ──────────────────────────────────────────────────

@Query(r"""
  {
    albums {
      ...AlbumWidget
    }
  }
""")
class AlbumsPage extends $AlbumsPage with QueryWidgetDefaults {
  const AlbumsPage({super.key});

  @override
  State<$AlbumsPage> createState() => _AlbumsPageState();

  @override
  Widget buildData(BuildContext context, AlbumsPageData data) =>
      throw UnimplementedError();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final _refs = <AlbumWidgetRef>[];
  StreamSubscription<AlbumsPageData>? _sub;
  Object? _error;
  bool _loading = true;

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      _refs.clear();
      _loading = true;
      _error = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sub == null) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    _sub = null;
    setState(() => _loading = true);
    _sub = ShalomScope.of(context)
        .request<AlbumsPageData>(
          name: 'AlbumsPage',
          variables: null,
          decoder: AlbumsPageData.fromCache,
        )
        .listen(
          (data) {
            final newRefs = data.albums.whereType<AlbumWidgetRef>().toList();
            setState(() {
              _refs
                ..clear()
                ..addAll(newRefs);
              _loading = false;
              _error = null;
            });
          },
          onError: (e) => setState(() {
            _error = e;
            _loading = false;
          }),
          onDone: () {
            _sub = null;
            if (mounted) _subscribe();
          },
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAlbumDialog(context),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _refs.isEmpty
          ? const Center(child: Text('No albums yet. Create one!'))
          : ListView.builder(
              itemCount: _refs.length,
              itemBuilder: (context, i) => AlbumWidget(ref: _refs[i]),
            ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _CreateAlbumDialog(onCreated: (_) => _subscribe()),
    );
  }
}

// ─── AlbumWidget fragment ─────────────────────────────────────────────────────

@Fragment(r"""
  on Album {
    id
    name
    tag
    gifs {
      id
      title
    }
  }
""")
class AlbumWidget extends $AlbumWidget {
  final void Function(AlbumWidgetData album)? onTap;

  const AlbumWidget({super.key, required super.ref, this.onTap});

  @override
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading…'));

  @override
  Widget buildError(BuildContext context, Object error) =>
      ListTile(title: Text('Error: $error'));

  @override
  Widget buildData(BuildContext context, AlbumWidgetData album) {
    final gifCount = album.gifs.length;
    final tap = onTap;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.photo_album, size: 40),
        title: Text(album.name),
        subtitle: Text('$gifCount GIF${gifCount == 1 ? '' : 's'} TAG: ${album.tag}'),
        trailing: tap == null ? const Icon(Icons.chevron_right) : null,
        onTap: tap != null
            ? () => tap(album)
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _AlbumDetailPage(
                    albumId: album.id,
                    albumName: album.name,
                    gifs: album.gifs,
                  ),
                ),
              ),
      ),
    );
  }
}

// ─── Mutations ────────────────────────────────────────────────────────────────

@Mutation(r"""
  ($name: String!) {
    createAlbum(name: $name) {
      id
      name
    }
  }
""")
class CreateAlbumMutation extends $CreateAlbumMutation {
  const CreateAlbumMutation(super.client);
}

@Mutation(r"""
  ($albumId: String!, $gifId: String!, $title: String!, $url: String!, $previewUrl: String) {
    addGifToAlbum(albumId: $albumId, gifId: $gifId, title: $title, url: $url, previewUrl: $previewUrl) {
      id
      name
      gifs {
        id
        title
      }
    }
  }
""")
class AddGifToAlbumMutation extends $AddGifToAlbumMutation {
  const AddGifToAlbumMutation(super.client);
}

@Mutation(r"""
  ($albumId: String!, $gifId: String!) {
    removeGifFromAlbum(albumId: $albumId, gifId: $gifId) {
      id
      name
    }
  }
""")
class RemoveGifFromAlbumMutation extends $RemoveGifFromAlbumMutation {
  const RemoveGifFromAlbumMutation(super.client);
}

// ─── Dialog Widgets ───────────────────────────────────────────────────────────

class _CreateAlbumDialog extends StatefulWidget {
  final void Function(CreateAlbumMutationData) onCreated;

  const _CreateAlbumDialog({required this.onCreated});

  @override
  State<_CreateAlbumDialog> createState() => _CreateAlbumDialogState();
}

class _CreateAlbumDialogState extends State<_CreateAlbumDialog> {
  final _nameController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final client = ShalomScope.of(context);
    final nav = Navigator.of(context);
    try {
      final data = await CreateAlbumMutation(client).execute(name: name);
      widget.onCreated(data);
      nav.pop();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Album'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Album name'),
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

// ─── Album Detail Page ────────────────────────────────────────────────────────

class _AlbumDetailPage extends StatelessWidget {
  final String albumId;
  final String albumName;
  final List<AlbumWidget_gifs> gifs;

  const _AlbumDetailPage({
    required this.albumId,
    required this.albumName,
    required this.gifs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(albumName)),
      body: gifs.isEmpty
          ? const Center(child: Text('No GIFs in this album yet.'))
          : ListView.builder(
              itemCount: gifs.length,
              itemBuilder: (context, i) {
                final gif = gifs[i];
                return ListTile(
                  leading: const Icon(Icons.gif),
                  title: Text(gif.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Remove from album',
                    onPressed: () => _removeGif(context, albumId, gif.id),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _removeGif(
    BuildContext context,
    String albumId,
    String gifId,
  ) async {
    final client = ShalomScope.of(context);
    try {
      await RemoveGifFromAlbumMutation(
        client,
      ).execute(albumId: albumId, gifId: gifId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('GIF removed')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _AddToAlbumDialog extends StatefulWidget {
  final GifWidgetData gif;

  const _AddToAlbumDialog({required this.gif});

  @override
  State<_AddToAlbumDialog> createState() => _AddToAlbumDialogState();
}

class _AddToAlbumDialogState extends State<_AddToAlbumDialog> {
  bool _submitting = false;
  String? _error;

  Future<void> _addToAlbum(AlbumWidgetData album) async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final client = ShalomScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final gif = widget.gif;
    try {
      await AddGifToAlbumMutation(client).executeOptimistic(
        (vars) {
          final existingGifs = album.gifs
              .map(
                (g) => AddGifToAlbumMutation_addGifToAlbum_gifs(
                  id: g.id,
                  title: g.title,
                ),
              )
              .toList();
          final nextGifs = existingGifs.any((g) => g.id == vars.gifId)
              ? existingGifs
              : [
                  ...existingGifs,
                  AddGifToAlbumMutation_addGifToAlbum_gifs(
                    id: vars.gifId,
                    title: vars.title,
                  ),
                ];
          return AddGifToAlbumMutationData(
            addGifToAlbum: AddGifToAlbumMutation_addGifToAlbum(
              id: vars.albumId,
              name: album.name,
              gifs: nextGifs,
            ),
          );
        },
        albumId: album.id,
        gifId: gif.id,
        title: gif.title,
        url: gif.url,
        previewUrl: gif.previewUrl != null
            ? shalom.Some(gif.previewUrl)
            : const shalom.None(),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('GIF added to album')),
      );
      nav.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add "${widget.gif.title}" to Album'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlbumPickerQuery(onSelected: _submitting ? (_) {} : _addToAlbum),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_submitting)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
