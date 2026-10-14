// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'DogFrag.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------
class StreetSubscriptionData
    implements shalom_core.OperationInterface, shalom_core.StreamCompat {
  static String G__typename = "subscription";

  /// class members
  final StreetSubscription_streetAnimals streetAnimals;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  StreetSubscriptionData({required this.streetAnimals});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscriptionData &&
            streetAnimals == other.streetAnimals);
  }

  @override
  int get hashCode =>
      Object.hashAll([streetAnimals, StreetSubscriptionData.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'streetAnimals': this.streetAnimals.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'streetAnimals': this.streetAnimals!.toShalomValue(),
  });

  static StreetSubscriptionData fromJson(shalom_core.JsonObject data) {
    final StreetSubscription_streetAnimals streetAnimals$value =
        StreetSubscription_streetAnimals.fromJson(
          data['streetAnimals'] as shalom_core.JsonObject,
        );
    return StreetSubscriptionData(streetAnimals: streetAnimals$value);
  }

  static StreetSubscriptionData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? streetAnimals$raw = data.field(
      'streetAnimals',
    );
    final StreetSubscription_streetAnimals streetAnimals$value =
        StreetSubscription_streetAnimals.fromShalomValue(streetAnimals$raw!);
    return StreetSubscriptionData(streetAnimals: streetAnimals$value);
  }

  @override
  String operation$Name() => 'StreetSubscription';

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [StreetSubscriptionData]. Returns `null` when absent or incomplete.
  static Future<StreetSubscriptionData?> readFrom(
    shalom_core.CacheProxy cache,
  ) async {
    return await cache.readOperation<StreetSubscriptionData>(
      name: 'StreetSubscription',
      decoder: fromShalomValue,
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(shalom_core.CacheProxy cache) {
    return cache.evictOperation(name: 'StreetSubscription');
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class StreetSubscription_streetAnimals {
  String get id;

  String get $__typename;
  const StreetSubscription_streetAnimals();

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();

  static StreetSubscription_streetAnimals fromJson(
    shalom_core.JsonObject data,
  ) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return StreetSubscription_streetAnimals__Cat.fromJson(data);
      case 'Dog':
        return StreetSubscription_streetAnimals__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }

  static StreetSubscription_streetAnimals fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final typename = data.field('__typename')!.stringValue;
    switch (typename) {
      case 'Cat':
        return StreetSubscription_streetAnimals__Cat.fromShalomValue(data);
      case 'Dog':
        return StreetSubscription_streetAnimals__Dog.fromShalomValue(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class StreetSubscription_streetAnimals__Cat
    extends StreetSubscription_streetAnimals {
  static String G__typename = "Cat";

  /// class members

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const StreetSubscription_streetAnimals__Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscription_streetAnimals__Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, StreetSubscription_streetAnimals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": StreetSubscription_streetAnimals__Cat.G__typename,

      'id': this.id,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      StreetSubscription_streetAnimals__Cat.G__typename,
    ),

    'id': shalom_core.shalomJsonValue(this.id!),
  });

  static StreetSubscription_streetAnimals__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    return StreetSubscription_streetAnimals__Cat(id: id$value);
  }

  static StreetSubscription_streetAnimals__Cat fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return StreetSubscription_streetAnimals__Cat(id: id$value);
  }
}

class StreetSubscription_streetAnimals__Dog
    extends StreetSubscription_streetAnimals
    implements DogFrag {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const StreetSubscription_streetAnimals__Dog({
    required this.breed,

    required this.id,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreetSubscription_streetAnimals__Dog &&
            breed == other.breed &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    breed,

    id,

    name,

    StreetSubscription_streetAnimals__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": StreetSubscription_streetAnimals__Dog.G__typename,

      'breed': this.breed,

      'id': this.id,

      'name': this.name,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      StreetSubscription_streetAnimals__Dog.G__typename,
    ),

    'breed': shalom_core.shalomJsonValue(this.breed!),

    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

  static StreetSubscription_streetAnimals__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return StreetSubscription_streetAnimals__Dog(
      breed: breed$value,

      id: id$value,

      name: name$value,
    );
  }

  static StreetSubscription_streetAnimals__Dog fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? breed$raw = data.field('breed');
    final String breed$value = breed$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
    return StreetSubscription_streetAnimals__Dog(
      breed: breed$value,
      id: id$value,
      name: name$value,
    );
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class StreetSubscriptionObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const StreetSubscriptionObservable({
    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'StreetSubscription';

  Stream<shalom_core.GraphQLResponse<StreetSubscriptionData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<StreetSubscriptionData>(
      name: operation$Name(),

      decoder: StreetSubscriptionData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

// ------------ END widget API -------------
