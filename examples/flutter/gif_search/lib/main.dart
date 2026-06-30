import 'package:flutter/material.dart';
import 'package:gif_search/__graphql__/AddGifToAlbumMutation.mutation.shalom.dart'
    show $AddGifToAlbumMutation;
import 'package:gif_search/__graphql__/AddGifToAlbumMutation.shalom.dart';
import 'package:gif_search/__graphql__/CreateAlbumMutation.mutation.shalom.dart'
    show $CreateAlbumMutation;
import 'package:gif_search/__graphql__/CreateAlbumMutation.shalom.dart'
    show CreateAlbumMutationData;
import 'package:gif_search/__graphql__/DeleteAlbumMutation.mutation.shalom.dart'
    show $DeleteAlbumMutation;
import 'package:gif_search/__graphql__/DeleteAlbumMutation.shalom.dart'
    show DeleteAlbumMutationData;
import 'package:gif_search/__graphql__/RemoveGifFromAlbumMutation.mutation.shalom.dart'
    show $RemoveGifFromAlbumMutation;
import 'package:gif_search/__graphql__/AlbumGifSearch.widget.shalom.dart'
    show
        $AlbumGifSearch,
        AlbumGifSearchData,
        AlbumGifSearchVariables,
        AlbumGifSearch_searchGifs_items;
import 'package:shalom/shalom.dart'
    as shalom
    show
        Some,
        None,
        ShalomRuntimeClient,
        CacheProxy,
        GraphQLData,
        GraphQLError,
        LinkExceptionResponse;
import 'package:shalom_annotations/shalom_annotations.dart';
import 'package:gif_search/graphql/__graphql__/shalom_init.shalom.dart';
import 'package:gif_search/state.dart' show createShalomClient;

import 'package:gif_search/__graphql__/AlbumGif.shalom.dart'
    show $AlbumGif, AlbumGifData;
import 'package:gif_search/__graphql__/AlbumWidget.shalom.dart';
import 'package:gif_search/__graphql__/AlbumsPage.widget.shalom.dart';
import 'package:shalom_flutter/widgets/shalom_provider.dart';
import 'package:shalom_flutter/widgets/debug_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await shalom.ShalomRuntimeClient.initFlutterRustBridge();
  final client = createShalomClient();
  runApp(ShalomProvider(client: client, child: const MyApp()));
}

mixin QueryWidgetMixin {
  Widget buildLoading(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  Widget buildError(BuildContext context, Object error) {
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
      home: const _AppWithDebugPanel(),
    );
  }
}

// ─── App + side-by-side cache debugger ────────────────────────────────────────

const _phoneWidth = 420.0;

class _AppWithDebugPanel extends StatelessWidget {
  const _AppWithDebugPanel();

  @override
  Widget build(BuildContext context) {
    final client = ShalomScope.of(context);
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: _phoneWidth,
            child: Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => const AlbumsPage(),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(title: const Text('Cache Inspector')),
              body: ShalomDebugPanel(client: client),
            ),
          ),
        ],
      ),
    );
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
class AlbumsPage extends $AlbumsPage with QueryWidgetMixin {
  const AlbumsPage({super.key});

  @override
  Widget buildData(BuildContext context, AlbumsPageData data) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAlbumDialog(context),
        child: const Icon(Icons.add),
      ),
      body: data.albums.isEmpty
          ? const Center(child: Text('No albums yet. Create one!'))
          : ListView.builder(
              itemCount: data.albums.length,
              itemBuilder: (context, i) => AlbumWidget(ref: data.albums[i]),
            ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _CreateAlbumDialog(
        onCreated: (cache, data) {
          final current = AlbumsPageData.readFrom(cache);
          if (current == null) return;
          final newRef = AlbumWidgetRef.fromId(data.createAlbum.id);
          cache.writeQuery(
            data: AlbumsPageData(albums: [...current.albums, newRef]),
          );
        },
      ),
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
      ...AlbumGif
    }
  }
