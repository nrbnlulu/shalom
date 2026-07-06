// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'AnimalWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class AnimalQueryResponse {
  static String G__typename = "query";

  /// class members
  final AnimalWidgetRef? animal;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AnimalQueryResponse({this.animal});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalQueryResponse && animal == other.animal);
  }

  @override
  int get hashCode => Object.hashAll([animal, AnimalQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }

  static AnimalQueryResponse fromJson(shalom_core.JsonObject data) {
    final AnimalWidgetRef? animal$value = data['animal'] == null
        ? null
        : AnimalWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal'] as shalom_core.JsonObject)[r'$AnimalWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalQueryResponse(animal: animal$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

sealed class AnimalQuery_animal implements AnimalWidget {
  String get id;

  String get $__typename;
  const AnimalQuery_animal();

  shalom_core.JsonObject toJson();

  static AnimalQuery_animal fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return AnimalQuery_animal__Cat.fromJson(data);
      case 'Dog':
        return AnimalQuery_animal__Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

class AnimalQuery_animal__Cat extends AnimalQuery_animal {
  static String G__typename = "Cat";

  /// class members

  final String color;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalQuery_animal__Cat({required this.color, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalQuery_animal__Cat &&
            color == other.color &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([color, id, AnimalQuery_animal__Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalQuery_animal__Cat.G__typename,

      'color': this.color,

      'id': this.id,
    };
  }

  static AnimalQuery_animal__Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return AnimalQuery_animal__Cat(color: color$value, id: id$value);
  }
}

class AnimalQuery_animal__Dog extends AnimalQuery_animal {
  static String G__typename = "Dog";

  /// class members

  final String breed;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const AnimalQuery_animal__Dog({required this.breed, required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalQuery_animal__Dog &&
            breed == other.breed &&
            id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([breed, id, AnimalQuery_animal__Dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": AnimalQuery_animal__Dog.G__typename,

      'breed': this.breed,

      'id': this.id,
    };
  }

  static AnimalQuery_animal__Dog fromJson(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    return AnimalQuery_animal__Dog(breed: breed$value, id: id$value);
  }
}

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ widget API -------------

final class AnimalQueryData implements shalom_core.OperationInterface {
  final AnimalWidgetRef? animal;

  const AnimalQueryData({required this.animal});

  @override
  String operation$Name() => 'AnimalQuery';

  static AnimalQueryData fromCache(shalom_core.JsonObject data) {
    final AnimalWidgetRef? animal$value = data['animal'] == null
        ? null
        : AnimalWidgetRef.fromInput(
            shalom_core.observedRefInputFromJson(
              (data['animal'] as shalom_core.JsonObject)[r'$AnimalWidget']
                  as shalom_core.JsonObject,
            ),
          );
    return AnimalQueryData(animal: animal$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [AnimalQueryData]. Returns `null` when absent or incomplete.
  static Future<AnimalQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    AnimalQueryVariables? variables,
  }) async {
    return await cache.readQuery<AnimalQueryData>(
      name: 'AnimalQuery',
      decoder: fromCache,

      variables: variables?.toJson(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'animal': this.animal?.toJson()};
  }
}

final class AnimalQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;

  final AnimalQueryVariables variables;

  const AnimalQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
  });

  String operation$Name() => 'AnimalQuery';

  Stream<shalom_core.GraphQLResponse<AnimalQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<AnimalQueryData>(
      name: operation$Name(),

      variables: variables.toJson(),

      decoder: AnimalQueryData.fromCache,
      executionPolicy: executionPolicy,
    );
  }
}

final class AnimalQueryVariables {
  final String id;

  const AnimalQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
