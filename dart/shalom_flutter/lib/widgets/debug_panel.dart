import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:shalom/shalom.dart';

import 'shalom_provider.dart';

// ---------------------------------------------------------------------------
// Colors (VS Code dark-theme palette)
// ---------------------------------------------------------------------------

const _kBg = Color(0xFF1E1E1E);
const _kHeaderBg = Color(0xFF252526);
const _kSidebarBg = Color(0xFF16213E);
const _kTitleBg = Color(0xFF1A1A2E);
const _kTabBg = Color(0xFF1E2030);
const _kTabActiveBg = Color(0xFF0D1117);
const _kTabActiveIndicator = Color(0xFF4EC9B0);
const _kKeyColor = Color(0xFF9CDCFE);
const _kStringColor = Color(0xFFCE9178);
const _kNumberColor = Color(0xFFB5CEA8);
const _kBoolNullColor = Color(0xFF569CD6);
const _kPunctColor = Color(0xFFD4D4D4);
const _kMutedColor = Color(0xFF808080);
const _kRefColor = Color(0xFF4EC9B0);
const _kRefBg = Color(0xFF152820);
const _kRefBorder = Color(0xFF2E6655);
const _kSelectedBg = Color(0xFF0F3460);
const _kObsBadgeBg = Color(0xFF1A2A1A);
const _kObsBadgeColor = Color(0xFF6A9955);
const _kDividerColor = Color(0xFF333355);
const _kHoverBg = Color(0x14FFFFFF);
const _kSelectionHighlight = Color(0x664EC9B0);
const _kScrim = Color(0xDD000000);
const _kWhite = Color(0xFFFFFFFF);
const _kWhite70 = Color(0xB3FFFFFF);
const _kWhite54 = Color(0x8AFFFFFF);
const _kWhite38 = Color(0x61FFFFFF);
const _kWhite24 = Color(0x3DFFFFFF);
const _kTransparent = Color(0x00000000);

// ---------------------------------------------------------------------------
// Panel tab
// ---------------------------------------------------------------------------

enum _PanelTab { queries, mutations, cache }

// ---------------------------------------------------------------------------
// Public widget
// ---------------------------------------------------------------------------

/// A debug panel that displays the live state of the Shalom normalized cache,
/// with Apollo-style Queries / Mutations / Cache tabs and observer info.
class ShalomDebugPanel extends StatefulWidget {
  final ShalomRuntimeClient client;
  final Duration refreshInterval;

  const ShalomDebugPanel({
    super.key,
    required this.client,
    this.refreshInterval = const Duration(seconds: 1),
  });

  static Widget overlay({
    required Widget child,
    Duration refreshInterval = const Duration(seconds: 1),
  }) {
    return _ShalomDebugOverlay(refreshInterval: refreshInterval, child: child);
  }

  @override
  State<ShalomDebugPanel> createState() => _ShalomDebugPanelState();
}

// ---------------------------------------------------------------------------
// Panel state
// ---------------------------------------------------------------------------

class _ShalomDebugPanelState extends State<ShalomDebugPanel> {
  _PanelTab _tab = _PanelTab.queries;

  Map<String, dynamic> _rootQueryFields = {};
  Map<String, dynamic> _rootMutationFields = {};
  List<String> _allKeys = [];
  Map<String, int> _obsCounts = {};
  List<ObserverInfo> _allObservers = [];
  dynamic _selectedCacheValue;
  List<ObserverInfo> _selectedCacheObservers = [];

  String? _selectedQueryField;
  String? _selectedMutationField;
  String? _selectedCacheKey;

  final List<
      ({
        _PanelTab tab,
        String? queryField,
        String? mutationField,
        String? cacheKey,
      })> _history = [];

