// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: ZooWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type ZooWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'ZooWidget';

  static ZooWidgetRef fromEntityKey(String entityKey) {
    return ZooWidgetRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static ZooWidgetRef fromId(String id) =>
      fromEntityKey(ZooWidgetData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [ZooWidgetData]. Returns `null` when absent or incomplete.
  ZooWidgetData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<ZooWidgetData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: ZooWidgetData.fromCache,
    );
  }

  Stream<ZooWidgetData> observe(shalom_core.ShalomRuntimeClient client) {
    return client.subscribeToFragment<ZooWidgetData>(
      ref: _inner,
      decoder: ZooWidgetData.fromCache,
    );
  }
}

abstract class ZooWidget {
  List<ZooWidget_cages> get cages;
  String get id;
  String get name;

  shalom_core.JsonObject toJson();
}

class ZooWidget_cages {
  static String G__typename = "Cage";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooWidget_cages({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooWidget_cages && id == other.id && name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([id, name, ZooWidget_cages.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  static ZooWidget_cages fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ZooWidget_cages(id: id$value, name: name$value);
  }
}

final class ZooWidgetData implements ZooWidget, shalom_core.FragmentInterface {
  final List<ZooWidget_cages> cages;
  final String id;
  final String name;

  const ZooWidgetData({
    required this.cages,
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZooWidgetData &&
          const ListEquality().equals(cages, other.cages) &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hashAll([cages, id, name]);

  @override
  String fragment$Name() => 'ZooWidget';

  @override
  String entity$Type() => 'Zoo';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Zoo:123'`.
  static String entityKey(String id) => 'Zoo:$id';

  static ZooWidgetData fromCache(shalom_core.JsonObject data) {
    final List<ZooWidget_cages> cages$value = (data['cages'] as List<dynamic>)
        .map((e) => ZooWidget_cages.fromJson(e as shalom_core.JsonObject))
        .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ZooWidgetData(cages: cages$value, id: id$value, name: name$value);
  }

  shalom_core.JsonObject toJson() {
    return {
      'cages': this.cages.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,
    };
  }
}

abstract class $ZooWidget extends StatelessWidget {
  final ZooWidgetRef ref;
  const $ZooWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, ZooWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return ZooWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class ZooWidgetScope extends StatelessWidget {
  final ZooWidgetRef ref;
  final ShalomDataWidgetBuilder<ZooWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const ZooWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<ZooWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
