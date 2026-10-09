// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AlbumGif

import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type AlbumGifRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'AlbumGif';

  static AlbumGifRef fromEntityKey(String entityKey) {
    return AlbumGifRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static AlbumGifRef fromId(String id) =>
      fromEntityKey(AlbumGifData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    '__shalom_observed_ref': shalom_core.shalomJsonObject({
      'observable_id': shalom_core.shalomJsonValue(_inner.observableId),
      'anchor': shalom_core.shalomJsonValue(_inner.anchor),
    }),
  });

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [AlbumGifData]. Returns `null` when absent or incomplete.
  Future<AlbumGifData?> readFrom(shalom_core.CacheProxy cache) async {
    return await cache.readFragment<AlbumGifData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: AlbumGifData.fromShalomValue,
    );
  }

  Stream<shalom_core.GraphQLResponse<AlbumGifData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<AlbumGifData>(
      ref: _inner,
      decoder: AlbumGifData.fromShalomValue,
    );
  }
}

abstract class AlbumGif {
  String get id;
  String get title;
  String get url;

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();
}

final class AlbumGifData implements AlbumGif, shalom_core.FragmentInterface {
  final String id;
  final String title;
  final String url;

  const AlbumGifData({
    required this.id,
    required this.title,
    required this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumGifData &&
          id == other.id &&
          title == other.title &&
          url == other.url);

  @override
  int get hashCode => Object.hashAll([id, title, url]);

  @override
  String fragment$Name() => 'AlbumGif';

  @override
  String entity$Type() => 'Gif';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Gif:123'`.
  static String entityKey(String id) => 'Gif:$id';

  static AlbumGifData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    return AlbumGifData(id: id$value, title: title$value, url: url$value);
  }

  static AlbumGifData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? title$raw = data.field('title');
    final String title$value = title$raw!.stringValue;
    final shalom_core.ShalomJsonValue? url$raw = data.field('url');
    final String url$value = url$raw!.stringValue;
    return AlbumGifData(id: id$value, title: title$value, url: url$value);
  }

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title, 'url': this.url};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'id': shalom_core.shalomJsonValue(this.id!),

    'title': shalom_core.shalomJsonValue(this.title!),

    'url': shalom_core.shalomJsonValue(this.url!),
  });
}

abstract class $AlbumGif extends StatelessWidget {
  final AlbumGifRef ref;
  const $AlbumGif({super.key, required this.ref});

  Widget buildData(BuildContext context, AlbumGifData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return AlbumGifScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class AlbumGifScope extends StatelessWidget {
  final AlbumGifRef ref;
  final ShalomDataWidgetBuilder<AlbumGifData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const AlbumGifScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<AlbumGifData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
