// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AnimalWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AnimalWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'AnimalWidget';

  static AnimalWidgetRef fromEntityKey(String entityKey) {
    return AnimalWidgetRef.fromInput(
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

  Stream<AnimalWidgetData> observe(shalom_core.ShalomRuntimeClient client) {
    return client.subscribeToFragment<AnimalWidgetData>(
      ref: _inner,
      decoder: AnimalWidgetData.fromCache,
    );
  }
}

abstract class AnimalWidget {
  String get id;

  shalom_core.JsonObject toJson();
}

sealed class AnimalWidgetData implements AnimalWidget {
  const AnimalWidgetData();

  String get id;

  static AnimalWidgetData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Cat':
        return AnimalWidgetData$Cat.fromJson(data);
      case 'Dog':
        return AnimalWidgetData$Dog.fromJson(data);

      default:
        return const AnimalWidgetData$Unknown();
    }
  }
}

final class AnimalWidgetData$Cat extends AnimalWidgetData {
  static String G__typename = "Cat";

  /// class members

  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWidgetData$Cat({required this.color, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWidgetData$Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, AnimalWidgetData$Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWidgetData$Cat.G__typename,

      'color': this.color,

      'id': this.id,
    };
  }

  static AnimalWidgetData$Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return AnimalWidgetData$Cat(color: color$value, id: id$value);
  }
}

final class AnimalWidgetData$Dog extends AnimalWidgetData {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWidgetData$Dog({required this.breed, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWidgetData$Dog &&
            breed == other.breed &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([breed, id, AnimalWidgetData$Dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWidgetData$Dog.G__typename,

      'breed': this.breed,

      'id': this.id,
    };
  }

  static AnimalWidgetData$Dog fromJson(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    return AnimalWidgetData$Dog(breed: breed$value, id: id$value);
  }
}

final class AnimalWidgetData$Unknown extends AnimalWidgetData {
  const AnimalWidgetData$Unknown();

  @override
  String get id => throw UnimplementedError();

  @override
  shalom_core.JsonObject toJson() => throw UnimplementedError();
}

abstract class $AnimalWidget extends StatelessWidget {
  final AnimalWidgetRef ref;
  const $AnimalWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, AnimalWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return AnimalWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class AnimalWidgetScope extends StatelessWidget {
  final AnimalWidgetRef ref;
  final ShalomDataWidgetBuilder<AnimalWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const AnimalWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<AnimalWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
