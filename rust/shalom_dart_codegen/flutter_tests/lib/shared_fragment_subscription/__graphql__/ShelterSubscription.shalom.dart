// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'DogFrag.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ShelterSubscriptionResponse {
  static String G__typename = "subscription";

  /// class members
  final ShelterSubscription_shelterAnimals shelterAnimals;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ShelterSubscriptionResponse({required this.shelterAnimals});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscriptionResponse &&
            shelterAnimals == other.shelterAnimals);
  }

  @override
  int get hashCode =>
      Object.hashAll([shelterAnimals, ShelterSubscriptionResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'shelterAnimals': this.shelterAnimals.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'shelterAnimals': this.shelterAnimals!.toShalomValue(),
  });

  static ShelterSubscriptionResponse fromJson(shalom_core.JsonObject data) {
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromJson(
          data['shelterAnimals'] as shalom_core.JsonObject,
        );
    return ShelterSubscriptionResponse(shelterAnimals: shelterAnimals$value);
  }

  static ShelterSubscriptionResponse fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? shelterAnimals$raw = data.field(
      'shelterAnimals',
    );
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromShalomValue(shelterAnimals$raw!);
    return ShelterSubscriptionResponse(shelterAnimals: shelterAnimals$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class ShelterSubscription_shelterAnimals {
  String get id;

  String get $__typename;
  const ShelterSubscription_shelterAnimals();

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();

  static ShelterSubscription_shelterAnimals fromJson(
    shalom_core.JsonObject data,
  ) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return ShelterSubscription_shelterAnimals__Cat.fromJson(data);
      case 'Dog':
        return ShelterSubscription_shelterAnimals__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }

  static ShelterSubscription_shelterAnimals fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final typename = data.field('__typename')!.stringValue;
    switch (typename) {
      case 'Cat':
        return ShelterSubscription_shelterAnimals__Cat.fromShalomValue(data);
      case 'Dog':
        return ShelterSubscription_shelterAnimals__Dog.fromShalomValue(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class ShelterSubscription_shelterAnimals__Cat
    extends ShelterSubscription_shelterAnimals {
  static String G__typename = "Cat";

  /// class members

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ShelterSubscription_shelterAnimals__Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscription_shelterAnimals__Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, ShelterSubscription_shelterAnimals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ShelterSubscription_shelterAnimals__Cat.G__typename,

      'id': this.id,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      ShelterSubscription_shelterAnimals__Cat.G__typename,
    ),

    'id': shalom_core.shalomJsonValue(this.id!),
  });

  static ShelterSubscription_shelterAnimals__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    return ShelterSubscription_shelterAnimals__Cat(id: id$value);
  }

  static ShelterSubscription_shelterAnimals__Cat fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return ShelterSubscription_shelterAnimals__Cat(id: id$value);
  }
}

class ShelterSubscription_shelterAnimals__Dog
    extends ShelterSubscription_shelterAnimals
    implements DogFrag {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ShelterSubscription_shelterAnimals__Dog({
    required this.breed,

    required this.id,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShelterSubscription_shelterAnimals__Dog &&
            breed == other.breed &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    breed,

    id,

    name,

    ShelterSubscription_shelterAnimals__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ShelterSubscription_shelterAnimals__Dog.G__typename,

      'breed': this.breed,

      'id': this.id,

      'name': this.name,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    "__typename": shalom_core.shalomJsonValue(
      ShelterSubscription_shelterAnimals__Dog.G__typename,
    ),

    'breed': shalom_core.shalomJsonValue(this.breed!),

    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

  static ShelterSubscription_shelterAnimals__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return ShelterSubscription_shelterAnimals__Dog(
      breed: breed$value,

      id: id$value,

      name: name$value,
    );
  }

  static ShelterSubscription_shelterAnimals__Dog fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? breed$raw = data.field('breed');
    final String breed$value = breed$raw!.stringValue;
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
    return ShelterSubscription_shelterAnimals__Dog(
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

final class ShelterSubscriptionData
    implements shalom_core.OperationInterface, shalom_core.StreamCompat {
  final ShelterSubscription_shelterAnimals shelterAnimals;

  const ShelterSubscriptionData({required this.shelterAnimals});

  @override
  String operation$Name() => 'ShelterSubscription';

  static ShelterSubscriptionData fromCache(shalom_core.JsonObject data) {
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromJson(
          data['shelterAnimals'] as shalom_core.JsonObject,
        );
    return ShelterSubscriptionData(shelterAnimals: shelterAnimals$value);
  }

  static ShelterSubscriptionData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? shelterAnimals$raw = data.field(
      'shelterAnimals',
    );
    final ShelterSubscription_shelterAnimals shelterAnimals$value =
        ShelterSubscription_shelterAnimals.fromShalomValue(shelterAnimals$raw!);
    return ShelterSubscriptionData(shelterAnimals: shelterAnimals$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [ShelterSubscriptionData]. Returns `null` when absent or incomplete.
  static Future<ShelterSubscriptionData?> readFrom(
    shalom_core.CacheProxy cache,
  ) async {
    return await cache.readOperation<ShelterSubscriptionData>(
      name: 'ShelterSubscription',
      decoder: fromShalomValue,
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(shalom_core.CacheProxy cache) {
    return cache.evictOperation(name: 'ShelterSubscription');
  }

  shalom_core.JsonObject toJson() {
    return {'shelterAnimals': this.shelterAnimals.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'shelterAnimals': this.shelterAnimals!.toShalomValue(),
  });
}

final class ShelterSubscriptionObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const ShelterSubscriptionObservable({
    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'ShelterSubscription';

  Stream<shalom_core.GraphQLResponse<ShelterSubscriptionData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<ShelterSubscriptionData>(
      name: operation$Name(),

      decoder: ShelterSubscriptionData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

// ------------ END widget API -------------
