// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: DogFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type DogFragRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'DogFrag';

  static DogFragRef fromEntityKey(String entityKey) {
    return DogFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static DogFragRef fromId(String id) =>
      fromEntityKey(DogFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  Stream<DogFragData> observe(shalom_core.ShalomRuntimeClient client) {
    return client.subscribeToFragment<DogFragData>(
      ref: _inner,
      decoder: DogFragData.fromCache,
    );
  }
}

abstract class DogFrag {
  String get breed;
  String get id;
  String get name;

  shalom_core.JsonObject toJson();
}

final class DogFragData implements DogFrag, shalom_core.FragmentInterface {
  final String breed;
  final String id;
  final String name;

  const DogFragData({
    required this.breed,
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DogFragData &&
          breed == other.breed &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hashAll([breed, id, name]);

  @override
  String fragment$Name() => 'DogFrag';

  @override
  String entity$Type() => 'Dog';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Dog:123'`.
  static String entityKey(String id) => 'Dog:$id';

  static DogFragData fromCache(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return DogFragData(breed: breed$value, id: id$value, name: name$value);
  }

  shalom_core.JsonObject toJson() {
    return {'breed': this.breed, 'id': this.id, 'name': this.name};
  }
}

abstract class $DogFrag extends StatelessWidget {
  final DogFragRef ref;
  const $DogFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, DogFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return DogFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class DogFragScope extends StatelessWidget {
  final DogFragRef ref;
  final ShalomDataWidgetBuilder<DogFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const DogFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<DogFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
