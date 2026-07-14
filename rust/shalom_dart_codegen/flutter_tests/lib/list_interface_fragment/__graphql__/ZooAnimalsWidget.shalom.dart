// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: ZooAnimalsWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type ZooAnimalsWidgetRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'ZooAnimalsWidget';

  static ZooAnimalsWidgetRef fromEntityKey(String entityKey) {
    return ZooAnimalsWidgetRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static ZooAnimalsWidgetRef fromId(String id) =>
      fromEntityKey(ZooAnimalsWidgetData.entityKey(id));

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
  /// [ZooAnimalsWidgetData]. Returns `null` when absent or incomplete.
  Future<ZooAnimalsWidgetData?> readFrom(shalom_core.CacheProxy cache) async {
    return await cache.readFragment<ZooAnimalsWidgetData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      bridgeDecoder: ZooAnimalsWidgetData.fromShalomValue,
    );
  }

  Stream<shalom_core.GraphQLResponse<ZooAnimalsWidgetData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<ZooAnimalsWidgetData>(
      ref: _inner,
      bridgeDecoder: ZooAnimalsWidgetData.fromShalomValue,
    );
  }
}

abstract class ZooAnimalsWidget {
  List<ZooAnimalsWidget_animals> get animals;
  String get id;
  String get name;

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();
}

sealed class ZooAnimalsWidget_animals {
  String get id;

  String get $__typename;
  const ZooAnimalsWidget_animals();

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();

  static ZooAnimalsWidget_animals fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return ZooAnimalsWidget_animals__Cat.fromJson(data);
      case 'Dog':
        return ZooAnimalsWidget_animals__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }

  static ZooAnimalsWidget_animals fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final typename = data.field('__typename')!.stringValue;
    switch (typename) {
      case 'Cat':
        return ZooAnimalsWidget_animals__Cat.fromShalomValue(data);
      case 'Dog':
        return ZooAnimalsWidget_animals__Dog.fromShalomValue(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

final class ZooAnimalsWidget_animals__Cat extends ZooAnimalsWidget_animals {
  static String G__typename = "Cat";

  /// class members

  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ZooAnimalsWidget_animals__Cat({required this.color, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsWidget_animals__Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, ZooAnimalsWidget_animals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ZooAnimalsWidget_animals__Cat.G__typename,

      'color': this.color,

      'id': this.id,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      ZooAnimalsWidget_animals__Cat.G__typename,
    ),

    'color': shalom_core.shalomJsonValue(this.color!),

    'id': shalom_core.shalomJsonValue(this.id!),
  });

  static ZooAnimalsWidget_animals__Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return ZooAnimalsWidget_animals__Cat(color: color$value, id: id$value);
  }

  static ZooAnimalsWidget_animals__Cat fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? color$raw = data.field('color');
    final String color$value = color$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return ZooAnimalsWidget_animals__Cat(color: color$value, id: id$value);
  }
}

final class ZooAnimalsWidget_animals__Dog extends ZooAnimalsWidget_animals {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ZooAnimalsWidget_animals__Dog({required this.breed, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsWidget_animals__Dog &&
            breed == other.breed &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([breed, id, ZooAnimalsWidget_animals__Dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ZooAnimalsWidget_animals__Dog.G__typename,

      'breed': this.breed,

      'id': this.id,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      ZooAnimalsWidget_animals__Dog.G__typename,
    ),

    'breed': shalom_core.shalomJsonValue(this.breed!),

    'id': shalom_core.shalomJsonValue(this.id!),
  });

  static ZooAnimalsWidget_animals__Dog fromJson(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    return ZooAnimalsWidget_animals__Dog(breed: breed$value, id: id$value);
  }

  static ZooAnimalsWidget_animals__Dog fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? breed$raw = data.field('breed');
    final String breed$value = breed$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return ZooAnimalsWidget_animals__Dog(breed: breed$value, id: id$value);
  }
}

final class ZooAnimalsWidgetData
    implements ZooAnimalsWidget, shalom_core.FragmentInterface {
  final List<ZooAnimalsWidget_animals> animals;
  final String id;
  final String name;

  const ZooAnimalsWidgetData({
    required this.animals,
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZooAnimalsWidgetData &&
          const ListEquality().equals(animals, other.animals) &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hashAll([animals, id, name]);

  @override
  String fragment$Name() => 'ZooAnimalsWidget';

  @override
  String entity$Type() => 'Zoo';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Zoo:123'`.
  static String entityKey(String id) => 'Zoo:$id';

  static ZooAnimalsWidgetData fromCache(shalom_core.JsonObject data) {
    final List<ZooAnimalsWidget_animals> animals$value =
        (data['animals'] as List<dynamic>)
            .map(
              (e) => ZooAnimalsWidget_animals.fromJson(
                e as shalom_core.JsonObject,
              ),
            )
            .toList();
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ZooAnimalsWidgetData(
      animals: animals$value,

      id: id$value,

      name: name$value,
    );
  }

  static ZooAnimalsWidgetData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? animals$raw = data.field('animals');
    final List<ZooAnimalsWidget_animals> animals$value = animals$raw!.listValue
        .map((e) => ZooAnimalsWidget_animals.fromShalomValue(e!))
        .toList();
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
    return ZooAnimalsWidgetData(
      animals: animals$value,
      id: id$value,
      name: name$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'animals': this.animals.map((e) => e.toJson()).toList(),

      'id': this.id,

      'name': this.name,
    };
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'animals': shalom_core.shalomJsonArray(
      this.animals!.map((e) => e!.toShalomValue()),
    ),

    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });
}

abstract class $ZooAnimalsWidget extends StatelessWidget {
  final ZooAnimalsWidgetRef ref;
  const $ZooAnimalsWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, ZooAnimalsWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return ZooAnimalsWidgetScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class ZooAnimalsWidgetScope extends StatelessWidget {
  final ZooAnimalsWidgetRef ref;
  final ShalomDataWidgetBuilder<ZooAnimalsWidgetData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const ZooAnimalsWidgetScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<ZooAnimalsWidgetData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