  String _filter = '';
  final TextEditingController _filterController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(widget.refreshInterval, (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final keys = await widget.client.getCacheKeys();
    final rootQueryFields = _parseRecord(
      await widget.client.getCacheEntry('ROOT_QUERY'),
    );
    final rootMutationFields = _parseRecord(
      await widget.client.getCacheEntry('ROOT_MUTATION'),
    );
    final obsCounts = await widget.client.getObserverCounts();
    final allObservers = await widget.client.getAllObservers();
    final selectedCacheValue = await _loadSelectedCacheValue();
    final selectedCacheObservers = await _loadSelectedCacheObservers();
    if (mounted) {
      setState(() {
        _allKeys = keys;
        _rootQueryFields = rootQueryFields;
        _rootMutationFields = rootMutationFields;
        _obsCounts = obsCounts;
        _allObservers = allObservers;
        _selectedCacheValue = selectedCacheValue;
        _selectedCacheObservers = selectedCacheObservers;
      });
    }
  }

  Future<dynamic> _loadSelectedCacheValue() async {
    final key = _selectedCacheKey;
    if (key == null) return null;
    final json = await widget.client.getCacheEntry(key);
    if (json == null) return null;
    try {
      return jsonDecode(json);
    } catch (_) {
      return json;
    }
  }

  Future<List<ObserverInfo>> _loadSelectedCacheObservers() async {
    final key = _selectedCacheKey;
    if (key == null) return [];
    return widget.client.getKeyObservers(key);
  }

  static Map<String, dynamic> _parseRecord(String? json) {
    if (json == null) return {};
    try {
      return (jsonDecode(json) as Map).cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  void _switchTab(_PanelTab tab) {
    setState(() {
      _tab = tab;
      _filter = '';
      _filterController.clear();
    });
    _refresh();
  }

  void _navigateToRef(String refKey) {
    _history.add((
      tab: _tab,
      queryField: _selectedQueryField,
      mutationField: _selectedMutationField,
      cacheKey: _selectedCacheKey,
    ));
    setState(() {
      _tab = _PanelTab.cache;
      _selectedCacheKey = refKey;
      _filter = '';
      _filterController.clear();
    });
    _refresh();
  }

  void _goBack() {
    if (_history.isEmpty) return;
    final prev = _history.removeLast();
    setState(() {
      _tab = prev.tab;
      _selectedQueryField = prev.queryField;
      _selectedMutationField = prev.mutationField;
      _selectedCacheKey = prev.cacheKey;
      _filter = '';
      _filterController.clear();
    });
    _refresh();
  }

  // ---- Derived state -------------------------------------------------------

  List<String> get _leftItems {
    final keys = switch (_tab) {
      _PanelTab.queries => _rootQueryFields.keys.toList(),
      _PanelTab.mutations => _rootMutationFields.keys.toList(),
      _PanelTab.cache => _allKeys,
    };
    if (_filter.isEmpty) return keys;
    final lower = _filter.toLowerCase();
    return keys.where((k) => k.toLowerCase().contains(lower)).toList();
  }

  String? get _selectedItem => switch (_tab) {
        _PanelTab.queries => _selectedQueryField,
        _PanelTab.mutations => _selectedMutationField,
        _PanelTab.cache => _selectedCacheKey,
      };

  void _onItemSelected(String item) {
    setState(() {
      switch (_tab) {
        case _PanelTab.queries:
          _selectedQueryField = item;
        case _PanelTab.mutations:
          _selectedMutationField = item;
        case _PanelTab.cache:
          _selectedCacheKey = item;
      }
    });
    if (_tab == _PanelTab.cache) {
      _refresh();
    }
  }

  dynamic get _rightValue {
    switch (_tab) {
      case _PanelTab.queries:
        if (_selectedQueryField == null) return null;
        return _rootQueryFields[_selectedQueryField];
      case _PanelTab.mutations:
        if (_selectedMutationField == null) return null;
        return _rootMutationFields[_selectedMutationField];
      case _PanelTab.cache:
        return _selectedCacheValue;
    }
  }

  /// Observers relevant to whatever is currently selected.
  List<ObserverInfo> get _relevantObservers {
    switch (_tab) {
      case _PanelTab.queries:
        // All query-type operation observers
        return _allObservers
            .where((o) => o.kind == 'operation' && o.opType == 'query')
            .toList();
      case _PanelTab.mutations:
        // All mutation-type operation observers
        return _allObservers
            .where((o) => o.kind == 'operation' && o.opType == 'mutation')
            .toList();
      case _PanelTab.cache:
        return _selectedCacheObservers;
    }
  }

  // ---- Build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _kBg,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          height: 1.5,
          color: _kPunctColor,
        ),
        child: Column(
          children: [
            _PanelHeader(onRefresh: _refresh),
            _TabBar(
              tab: _tab,
              queryCount: _rootQueryFields.length,
              mutationCount: _rootMutationFields.length,
              onTabSelected: _switchTab,
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 230,
                    child: _LeftPane(
                      items: _leftItems,
                      selectedItem: _selectedItem,
                      filter: _filter,
                      filterController: _filterController,
                      totalCount: switch (_tab) {
                        _PanelTab.queries => _rootQueryFields.length,
                        _PanelTab.mutations => _rootMutationFields.length,
                        _PanelTab.cache => _allKeys.length,
                      },
                      // Observer badge only makes sense per-entity (Cache tab)
                      obsCounts:
                          _tab == _PanelTab.cache ? _obsCounts : const {},
                      emptyHint: switch (_tab) {
                        _PanelTab.queries => 'No active queries',
                        _PanelTab.mutations => 'No mutations in cache',
                        _PanelTab.cache => 'Cache is empty',
                      },
                      onFilterChanged: (v) => setState(() => _filter = v),
                      onItemSelected: _onItemSelected,
                    ),
                  ),
                  const SizedBox(
                      width: 1, child: ColoredBox(color: _kDividerColor)),
                  Expanded(
                    child: _RightPane(
                      label: _selectedItem,
                      value: _rightValue,
                      observers: _relevantObservers,
                      canGoBack: _history.isNotEmpty,
                      onGoBack: _goBack,
                      onNavigateToRef: _navigateToRef,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Panel header
// ---------------------------------------------------------------------------

class _PanelHeader extends StatelessWidget {
  final VoidCallback onRefresh;
  const _PanelHeader({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kTitleBg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const _Glyph(_GlyphKind.database, color: _kKeyColor, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Shalom Cache Inspector',
            style: TextStyle(
              color: _kWhite,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          _IconButton(
            identifier: 'shalom-inspector-refresh',
            label: 'Refresh',
            glyph: _GlyphKind.refresh,
            color: _kWhite70,
            size: 16,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab bar
// ---------------------------------------------------------------------------

class _TabBar extends StatelessWidget {
  final _PanelTab tab;
  final int queryCount;
  final int mutationCount;
  final void Function(_PanelTab) onTabSelected;

  const _TabBar({
    required this.tab,
    required this.queryCount,
    required this.mutationCount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kTabBg,
      child: Row(
        children: [
          _TabItem(
            label: 'Queries',
            count: queryCount,
            selected: tab == _PanelTab.queries,
            onTap: () => onTabSelected(_PanelTab.queries),
          ),
          _TabItem(
            label: 'Mutations',
            count: mutationCount,
            selected: tab == _PanelTab.mutations,
            onTap: () => onTabSelected(_PanelTab.mutations),
          ),
          _TabItem(
            label: 'Cache',
            selected: tab == _PanelTab.cache,
            onTap: () => onTabSelected(_PanelTab.cache),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Clickable(
      identifier: 'shalom-inspector-tab-${label.toLowerCase()}',
      label: label,
      selected: selected,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: selected ? _kTabActiveBg : _kTransparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count != null ? '$label ($count)' : label,
              style: TextStyle(
                color: selected ? _kWhite : _kWhite54,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 2,
              width: 40,
              color: selected ? _kTabActiveIndicator : _kTransparent,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Left pane
// ---------------------------------------------------------------------------

class _LeftPane extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final String filter;
  final TextEditingController filterController;
  final int totalCount;
  final Map<String, int> obsCounts;
  final String emptyHint;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onItemSelected;

  const _LeftPane({
    required this.items,
    required this.selectedItem,
    required this.filter,
    required this.filterController,
    required this.totalCount,
    required this.obsCounts,
    required this.emptyHint,
    required this.onFilterChanged,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSidebarBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: _FilterField(
              controller: filterController,
              onChanged: onFilterChanged,
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      emptyHint,
                      style: const TextStyle(
                        color: _kWhite38,
                        fontSize: 11,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final selected = item == selectedItem;
                      final obsCount = obsCounts[item];

                      final parenIdx = item.indexOf('(');
                      final displayName =
                          parenIdx == -1 ? item : item.substring(0, parenIdx);
                      final hasArgs = parenIdx != -1;

                      return _Clickable(
                        identifier: 'shalom-inspector-item-$item',
                        label: item,
                        selected: selected,
                        hoverColor: _kHoverBg,
                        onTap: () => onItemSelected(item),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
                          color: selected ? _kSelectedBg : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: TextStyle(
                                        color:
                                            selected ? _kKeyColor : _kWhite70,
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                        fontWeight: selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (hasArgs)
                                      Text(
                                        item.substring(parenIdx),
                                        style: const TextStyle(
                                          color: _kMutedColor,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                  ],
                                ),
                              ),
                              if (obsCount != null && obsCount > 0)
                                _ObsBadge(count: obsCount),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                filter.isEmpty
                    ? '$totalCount item${totalCount == 1 ? '' : 's'}'
                    : '${items.length} / $totalCount items',
                style: const TextStyle(color: _kWhite38, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Green badge showing observer count — `👁 2`.
class _ObsBadge extends StatelessWidget {
  final int count;
  const _ObsBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: _kObsBadgeBg,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: _kObsBadgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Glyph(
            _GlyphKind.eye,
            size: 9,
            color: _kObsBadgeColor,
          ),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: const TextStyle(
              color: _kObsBadgeColor,
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Right pane — Cached Data / Observers sub-tabs
// ---------------------------------------------------------------------------

class _RightPane extends StatefulWidget {
  final String? label;
  final dynamic value;
  final List<ObserverInfo> observers;
  final bool canGoBack;
  final VoidCallback onGoBack;
  final void Function(String) onNavigateToRef;

  const _RightPane({
    this.label,
    this.value,
    required this.observers,
    required this.canGoBack,
    required this.onGoBack,
    required this.onNavigateToRef,
  });

  @override
  State<_RightPane> createState() => _RightPaneState();
}

class _RightPaneState extends State<_RightPane> {
  bool _showObservers = false;

  @override
  void didUpdateWidget(_RightPane old) {
    super.didUpdateWidget(old);
    if (old.label != widget.label) _showObservers = false;
  }

  String _toRawJson(dynamic v) {
    try {
      return const JsonEncoder.withIndent('  ').convert(v);
    } catch (_) {
      return '$v';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null) {
      return const Center(
        child: Text(
          'Select an item to inspect',
          style: TextStyle(color: _kWhite38, fontSize: 12),
        ),
      );
    }
    if (widget.value == null) {
      return Center(
        child: Text(
          '"${widget.label}" not in cache',
          style: const TextStyle(color: _kWhite38, fontSize: 12),
        ),
      );
    }

    final rawJson = _toRawJson(widget.value);
    final obsCount = widget.observers.length;

    return Container(
      color: _kBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar
          Container(
            color: _kHeaderBg,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                if (widget.canGoBack) ...[
                  _IconButton(
                    identifier: 'shalom-inspector-back',
                    label: 'Go back',
                    glyph: _GlyphKind.back,
                    color: _kWhite70,
                    size: 14,
                    onPressed: widget.onGoBack,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      color: _kRefColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (obsCount > 0) ...[
                  _ObsBadge(count: obsCount),
                  const SizedBox(width: 4),
                ],
                _IconButton(
                  identifier: 'shalom-inspector-copy',
                  label: 'Copy raw JSON',
                  glyph: _GlyphKind.copy,
                  color: _kWhite38,
                  size: 14,
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: rawJson)),
                ),
              ],
            ),
          ),
          // Sub-tabs: Cached Data | Observers (N)
          Container(
            color: _kTabBg,
            child: Row(
              children: [
                _SubTabItem(
                  label: 'Cached Data',
                  selected: !_showObservers,
                  onTap: () => setState(() => _showObservers = false),
                ),
                _SubTabItem(
                  label: 'Observers',
                  count: obsCount,
                  selected: _showObservers,
                  onTap: () => setState(() => _showObservers = true),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _showObservers
                ? _ObserverList(
                    observers: widget.observers,
                    onNavigateToKey: widget.onNavigateToRef,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: _JsonValue(
                      value: widget.value,
                      depth: 0,
                      startExpanded: true,
                      onNavigateToRef: widget.onNavigateToRef,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubTabItem extends StatelessWidget {
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  const _SubTabItem({
    required this.label,
    this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = count != null ? '$label ($count)' : label;
    return _Clickable(
      identifier:
          'shalom-inspector-subtab-${label.toLowerCase().replaceAll(' ', '-')}',
      label: label,
      selected: selected,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? _kTabActiveIndicator : _kTransparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? _kWhite : _kWhite54,
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Observer list
// ---------------------------------------------------------------------------

class _ObserverList extends StatelessWidget {
  final List<ObserverInfo> observers;
  final void Function(String) onNavigateToKey;

  const _ObserverList({required this.observers, required this.onNavigateToKey});

  @override
  Widget build(BuildContext context) {
    if (observers.isEmpty) {
      return const Center(
        child: Text(
          'No active observers\n(entry may be GC\'d soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kWhite38, fontSize: 12),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: observers.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.5),
        child: SizedBox(height: 1, child: ColoredBox(color: _kDividerColor)),
      ),
      itemBuilder: (_, i) =>
          _ObserverCard(info: observers[i], onNavigateToKey: onNavigateToKey),
    );
  }
}

class _ObserverCard extends StatefulWidget {
  final ObserverInfo info;
  final void Function(String) onNavigateToKey;

  const _ObserverCard({required this.info, required this.onNavigateToKey});

  @override
  State<_ObserverCard> createState() => _ObserverCardState();
}

class _ObserverCardState extends State<_ObserverCard> {
  bool _keysExpanded = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final isFragment = info.kind == 'fragment';
    final icon = isFragment ? _GlyphKind.tree : _GlyphKind.bolt;
    final kindColor = isFragment ? _kRefColor : const Color(0xFFDCDCAA);
    final opTypeLabel = info.opType != null ? ' · ${info.opType}' : '';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2A2A4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name row
          Row(
            children: [
              _Glyph(icon, size: 13, color: kindColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  info.name,
                  style: TextStyle(
                    color: kindColor,
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${info.kind}$opTypeLabel',
                style: const TextStyle(
                  color: _kMutedColor,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '#${info.id}',
                style: const TextStyle(
                  color: _kMutedColor,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          // Anchor (fragments only)
          if (info.anchor != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'anchor: ',
                  style: TextStyle(color: _kMutedColor, fontSize: 11),
                ),
                _Clickable(
                  label: 'Go to ${info.anchor!}',
                  onTap: () => widget.onNavigateToKey(info.anchor!),
                  child: Text(
                    info.anchor!,
                    style: const TextStyle(
                      color: _kRefColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
          // Variables
          if (info.variablesJson != null &&
              info.variablesJson != 'null' &&
              info.variablesJson != '{}') ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'variables:',
                    style: TextStyle(color: _kMutedColor, fontSize: 11),
                  ),
                ),
                _IconButton(
                  glyph: _GlyphKind.copy,
                  color: _kMutedColor,
                  size: 13,
                  label: 'Copy variables',
                  identifier: 'shalom-inspector-copy-variables-${info.id}',
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: info.variablesJson!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                _prettyJson(info.variablesJson!),
                style: const TextStyle(
                  color: _kStringColor,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          // Watched keys (collapsible)
          const SizedBox(height: 6),
          _Clickable(
            onTap: () => setState(() => _keysExpanded = !_keysExpanded),
            child: Row(
              children: [
                _Glyph(
                  _keysExpanded
                      ? _GlyphKind.chevronDown
                      : _GlyphKind.chevronRight,
                  size: 13,
                  color: _kMutedColor,
                ),
                Text(
                  'observes ${info.watchedKeys.length} key${info.watchedKeys.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: _kMutedColor,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          if (_keysExpanded) ...[
            const SizedBox(height: 4),
            for (final key in info.watchedKeys)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 2),
                child: _Clickable(
                  label: 'Go to $key',
                  onTap: () => widget.onNavigateToKey(key),
                  child: Text(
                    key,
                    style: const TextStyle(
                      color: _kKeyColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _prettyJson(String raw) {
    try {
      return const JsonEncoder.withIndent('  ').convert(jsonDecode(raw));
    } catch (_) {
      return raw;
    }
  }
}

// ---------------------------------------------------------------------------
// JSON tree
// ---------------------------------------------------------------------------

class _JsonValue extends StatelessWidget {
  final dynamic value;
  final int depth;
  final bool startExpanded;
  final void Function(String) onNavigateToRef;

  const _JsonValue({
    required this.value,
    required this.depth,
    required this.startExpanded,
    required this.onNavigateToRef,
  });

  @override
  Widget build(BuildContext context) {
    if (value is Map) {
      final map = (value as Map).cast<String, dynamic>();
      if (map.length == 1 && map['__ref'] is String) {
        final refKey = map['__ref'] as String;
        return _RefChip(refKey: refKey, onTap: () => onNavigateToRef(refKey));
      }
      if (map.isEmpty) {
        return const Text(
          '{ }',
          style: TextStyle(color: _kPunctColor, fontSize: 12),
        );
      }
      return _JsonObjectNode(
        entries: map.entries.toList(),
        depth: depth,
        startExpanded: startExpanded,
        onNavigateToRef: onNavigateToRef,
      );
    }
    if (value is List) {
      final list = value as List;
      if (list.isEmpty) {
        return const Text(
          '[ ]',
          style: TextStyle(color: _kPunctColor, fontSize: 12),
        );
      }
      return _JsonArrayNode(
        items: list,
        depth: depth,
        startExpanded: startExpanded,
        onNavigateToRef: onNavigateToRef,
      );
    }
    return _JsonScalar(value: value);
  }
}

class _JsonObjectNode extends StatefulWidget {
  final List<MapEntry<String, dynamic>> entries;
  final int depth;
  final bool startExpanded;
  final void Function(String) onNavigateToRef;

  const _JsonObjectNode({
    required this.entries,
    required this.depth,
    required this.startExpanded,
    required this.onNavigateToRef,
  });

  @override
  State<_JsonObjectNode> createState() => _JsonObjectNodeState();
}

class _JsonObjectNodeState extends State<_JsonObjectNode> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.startExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return _ExpandHeader(
        open: '{',
        close: '}',
        summary:
            '${widget.entries.length} field${widget.entries.length == 1 ? '' : 's'}',
        onTap: () => setState(() => _expanded = true),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CollapseHeader(
          bracket: '{',
          onTap: () => setState(() => _expanded = false),
        ),
        for (final e in widget.entries)
          _KeyValueRow(
            label: '"${e.key}"',
            value: e.value,
            depth: widget.depth + 1,
            onNavigateToRef: widget.onNavigateToRef,
          ),
        const Text('}', style: TextStyle(color: _kPunctColor, fontSize: 12)),
      ],
    );
  }
}

class _JsonArrayNode extends StatefulWidget {
  final List<dynamic> items;
  final int depth;
  final bool startExpanded;
  final void Function(String) onNavigateToRef;

  const _JsonArrayNode({
    required this.items,
    required this.depth,
    required this.startExpanded,
    required this.onNavigateToRef,
  });

  @override
  State<_JsonArrayNode> createState() => _JsonArrayNodeState();
}

class _JsonArrayNodeState extends State<_JsonArrayNode> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.startExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return _ExpandHeader(
        open: '[',
        close: ']',
        summary:
            '${widget.items.length} item${widget.items.length == 1 ? '' : 's'}',
        onTap: () => setState(() => _expanded = true),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CollapseHeader(
          bracket: '[',
          onTap: () => setState(() => _expanded = false),
        ),
        for (var i = 0; i < widget.items.length; i++)
          _KeyValueRow(
            label: '$i',
            isIndex: true,
            value: widget.items[i],
            depth: widget.depth + 1,
            onNavigateToRef: widget.onNavigateToRef,
          ),
        const Text(']', style: TextStyle(color: _kPunctColor, fontSize: 12)),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final bool isIndex;
  final dynamic value;
  final int depth;
  final void Function(String) onNavigateToRef;

  const _KeyValueRow({
    required this.label,
    required this.value,
    required this.depth,
    required this.onNavigateToRef,
    this.isIndex = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: isIndex ? _kMutedColor : _kKeyColor,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Expanded(
            child: _JsonValue(
              value: value,
              depth: depth,
              startExpanded: false,
              onNavigateToRef: onNavigateToRef,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandHeader extends StatelessWidget {
  final String open;
  final String close;
  final String summary;
  final VoidCallback onTap;

  const _ExpandHeader({
    required this.open,
    required this.close,
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Clickable(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Glyph(_GlyphKind.chevronRight, size: 14, color: _kMutedColor),
          Text(open, style: const TextStyle(color: _kPunctColor, fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            summary,
            style: const TextStyle(
              color: _kMutedColor,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            close,
            style: const TextStyle(color: _kPunctColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CollapseHeader extends StatelessWidget {
  final String bracket;
  final VoidCallback onTap;

  const _CollapseHeader({required this.bracket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Clickable(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Glyph(_GlyphKind.chevronDown, size: 14, color: _kMutedColor),
          Text(
            bracket,
            style: const TextStyle(color: _kPunctColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _JsonScalar extends StatelessWidget {
  final dynamic value;
  const _JsonScalar({required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const Text(
        'null',
        style: TextStyle(
          color: _kBoolNullColor,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      );
    }
    if (value is bool) {
      return Text(
        '$value',
        style: const TextStyle(
          color: _kBoolNullColor,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      );
    }
    if (value is String) {
      return Text(
        '"$value"',
        style: const TextStyle(
          color: _kStringColor,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      );
    }
    return Text(
      '$value',
      style: const TextStyle(
        color: _kNumberColor,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    );
  }
}

class _RefChip extends StatelessWidget {
  final String refKey;
  final VoidCallback onTap;

  const _RefChip({required this.refKey, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Clickable(
      identifier: 'shalom-inspector-ref-$refKey',
      label: 'Go to cached $refKey',
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: _kRefBg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _kRefBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Glyph(_GlyphKind.link, size: 11, color: _kRefColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                refKey,
                style: const TextStyle(
                  color: _kRefColor,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '→ Go to cached',
              style: TextStyle(
                color: _kMutedColor,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overlay wrapper
// ---------------------------------------------------------------------------

class _ShalomDebugOverlay extends StatefulWidget {
  final Widget child;
  final Duration refreshInterval;

  const _ShalomDebugOverlay({
    required this.child,
    required this.refreshInterval,
  });

  @override
  State<_ShalomDebugOverlay> createState() => _ShalomDebugOverlayState();
}

class _ShalomDebugOverlayState extends State<_ShalomDebugOverlay> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_open)
          Positioned.fill(
            child: ColoredBox(
              color: _kScrim,
              child: SafeArea(
                child: ShalomDebugPanel(
                  client: ShalomScope.of(context),
                  refreshInterval: widget.refreshInterval,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 16,
          child: _Clickable(
            identifier: 'shalom-inspector-toggle',
            label: _open
                ? 'Close Shalom Cache Inspector'
                : 'Shalom Cache Inspector',
            onTap: () => setState(() => _open = !_open),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: _kSelectedBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: _Glyph(
                _open ? _GlyphKind.close : _GlyphKind.database,
                color: _kWhite,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Design-system-free primitives
//
// The inspector is built purely on `package:flutter/widgets.dart` so it does
// not depend on `material_ui` / `cupertino_ui` and renders the same in any app.
// ---------------------------------------------------------------------------

/// A tappable region with a click cursor, optional hover highlight and
/// button semantics (used as a replacement for `InkWell`).
class _Clickable extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final String? label;
  final String? identifier;
  final bool selected;
  final Color? hoverColor;

  const _Clickable({
    required this.onTap,
    required this.child,
    this.label,
    this.identifier,
    this.selected = false,
    this.hoverColor,
  });

  @override
  State<_Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<_Clickable> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    final hoverColor = widget.hoverColor;
    if (hoverColor != null) {
      child = ColoredBox(
        color: _hovered ? hoverColor : _kTransparent,
        child: child,
      );
    }
    return Semantics(
      identifier: widget.identifier,
      label: widget.label,
      button: true,
      selected: widget.selected,
      excludeSemantics: widget.label != null,
      onTap: widget.onTap,
      child: FocusableActionDetector(
        onFocusChange: (focused) => setState(() => _focused = focused),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: _focused ? Border.all(color: _kKeyColor, width: 2) : null,
          ),
          position: DecorationPosition.foreground,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact square icon button (replacement for `IconButton`).
class _IconButton extends StatelessWidget {
  final _GlyphKind glyph;
  final Color color;
  final double size;
  final String label;
  final String identifier;
  final VoidCallback onPressed;

  const _IconButton({
    required this.glyph,
    required this.color,
    required this.size,
    required this.label,
    required this.identifier,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _Clickable(
      identifier: identifier,
      label: label,
      hoverColor: _kHoverBg,
      onTap: onPressed,
      child: SizedBox(
        width: size + 12,
        height: size + 12,
        child: Center(
          child: _Glyph(glyph, color: color, size: size),
        ),
      ),
    );
  }
}

/// A bordered single-line text input built on [EditableText]
/// (replacement for a material `TextField`).
class _FilterField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _FilterField({required this.controller, required this.onChanged});

  @override
  State<_FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<_FilterField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  late final TextSelectionGestureDetectorBuilder _selectionGestures =
      TextSelectionGestureDetectorBuilder(delegate: this);
  final _selectionControls = _InspectorSelectionControls();
  final FocusNode _focusNode = FocusNode(debugLabel: 'ShalomInspectorFilter');

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  Widget _buildContextMenu(EditableTextState editableText) {
    final anchors = editableText.contextMenuAnchors;
    return CustomSingleChildLayout(
      delegate: TextSelectionToolbarLayoutDelegate(
        anchorAbove: anchors.primaryAnchor,
        anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _kHeaderBg,
          border: Border.all(color: _kWhite24),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Wrap(
          children: [
            for (final item in editableText.contextMenuButtonItems)
              if (item.onPressed != null)
                _Clickable(
                  label: item.label ?? _contextMenuLabel(item.type),
                  hoverColor: _kHoverBg,
                  onTap: item.onPressed!,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      item.label ?? _contextMenuLabel(item.type),
                      style: const TextStyle(color: _kWhite, fontSize: 12),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _contextMenuLabel(ContextMenuButtonType type) => switch (type) {
    ContextMenuButtonType.cut => 'Cut',
    ContextMenuButtonType.copy => 'Copy',
    ContextMenuButtonType.paste => 'Paste',
    ContextMenuButtonType.selectAll => 'Select all',
    _ => type.name,
  };

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: _kWhite,
      fontSize: 11,
      height: 1.3,
      fontFamily: 'monospace',
    );
    return Semantics(
      identifier: 'shalom-inspector-filter',
      textField: true,
      label: 'Filter',
      child: _selectionGestures.buildGestureDetector(
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(
          cursor: SystemMouseCursors.text,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _focusNode.hasFocus ? _kKeyColor : _kWhite24,
              ),
            ),
            child: Stack(
              children: [
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder: (_, value, __) => value.text.isEmpty
                      ? const Text(
                          'Filter…',
                          style: TextStyle(
                            color: _kWhite38,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                EditableText(
                  key: editableTextKey,
                  rendererIgnoresPointer: true,
                  selectionControls: _selectionControls,
                  showSelectionHandles: switch (defaultTargetPlatform) {
                    TargetPlatform.android ||
                    TargetPlatform.iOS ||
                    TargetPlatform.fuchsia => true,
                    _ => false,
                  },
                  contextMenuBuilder: (context, editableText) =>
                      _buildContextMenu(editableText),
                  controller: widget.controller,
                  focusNode: _focusNode,
                  style: style,
                  cursorColor: _kKeyColor,
                  backgroundCursorColor: _kMutedColor,
                  selectionColor: _kSelectionHighlight,
                  maxLines: 1,
                  onChanged: widget.onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Selection handles that do not require a Material or Cupertino ancestor.
class _InspectorSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  @override
  Size getHandleSize(double textLineHeight) => const Size(16, 16);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) =>
      const Offset(8, 0);

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) => GestureDetector(
    onTap: onTap,
    child: const SizedBox(
      width: 16,
      height: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(color: _kKeyColor, shape: BoxShape.circle),
      ),
    ),
  );
}

enum _GlyphKind {
  database,
  refresh,
  back,
  copy,
  eye,
  tree,
  bolt,
  chevronRight,
  chevronDown,
  link,
  close,
}

/// A tiny vector icon set drawn with [CustomPaint], so the inspector does not
/// rely on the host app bundling the MaterialIcons / CupertinoIcons fonts.
class _Glyph extends StatelessWidget {
  final _GlyphKind kind;
  final Color color;
  final double size;

  const _Glyph(this.kind, {required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _GlyphPainter(kind, color),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  final _GlyphKind kind;
  final Color color;

  const _GlyphPainter(this.kind, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset p(double x, double y) => Offset(x * s, y * s);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (s * 0.1).clamp(1.0, 2.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path poly(List<Offset> pts, {bool close = false}) {
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
      if (close) path.close();
      return path;
    }

    switch (kind) {
      case _GlyphKind.database:
        final top = Rect.fromLTRB(0.18 * s, 0.12 * s, 0.82 * s, 0.32 * s);
        canvas.drawOval(top, stroke);
        canvas.drawLine(p(0.18, 0.22), p(0.18, 0.78), stroke);
        canvas.drawLine(p(0.82, 0.22), p(0.82, 0.78), stroke);
        canvas.drawArc(
            top.shift(Offset(0, 0.28 * s)), 0, 3.1416, false, stroke);
        canvas.drawArc(
            top.shift(Offset(0, 0.56 * s)), 0, 3.1416, false, stroke);
      case _GlyphKind.refresh:
        final rect = Rect.fromCircle(center: p(0.5, 0.5), radius: 0.32 * s);
        canvas.drawArc(rect, -1.2, 5.0, false, stroke);
        canvas.drawPath(
          poly([p(0.62, 0.06), p(0.68, 0.22), p(0.52, 0.28)]),
          stroke,
        );
      case _GlyphKind.back:
        canvas.drawLine(p(0.82, 0.5), p(0.2, 0.5), stroke);
        canvas.drawPath(
            poly([p(0.45, 0.25), p(0.2, 0.5), p(0.45, 0.75)]), stroke);
      case _GlyphKind.copy:
        canvas.drawRRect(
          RRect.fromLTRBR(0.32 * s, 0.32 * s, 0.86 * s, 0.86 * s,
              Radius.circular(0.08 * s)),
          stroke,
        );
        canvas.drawPath(
          poly([
            p(0.18, 0.66),
            p(0.14, 0.66),
            p(0.14, 0.14),
            p(0.66, 0.14),
            p(0.66, 0.18)
          ]),
          stroke,
        );
      case _GlyphKind.eye:
        final path = Path()
          ..moveTo(0.06 * s, 0.5 * s)
          ..quadraticBezierTo(0.5 * s, 0.0, 0.94 * s, 0.5 * s)
          ..quadraticBezierTo(0.5 * s, 1.0 * s, 0.06 * s, 0.5 * s)
          ..close();
        canvas.drawPath(path, stroke);
        canvas.drawCircle(p(0.5, 0.5), 0.13 * s, fill);
      case _GlyphKind.tree:
        canvas.drawRect(
            Rect.fromLTWH(0.1 * s, 0.1 * s, 0.26 * s, 0.26 * s), stroke);
        canvas.drawRect(
            Rect.fromLTWH(0.64 * s, 0.37 * s, 0.26 * s, 0.26 * s), stroke);
        canvas.drawRect(
            Rect.fromLTWH(0.64 * s, 0.7 * s, 0.26 * s, 0.22 * s), stroke);
        canvas.drawPath(
          poly([p(0.23, 0.36), p(0.23, 0.81), p(0.64, 0.81)]),
          stroke,
        );
        canvas.drawLine(p(0.23, 0.5), p(0.64, 0.5), stroke);
      case _GlyphKind.bolt:
        canvas.drawPath(
          poly([
            p(0.58, 0.04),
            p(0.2, 0.56),
            p(0.48, 0.56),
            p(0.4, 0.96),
            p(0.8, 0.42),
            p(0.52, 0.42)
          ], close: true),
          stroke,
        );
      case _GlyphKind.chevronRight:
        canvas.drawPath(
            poly([p(0.38, 0.22), p(0.66, 0.5), p(0.38, 0.78)]), stroke);
      case _GlyphKind.chevronDown:
        canvas.drawPath(
            poly([p(0.22, 0.38), p(0.5, 0.66), p(0.78, 0.38)]), stroke);
      case _GlyphKind.link:
        final r = Radius.circular(0.15 * s);
        canvas.drawRRect(
            RRect.fromLTRBR(0.04 * s, 0.34 * s, 0.56 * s, 0.66 * s, r), stroke);
        canvas.drawRRect(
            RRect.fromLTRBR(0.44 * s, 0.34 * s, 0.96 * s, 0.66 * s, r), stroke);
      case _GlyphKind.close:
        canvas.drawLine(p(0.22, 0.22), p(0.78, 0.78), stroke);
        canvas.drawLine(p(0.78, 0.22), p(0.22, 0.78), stroke);
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.kind != kind || old.color != color;
}