""")
class AlbumWidget extends $AlbumWidget with QueryWidgetMixin {
  final void Function(AlbumWidgetData album)? onTap;

  const AlbumWidget({super.key, required super.ref, this.onTap});

  @override
  Widget buildLoading(BuildContext context) =>
      const ListTile(title: Text('Loading…'));

  @override
  Widget buildError(BuildContext context, Object error) {
    super.buildError(context, error);
    return ListTile(title: Text('Error: $error'));
  }

  @override
  Widget buildData(BuildContext context, AlbumWidgetData album) {
    final gifCount = album.gifs.length;
    final tap = onTap;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.photo_album, size: 40),
        title: Text(album.name),
        subtitle: Text(
          '$gifCount GIF${gifCount == 1 ? '' : 's'} · ${album.tag}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete album',
              onPressed: () => _confirmDelete(context, album),
            ),
            if (tap == null) const Icon(Icons.chevron_right),
          ],
        ),
        onTap: tap != null
            ? () => tap(album)
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _AlbumDetailPage(
                    albumId: album.id,
                    albumName: album.name,
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AlbumWidgetData album) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete album?'),
        content: Text('This will permanently delete "${album.name}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final client = ShalomScope.of(context);
    final response = await DeleteAlbumMutation(client).executeWithCacheUpdate(
      id: album.id,
      update: (shalom.CacheProxy cache, DeleteAlbumMutationData data) {
        if (data.deleteAlbum != null) return;
        final current = AlbumsPageData.readFrom(cache);
        if (current == null) return;
        final deletedAnchor = AlbumWidgetData.entityKey(album.id);
        cache.writeQuery(
          data: AlbumsPageData(
            albums: current.albums
                .where((a) => a.anchor != deletedAnchor)
                .toList(),
          ),
        );
      },
    );
    if (!context.mounted) return;
    switch (response) {
      case shalom.GraphQLData(data: final data):
        final error = data.deleteAlbum;
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message)));
        }
      case shalom.GraphQLError():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GraphQL error deleting album')),
        );
      case shalom.LinkExceptionResponse():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error deleting album')),
        );
    }
  }
}

@Fragment(r"""
  on Gif {
    id
    title
    url
  }
""")
class AlbumGif extends $AlbumGif with QueryWidgetMixin {
  const AlbumGif({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, AlbumGifData data) =>
      const SizedBox.shrink();
}

// ─── Mutations ────────────────────────────────────────────────────────────────

@Mutation(r"""
  ($id: String!) {
    deleteAlbum(id: $id) {
      code
      message
    }
  }
""")
class DeleteAlbumMutation extends $DeleteAlbumMutation {
  const DeleteAlbumMutation(super.client);
}

@Mutation(r"""
  ($name: String!) {
    createAlbum(name: $name) {
      id 
      name
      tag
      gifs {
        ...AlbumGif
      }
    }
  }
""")
class CreateAlbumMutation extends $CreateAlbumMutation {
  const CreateAlbumMutation(super.client);
}

@Mutation(r"""
  ($albumId: String!, $title: String!, $url: String!, $previewUrl: String) {
    addGifToAlbum(albumId: $albumId, title: $title, url: $url, previewUrl: $previewUrl) {
      ...AlbumGif
    }
  }
""")
class AddGifToAlbumMutation extends $AddGifToAlbumMutation {
  const AddGifToAlbumMutation(super.client);
}

@Mutation(r"""
  ($albumId: String!, $gifId: String!) {
    removeGifFromAlbum(albumId: $albumId, gifId: $gifId) {
      code
      message
    }
  }
""")
class RemoveGifFromAlbumMutation extends $RemoveGifFromAlbumMutation {
  const RemoveGifFromAlbumMutation(super.client);
}

// Inline GIF search — returns PreviewGif fields for the album detail search bar.
@Query(r"""
  ($query: String!, $offset: Int!, $limit: Int!) {
    searchGifs(query: $query, offset: $offset, limit: $limit) {
      items {
        title
        url
        previewUrl
      }
      hasNextPage
    }
  }
