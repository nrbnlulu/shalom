// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AnimalWithOwnerWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AnimalWithOwnerWidgetRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'AnimalWithOwnerWidget';

  static AnimalWithOwnerWidgetRef fromEntityKey(String entityKey) {
    return AnimalWithOwnerWidgetRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [AnimalWithOwnerWidgetData]. Returns `null` when absent or incomplete.
  AnimalWithOwnerWidgetData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<AnimalWithOwnerWidgetData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: AnimalWithOwnerWidgetData.fromCache,
    );
  }

  Stream<AnimalWithOwnerWidgetData> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<AnimalWithOwnerWidgetData>(
      ref: _inner,
      decoder: AnimalWithOwnerWidgetData.fromCache,
    );
  }
}

abstract class AnimalWithOwnerWidget {
  String get id;

  shalom_core.JsonObject toJson();
}

sealed class AnimalWithOwnerWidgetData implements AnimalWithOwnerWidget {
  const AnimalWithOwnerWidgetData();

  String get id;

  static AnimalWithOwnerWidgetData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Cat':
        return AnimalWithOwnerWidgetData$Cat.fromJson(data);
      case 'Dog':
        return AnimalWithOwnerWidgetData$Dog.fromJson(data);

      default:
        return const AnimalWithOwnerWidgetData$Unknown();
    }
  }
}

final class AnimalWithOwnerWidgetData$Cat extends AnimalWithOwnerWidgetData {
  static String G__typename = "Cat";

  /// class members

  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWithOwnerWidgetData$Cat({required this.color, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerWidgetData$Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, AnimalWithOwnerWidgetData$Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWithOwnerWidgetData$Cat.G__typename,

      'color': this.color,

      'id': this.id,
    };
  }

  static AnimalWithOwnerWidgetData$Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return AnimalWithOwnerWidgetData$Cat(color: color$value, id: id$value);
  }
}

final class AnimalWithOwnerWidgetData$Dog extends AnimalWithOwnerWidgetData {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  final AnimalWithOwnerWidget__Dog_owner? owner;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWithOwnerWidgetData$Dog({
    required this.breed,

    required this.id,

    this.owner,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerWidgetData$Dog &&
            breed == other.breed &&
            id == other.id &&
            owner == other.owner);
  }

  @override
  int get hashCode => Object.hashAll([
    breed,

    id,

    owner,

    AnimalWithOwnerWidgetData$Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWithOwnerWidgetData$Dog.G__typename,

      'breed': this.breed,

      'id': this.id,

      'owner': this.owner?.toJson(),
    };
  }

  static AnimalWithOwnerWidgetData$Dog fromJson(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final AnimalWithOwnerWidget__Dog_owner? owner$value = data['owner'] == null
        ? null
        : AnimalWithOwnerWidget__Dog_owner.fromJson(
            data['owner'] as shalom_core.JsonObject,
          );
    return AnimalWithOwnerWidgetData$Dog(
      breed: breed$value,

      id: id$value,

      owner: owner$value,
    );
  }
}

final class AnimalWithOwnerWidgetData$Unknown
    extends AnimalWithOwnerWidgetData {
  const AnimalWithOwnerWidgetData$Unknown();

  @override
  String get id => throw UnimplementedError();

  @override
  shalom_core.JsonObject toJson() => throw UnimplementedError();
}

class AnimalWithOwnerWidget__Dog_owner {
  static String G__typename = "Owner";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AnimalWithOwnerWidget__Dog_owner({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerWidget__Dog_owner &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, name, AnimalWithOwnerWidget__Dog_owner.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  static AnimalWithOwnerWidget__Dog_owner fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return AnimalWithOwnerWidget__Dog_owner(id: id$value, name: name$value);
  }
}

abstract class $AnimalWithOwnerWidget extends StatelessWidget {
  final AnimalWithOwnerWidgetRef ref;
  const $AnimalWithOwnerWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, AnimalWithOwnerWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return AnimalWithOwnerWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class AnimalWithOwnerWidgetScope extends StatelessWidget {
  final AnimalWithOwnerWidgetRef ref;
  final ShalomDataWidgetBuilder<AnimalWithOwnerWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const AnimalWithOwnerWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<AnimalWithOwnerWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
