// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'AnimalWithOwnerWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class AnimalWithOwnerQueryResponse {
  static String G__typename = "query";

  /// class members
  final AnimalWithOwnerWidgetRef? animal;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AnimalWithOwnerQueryResponse({this.animal});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerQueryResponse && animal == other.animal);
  }

  @override
  int get hashCode =>
      Object.hashAll([animal, AnimalWithOwnerQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'animal': this.animal == null
        ? shalom_core.shalomJsonValue(null)
        : this.animal!.toShalomValue(),
  });

  static AnimalWithOwnerQueryResponse fromJson(shalom_core.JsonObject data) {
    final AnimalWithOwnerWidgetRef? animal$value = data['animal'] == null
        ? null
        : AnimalWithOwnerWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal']
                      as shalom_core.JsonObject)[r'$AnimalWithOwnerWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalWithOwnerQueryResponse(animal: animal$value);
  }

  static AnimalWithOwnerQueryResponse fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? animal$raw = data.field('animal');
    final AnimalWithOwnerWidgetRef? animal$value =
        animal$raw == null || animal$raw!.isNull
        ? null
        : AnimalWithOwnerWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              animal$raw!.field(r'$AnimalWithOwnerWidget')!,
            ),
          );
    return AnimalWithOwnerQueryResponse(animal: animal$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class AnimalWithOwnerQuery_animal implements AnimalWithOwnerWidget {
  String get id;

  String get $__typename;
  const AnimalWithOwnerQuery_animal();

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();

  static AnimalWithOwnerQuery_animal fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return AnimalWithOwnerQuery_animal__Cat.fromJson(data);
      case 'Dog':
        return AnimalWithOwnerQuery_animal__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }

  static AnimalWithOwnerQuery_animal fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final typename = data.field('__typename')!.stringValue;
    switch (typename) {
      case 'Cat':
        return AnimalWithOwnerQuery_animal__Cat.fromShalomValue(data);
      case 'Dog':
        return AnimalWithOwnerQuery_animal__Dog.fromShalomValue(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class AnimalWithOwnerQuery_animal__Cat extends AnimalWithOwnerQuery_animal {
  static String G__typename = "Cat";

  /// class members

  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWithOwnerQuery_animal__Cat({
    required this.color,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerQuery_animal__Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, AnimalWithOwnerQuery_animal__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWithOwnerQuery_animal__Cat.G__typename,

      'color': this.color,

      'id': this.id,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      AnimalWithOwnerQuery_animal__Cat.G__typename,
    ),

    'color': shalom_core.shalomJsonValue(this.color!),

    'id': shalom_core.shalomJsonValue(this.id!),
  });

  static AnimalWithOwnerQuery_animal__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return AnimalWithOwnerQuery_animal__Cat(color: color$value, id: id$value);
  }

  static AnimalWithOwnerQuery_animal__Cat fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? color$raw = data.field('color');
    final String color$value = color$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return AnimalWithOwnerQuery_animal__Cat(color: color$value, id: id$value);
  }
}

class AnimalWithOwnerQuery_animal__Dog extends AnimalWithOwnerQuery_animal {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  final AnimalWithOwnerWidget__Dog_owner? owner;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalWithOwnerQuery_animal__Dog({
    required this.breed,

    required this.id,

    this.owner,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerQuery_animal__Dog &&
            breed == other.breed &&
            id == other.id &&
            owner == other.owner);
  }

  @override
  int get hashCode => Object.hashAll([
    breed,

    id,

    owner,

    AnimalWithOwnerQuery_animal__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalWithOwnerQuery_animal__Dog.G__typename,

      'breed': this.breed,

      'id': this.id,

      'owner': this.owner?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      AnimalWithOwnerQuery_animal__Dog.G__typename,
    ),

    'breed': shalom_core.shalomJsonValue(this.breed!),

    'id': shalom_core.shalomJsonValue(this.id!),

    'owner': this.owner == null
        ? shalom_core.shalomJsonValue(null)
        : this.owner!.toShalomValue(),
  });

  static AnimalWithOwnerQuery_animal__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final AnimalWithOwnerWidget__Dog_owner? owner$value = data['owner'] == null
        ? null
        : AnimalWithOwnerWidget__Dog_owner.fromJson(
            data['owner'] as shalom_core.JsonObject,
          );
    return AnimalWithOwnerQuery_animal__Dog(
      breed: breed$value,

      id: id$value,

      owner: owner$value,
    );
  }

  static AnimalWithOwnerQuery_animal__Dog fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? breed$raw = data.field('breed');
    final String breed$value = breed$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? owner$raw = data.field('owner');
    final AnimalWithOwnerWidget__Dog_owner? owner$value =
        owner$raw == null || owner$raw!.isNull
        ? null
        : AnimalWithOwnerWidget__Dog_owner.fromShalomValue(owner$raw!);
    return AnimalWithOwnerQuery_animal__Dog(
      breed: breed$value,
      id: id$value,
      owner: owner$value,
    );
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class AnimalWithOwnerQueryData implements shalom_core.OperationInterface {
  final AnimalWithOwnerWidgetRef? animal;

  const AnimalWithOwnerQueryData({required this.animal});

  @override
  String operation$Name() => 'AnimalWithOwnerQuery';

  static AnimalWithOwnerQueryData fromCache(shalom_core.JsonObject data) {
    final AnimalWithOwnerWidgetRef? animal$value = data['animal'] == null
        ? null
        : AnimalWithOwnerWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal']
                      as shalom_core.JsonObject)[r'$AnimalWithOwnerWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalWithOwnerQueryData(animal: animal$value);
  }

  static AnimalWithOwnerQueryData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? animal$raw = data.field('animal');
    final AnimalWithOwnerWidgetRef? animal$value =
        animal$raw == null || animal$raw!.isNull
        ? null
        : AnimalWithOwnerWidgetRef.fromInput(
            shalom_core.observedRefInputFromShalomValue(
              animal$raw!.field(r'$AnimalWithOwnerWidget')!,
            ),
          );
    return AnimalWithOwnerQueryData(animal: animal$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [AnimalWithOwnerQueryData]. Returns `null` when absent or incomplete.
  static Future<AnimalWithOwnerQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    AnimalWithOwnerQueryVariables? variables,
  }) async {
    return await cache.readOperation<AnimalWithOwnerQueryData>(
      name: 'AnimalWithOwnerQuery',
      decoder: fromShalomValue,

      variables: variables?.toShalomValue(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    AnimalWithOwnerQueryVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'AnimalWithOwnerQuery',

      variables: variables?.toShalomValue(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'animal': this.animal == null
        ? shalom_core.shalomJsonValue(null)
        : this.animal!.toShalomValue(),
  });
}

final class AnimalWithOwnerQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final AnimalWithOwnerQueryVariables variables;

  const AnimalWithOwnerQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'AnimalWithOwnerQuery';

  Stream<shalom_core.GraphQLResponse<AnimalWithOwnerQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<AnimalWithOwnerQueryData>(
      name: operation$Name(),

      variables: variables.toShalomValue(),

      decoder: AnimalWithOwnerQueryData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

final class AnimalWithOwnerQueryVariables {
  final String id;

  const AnimalWithOwnerQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  shalom_core.ShalomJsonValue toShalomValue() {
    final $data = <String, shalom_core.ShalomJsonValue>{};
    $data["id"] = shalom_core.shalomJsonValue(this.id!);
    return shalom_core.shalomJsonObject($data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithOwnerQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
