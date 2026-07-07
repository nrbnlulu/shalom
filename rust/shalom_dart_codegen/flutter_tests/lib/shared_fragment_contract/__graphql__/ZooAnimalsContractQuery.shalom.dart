// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'CommonAnimalFrag.shalom.dart';
import 'DogFavoriteFrag.shalom.dart';
import 'DogWithFavoriteToyFrag.shalom.dart';
import 'HasFavoriteToyFrag.shalom.dart';
import 'ToyFrag.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class ZooAnimalsContractQueryResponse {
  static String G__typename = "query";

  /// class members
  final List<CommonAnimalFragRef> animals;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  ZooAnimalsContractQueryResponse({required this.animals});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsContractQueryResponse &&
            const ListEquality().equals(animals, other.animals));
  }

  @override
  int get hashCode =>
      Object.hashAll([animals, ZooAnimalsContractQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'animals': this.animals.map((e) => e.toJson()).toList()};
  }

  static ZooAnimalsContractQueryResponse fromJson(shalom_core.JsonObject data) {
    final List<CommonAnimalFragRef> animals$value =
        (data['animals'] as List<dynamic>)
            .map(
              (e) => CommonAnimalFragRef.fromInput(
                shalom_core.observedRefInputFromJson(
                  (e as shalom_core.JsonObject)[r'$CommonAnimalFrag']
                      as shalom_core.JsonObject,
                ),
              ),
            )
            .toList();
    return ZooAnimalsContractQueryResponse(animals: animals$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class ZooAnimalsContractQuery_animals implements CommonAnimalFrag {
  String get id;

  String get $__typename;
  const ZooAnimalsContractQuery_animals();

  shalom_core.JsonObject toJson();

  static ZooAnimalsContractQuery_animals fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return ZooAnimalsContractQuery_animals__Cat.fromJson(data);
      case 'Dog':
        return ZooAnimalsContractQuery_animals__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class ZooAnimalsContractQuery_animals__Cat
    extends ZooAnimalsContractQuery_animals {
  static String G__typename = "Cat";

  /// class members

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ZooAnimalsContractQuery_animals__Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsContractQuery_animals__Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, ZooAnimalsContractQuery_animals__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ZooAnimalsContractQuery_animals__Cat.G__typename,

      'id': this.id,
    };
  }

  static ZooAnimalsContractQuery_animals__Cat fromJson(
    shalom_core.JsonObject data,
  ) {
    final String id$value = data['id'] as String;
    return ZooAnimalsContractQuery_animals__Cat(id: id$value);
  }
}

class ZooAnimalsContractQuery_animals__Dog
    extends ZooAnimalsContractQuery_animals
    implements DogFavoriteFrag, DogWithFavoriteToyFrag {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final HasFavoriteToyFrag_favoriteToy favoriteToy;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ZooAnimalsContractQuery_animals__Dog({
    required this.breed,

    required this.favoriteToy,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ZooAnimalsContractQuery_animals__Dog &&
            breed == other.breed &&
            favoriteToy == other.favoriteToy &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    breed,

    favoriteToy,

    id,

    ZooAnimalsContractQuery_animals__Dog.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ZooAnimalsContractQuery_animals__Dog.G__typename,

      'breed': this.breed,

      'favoriteToy': this.favoriteToy.toJson(),

      'id': this.id,
    };
  }

  static ZooAnimalsContractQuery_animals__Dog fromJson(
    shalom_core.JsonObject data,
  ) {
    final String breed$value = data['breed'] as String;
    final HasFavoriteToyFrag_favoriteToy favoriteToy$value =
        HasFavoriteToyFrag_favoriteToy.fromJson(
          data['favoriteToy'] as shalom_core.JsonObject,
        );
    final String id$value = data['id'] as String;
    return ZooAnimalsContractQuery_animals__Dog(
      breed: breed$value,

      favoriteToy: favoriteToy$value,

      id: id$value,
    );
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

extension ZooAnimalsContractQuery_animals$WhereTypeExt
    on List<ZooAnimalsContractQuery_animals> {
  // Extension to filter list to only Cat types
  Iterable<ZooAnimalsContractQuery_animals__Cat> get cats {
    return whereType<ZooAnimalsContractQuery_animals__Cat>();
  }

  // Extension to filter list to only Dog types
  Iterable<ZooAnimalsContractQuery_animals__Dog> get dogs {
    return whereType<ZooAnimalsContractQuery_animals__Dog>();
  }
}

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class ZooAnimalsContractQueryData
    implements shalom_core.OperationInterface {
  final List<CommonAnimalFragRef> animals;

  const ZooAnimalsContractQueryData({required this.animals});

  @override
  String operation$Name() => 'ZooAnimalsContractQuery';

  static ZooAnimalsContractQueryData fromCache(shalom_core.JsonObject data) {
    final List<CommonAnimalFragRef> animals$value =
        (data['animals'] as List<dynamic>)
            .map(
              (e) => CommonAnimalFragRef.fromInput(
                shalom_core.observedRefInputFromJson(
                  (e as shalom_core.JsonObject)[r'$CommonAnimalFrag']
                      as shalom_core.JsonObject,
                ),
              ),
            )
            .toList();
    return ZooAnimalsContractQueryData(animals: animals$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [ZooAnimalsContractQueryData]. Returns `null` when absent or incomplete.
  static Future<ZooAnimalsContractQueryData?> readFrom(
    shalom_core.CacheProxy cache,
  ) async {
    return await cache.readQuery<ZooAnimalsContractQueryData>(
      name: 'ZooAnimalsContractQuery',
      decoder: fromCache,
    );
  }

  shalom_core.JsonObject toJson() {
    return {'animals': this.animals.map((e) => e.toJson()).toList()};
  }
}

final class ZooAnimalsContractQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const ZooAnimalsContractQueryObservable({
    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'ZooAnimalsContractQuery';

  Stream<shalom_core.GraphQLResponse<ZooAnimalsContractQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<ZooAnimalsContractQueryData>(
      name: operation$Name(),

      decoder: ZooAnimalsContractQueryData.fromCache,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

// ------------ END widget API -------------
