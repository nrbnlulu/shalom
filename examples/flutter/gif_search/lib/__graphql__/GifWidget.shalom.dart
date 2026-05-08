// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: GifWidget

import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type GifWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

final class GifWidgetData {
  final String title;
  final String url;
  final String id;
  final String? previewUrl;

  const GifWidgetData({
    required this.title,
    required this.url,
    required this.id,
    required this.previewUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GifWidgetData &&
          title == other.title &&
          url == other.url &&
          id == other.id &&
          previewUrl == other.previewUrl);

  @override
  int get hashCode => Object.hashAll([title, url, id, previewUrl]);

  @experimental
  static GifWidgetData fromCache(shalom_core.JsonObject data) {
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    final String id$value = data['id'] as String;
    final String? previewUrl$value = data['previewUrl'] as String?;
    return GifWidgetData(
      title: title$value,

      url: url$value,

      id: id$value,

      previewUrl: previewUrl$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'title': this.title,

      'url': this.url,

      'id': this.id,

      'previewUrl': this.previewUrl,
    };
  }
}

abstract class $GifWidget extends StatefulWidget {
  final GifWidgetRef ref;
  const $GifWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, GifWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$GifWidget> createState() => _$GifWidgetState();
}

class _$GifWidgetState extends State<$GifWidget> {
  StreamSubscription<GifWidgetData>? _sub;
  GifWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $GifWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<GifWidgetData>(
          ref: widget.ref.toInput,
          decoder: GifWidgetData.fromCache,
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
