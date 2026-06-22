// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AlbumWidget

import "../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'AlbumGif.shalom.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AlbumWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'AlbumWidget';

  static AlbumWidgetRef fromEntityKey(String entityKey) {
    return AlbumWidgetRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static AlbumWidgetRef fromId(String id) =>
      fromEntityKey(AlbumWidgetData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [AlbumWidgetData]. Returns `null` when absent or incomplete.
  AlbumWidgetData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<AlbumWidgetData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: AlbumWidgetData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<AlbumWidgetData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<AlbumWidgetData>(
      ref: _inner,
      decoder: AlbumWidgetData.fromCache,
    );
  }
}

abstract class AlbumWidget {
  List<AlbumWidget_gifs> get gifs;
  String get id;
  String get name;
  String get tag;

  shalom_core.JsonObject toJson();
}

class AlbumWidget_gifs implements AlbumGif {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String title;

  final String url;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumWidget_gifs({required this.id, required this.title, required this.url});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumWidget_gifs &&
            id == other.id &&
            title == other.title &&
            url == other.url);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, title, url, AlbumWidget_gifs.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'title': this.title, 'url': this.url};
  }

  static AlbumWidget_gifs fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    return AlbumWidget_gifs(id: id$value, title: title$value, url: url$value);
  }
}

final class AlbumWidgetData
    implements AlbumWidget, shalom_core.FragmentInterface {
  final List<AlbumWidget_gifs> gifs;
  final String id;
  final String name;
  final String tag;

  const AlbumWidgetData({
    required this.gifs,
    required this.id,
    required this.name,
    required this.tag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumWidgetData &&
          const ListEquality().equals(gifs, other.gifs) &&
          id == other.id &&
          name == other.name &&
          tag == other.tag);

  @override
  int get hashCode => Object.hashAll([gifs, id, name, tag]);

  @override
  String fragment$Name() => 'AlbumWidget';

  @override
  String entity$Type() => 'Album';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Album:123'`.
  static String entityKey(String id) => 'Album:$id';

  static AlbumWidgetData fromCache(shalom_core.JsonObject data) {
    final List<AlbumWidget_gifs> gifs$value = (data['gifs'] as List<dynamic>)
        .map((e) => AlbumWidget_gifs.fromJson(e as shalom_core.JsonObject))
        .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    final String tag$value = data['tag'] as String;
    return AlbumWidgetData(
      gifs: gifs$value,

      id: id$value,

      name: name$value,

      tag: tag$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'gifs': this.gifs.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,

      'tag': this.tag,
    };
  }
}

abstract class $AlbumWidget extends StatelessWidget {
  final AlbumWidgetRef ref;
  const $AlbumWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, AlbumWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return AlbumWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class AlbumWidgetScope extends StatelessWidget {
  final AlbumWidgetRef ref;
  final ShalomDataWidgetBuilder<AlbumWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const AlbumWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<AlbumWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
