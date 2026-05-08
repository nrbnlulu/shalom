// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AlbumWidget

import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AlbumWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

class AlbumWidget_gifs {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String title;

  // keywordargs constructor
  AlbumWidget_gifs({required this.id, required this.title});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumWidget_gifs && id == other.id && title == other.title);
  }

  @override
  int get hashCode => Object.hashAll([id, title, AlbumWidget_gifs.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title};
  }

  @experimental
  static AlbumWidget_gifs fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    return AlbumWidget_gifs(id: id$value, title: title$value);
  }
}

final class AlbumWidgetData {
  final String id;
  final String name;
  final List<AlbumWidget_gifs> gifs;

  const AlbumWidgetData({
    required this.id,
    required this.name,
    required this.gifs,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumWidgetData &&
          id == other.id &&
          name == other.name &&
          const ListEquality().equals(gifs, other.gifs));

  @override
  int get hashCode => Object.hashAll([id, name, gifs]);

  @experimental
  static AlbumWidgetData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    final List<AlbumWidget_gifs> gifs$value =
        (data['gifs'] as List<dynamic>)
            .map((e) => AlbumWidget_gifs.fromJson(e as shalom_core.JsonObject))
            .toList();
    return AlbumWidgetData(id: id$value, name: name$value, gifs: gifs$value);
  }

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'gifs': this.gifs.map((e) => e.toJson()).toList(),
    };
  }
}

abstract class $AlbumWidget extends StatefulWidget {
  final AlbumWidgetRef ref;
  const $AlbumWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, AlbumWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$AlbumWidget> createState() => _$AlbumWidgetState();
}

class _$AlbumWidgetState extends State<$AlbumWidget> {
  StreamSubscription<AlbumWidgetData>? _sub;
  AlbumWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $AlbumWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<AlbumWidgetData>(
          ref: widget.ref.toInput,
          decoder: AlbumWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() {
            _data = data;
            _error = null;
          }),
          onError:
              (e) => setState(() {
                _error = e;
              }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null) return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