""")
class AlbumGifSearch extends $AlbumGifSearch with QueryWidgetMixin {
  final Set<String> albumGifUrls;
  final void Function(AlbumGifSearch_searchGifs_items gif) onAdd;

  const AlbumGifSearch({
    super.key,
    required super.variables,
    required this.albumGifUrls,
    required this.onAdd,
  });

  @override
  Widget buildData(BuildContext context, AlbumGifSearchData data) {
    final items = data.searchGifs.items;
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No results found')),
      );
    }
    return Column(
      children: [
        for (final gif in items)
          ListTile(
            leading: gif.previewUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      gif.previewUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.gif, size: 48),
                    ),
                  )
                : const Icon(Icons.gif, size: 48),
            title: Text(
              gif.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: albumGifUrls.contains(gif.url)
                ? const Icon(Icons.check_circle, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add to album',
                    onPressed: () => onAdd(gif),
                  ),
          ),
      ],
    );
  }
}

// ─── Dialog Widgets ───────────────────────────────────────────────────────────

class _CreateAlbumDialog extends StatefulWidget {
  final void Function(shalom.CacheProxy cache, CreateAlbumMutationData data)
  onCreated;

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
      final response = await CreateAlbumMutation(
        client,
      ).executeWithCacheUpdate(name: name, update: widget.onCreated);
      if (response case shalom.GraphQLData()) {
        nav.pop();
      } else {
        setState(() {
          _error = 'Mutation failed';
          _loading = false;
        });
      }
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

class _AlbumDetailPage extends StatefulWidget {
  final String albumId;
  final String albumName;

  const _AlbumDetailPage({required this.albumId, required this.albumName});

  @override
  State<_AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<_AlbumDetailPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _committedQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AlbumWidget_gifs> _filteredLocal(AlbumWidgetData album) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return album.gifs;
    return album.gifs.where((g) => g.title.toLowerCase().contains(q)).toList();
  }

  void _onSearch(String query) {
    final q = query.trim();
    setState(() {
      _searchQuery = q;
      _committedQuery = q;
    });
  }

  Future<void> _addGif(AlbumGifSearch_searchGifs_items gif) async {
    final client = ShalomScope.of(context);
    try {
      final response = await AddGifToAlbumMutation(client).executeWithCacheUpdate(
        albumId: widget.albumId,
        title: gif.title,
        url: gif.url,
        previewUrl: gif.previewUrl != null
            ? shalom.Some(gif.previewUrl)
            : const shalom.None(),
        update: (shalom.CacheProxy cache, AddGifToAlbumMutationData data) {
          final current = AlbumWidgetRef.fromId(widget.albumId).readFrom(cache);
          if (current == null) return;
          if (current.gifs.any((g) => g.url == gif.url)) return;
          cache.writeFragment(
            data: AlbumWidgetData(
              id: current.id,
              name: current.name,
              tag: current.tag,
              gifs: [
                ...current.gifs,
                AlbumWidget_gifs(
                  id: data.addGifToAlbum.id,
                  title: data.addGifToAlbum.title,
                  url: data.addGifToAlbum.url,
                ),
              ],
            ),
          );
        },
      );
      if (response is! shalom.GraphQLData) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add GIF')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _removeGif(String gifId) async {
    final client = ShalomScope.of(context);
    try {
      final response = await RemoveGifFromAlbumMutation(client)
          .executeWithCacheUpdate(
            albumId: widget.albumId,
            gifId: gifId,
            update: (shalom.CacheProxy cache, data) {
              if (data.removeGifFromAlbum != null) return;
              final current = cache.readFragment<AlbumWidgetData>(
                fragmentName: 'AlbumWidget',
                entityKey: AlbumWidgetData.entityKey(widget.albumId),
                decoder: AlbumWidgetData.fromCache,
              );
              if (current == null) return;
              cache.writeFragment(
                data: AlbumWidgetData(
                  id: current.id,
                  name: current.name,
                  tag: current.tag,
                  gifs: current.gifs.where((g) => g.id != gifId).toList(),
                ),
              );
            },
          );
      if (!mounted) return;
      switch (response) {
        case shalom.GraphQLData(data: final data):
          final error = data.removeGifFromAlbum;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error == null ? 'GIF removed' : error.message)),
          );
        case shalom.GraphQLError():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('GraphQL error removing GIF')),
          );
        case shalom.LinkExceptionResponse():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Network error removing GIF')),
          );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final searching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(widget.albumName)),
      body: AlbumWidgetScope(
        ref: AlbumWidgetRef.fromId(widget.albumId),
        loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        builder: (context, album) {
          final filtered = _filteredLocal(album);
          final albumGifUrls = album.gifs.map((g) => g.url).toSet();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search in album or find new GIFs…',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (v) {
                    final q = v.trim();
                    setState(() {
                      _searchQuery = q;
                      if (q.isEmpty) _committedQuery = '';
                    });
                  },
                  onSubmitted: _onSearch,
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (searching)
                      const SliverToBoxAdapter(
                        child: _SectionHeader('In this album'),
                      ),
                    if (filtered.isEmpty && !searching)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('No GIFs in this album yet.'),
                        ),
                      )
                    else
                      SliverList.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final gif = filtered[i];
                          return ListTile(
                            leading: const Icon(Icons.gif),
                            title: Text(gif.title),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              tooltip: 'Remove',
                              onPressed: () => _removeGif(gif.id),
                            ),
                          );
                        },
                      ),

                    if (searching) ...[
                      const SliverToBoxAdapter(
                        child: _SectionHeader('From search'),
                      ),
                      if (_committedQuery.isEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: Text('Submit to search')),
                          ),
                        )
                      else
                        SliverToBoxAdapter(
                          child: AlbumGifSearch(
                            variables: AlbumGifSearchVariables(
                              query: _committedQuery,
                              offset: 0,
                              limit: 20,
                            ),
                            albumGifUrls: albumGifUrls,
                            onAdd: _addGif,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 12),
        ],
      ),
    );
  }
}
