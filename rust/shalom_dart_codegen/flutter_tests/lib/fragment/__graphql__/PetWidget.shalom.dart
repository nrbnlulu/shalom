// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PetWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type PetWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'PetWidget';

  static PetWidgetRef fromEntityKey(String entityKey) {
    return PetWidgetRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static PetWidgetRef fromId(String id) =>
      fromEntityKey(PetWidgetData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [PetWidgetData]. Returns `null` when absent or incomplete.
  PetWidgetData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<PetWidgetData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: PetWidgetData.fromCache,
    );
  }

  Stream<PetWidgetData> observe(shalom_core.ShalomRuntimeClient client) {
    return client.subscribeToFragment<PetWidgetData>(
      ref: _inner,
      decoder: PetWidgetData.fromCache,
    );
  }
}

abstract class PetWidget {
  String get id;
  String get name;

  shalom_core.JsonObject toJson();
}

final class PetWidgetData implements PetWidget, shalom_core.FragmentInterface {
  final String id;
  final String name;

  const PetWidgetData({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetWidgetData && id == other.id && name == other.name);

  @override
  int get hashCode => Object.hashAll([id, name]);

  @override
  String fragment$Name() => 'PetWidget';

  @override
  String entity$Type() => 'Pet';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Pet:123'`.
  static String entityKey(String id) => 'Pet:$id';

  static PetWidgetData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return PetWidgetData(id: id$value, name: name$value);
  }

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }
}

abstract class $PetWidget extends StatelessWidget {
  final PetWidgetRef ref;
  const $PetWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, PetWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return PetWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class PetWidgetScope extends StatelessWidget {
  final PetWidgetRef ref;
  final ShalomDataWidgetBuilder<PetWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const PetWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<PetWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
