// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'PersonWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class PeoplePageResponse {
  static String G__typename = "query";

  /// class members
  final PeoplePage_allPeople? allPeople;

  // keywordargs constructor
  PeoplePageResponse({this.allPeople});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePageResponse && allPeople == other.allPeople);
  }

  @override
  int get hashCode =>
      Object.hashAll([allPeople, PeoplePageResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'allPeople': this.allPeople?.toJson()};
  }

  @experimental
  static PeoplePageResponse fromJson(shalom_core.JsonObject data) {
    final PeoplePage_allPeople? allPeople$value =
        data['allPeople'] == null
            ? null
            : PeoplePage_allPeople.fromJson(
              data['allPeople'] as shalom_core.JsonObject,
            );
    return PeoplePageResponse(allPeople: allPeople$value);
  }
}

class PeoplePage_allPeople {
  static String G__typename = "PeopleConnection";

  /// class members
  final List<PeoplePage_allPeople_edges?>? edges;

  final PeoplePage_allPeople_pageInfo pageInfo;

  // keywordargs constructor
  PeoplePage_allPeople({this.edges, required this.pageInfo});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePage_allPeople &&
            const ListEquality().equals(edges, other.edges) &&
            pageInfo == other.pageInfo);
  }

  @override
  int get hashCode =>
      Object.hashAll([edges, pageInfo, PeoplePage_allPeople.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'edges': this.edges?.map((e) => e?.toJson()).toList(),

      'pageInfo': this.pageInfo.toJson(),
    };
  }

  @experimental
  static PeoplePage_allPeople fromJson(shalom_core.JsonObject data) {
    final List<PeoplePage_allPeople_edges?>? edges$value =
        data['edges'] == null
            ? null
            : (data['edges'] as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : PeoplePage_allPeople_edges.fromJson(
                            e as shalom_core.JsonObject,
                          ),
                )
                .toList();
    final PeoplePage_allPeople_pageInfo pageInfo$value =
        PeoplePage_allPeople_pageInfo.fromJson(
          data['pageInfo'] as shalom_core.JsonObject,
        );
    return PeoplePage_allPeople(edges: edges$value, pageInfo: pageInfo$value);
  }
}

class PeoplePage_allPeople_edges {
  static String G__typename = "PeopleEdge";

  /// class members
  final PersonWidgetRef? node;

  final String cursor;

  // keywordargs constructor
  PeoplePage_allPeople_edges({this.node, required this.cursor});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePage_allPeople_edges &&
            node == other.node &&
            cursor == other.cursor);
  }

  @override
  int get hashCode =>
      Object.hashAll([node, cursor, PeoplePage_allPeople_edges.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'node': this.node?.toJson(), 'cursor': this.cursor};
  }

  @experimental
  static PeoplePage_allPeople_edges fromJson(shalom_core.JsonObject data) {
    final PersonWidgetRef? node$value =
        data['node'] == null
            ? null
            : PersonWidgetRef.fromInput(
              shalom_core.observedRefInputFromJson(
                (data['node'] as shalom_core.JsonObject)[r'$PersonWidget']
                    as shalom_core.JsonObject,
              ),
            );
    final String cursor$value = data['cursor'] as String;
    return PeoplePage_allPeople_edges(node: node$value, cursor: cursor$value);
  }
}

class PeoplePage_allPeople_edges_node {
  static String G__typename = "Person";

  /// class members
  final int? height;

  final String id;

  final String? eyeColor;

  final String? birthYear;

  final String? hairColor;

  final String? gender;

  final double? mass;

  final String? name;

  // keywordargs constructor
  PeoplePage_allPeople_edges_node({
    this.height,

    required this.id,

    this.eyeColor,

    this.birthYear,

    this.hairColor,

    this.gender,

    this.mass,

    this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePage_allPeople_edges_node &&
            height == other.height &&
            id == other.id &&
            eyeColor == other.eyeColor &&
            birthYear == other.birthYear &&
            hairColor == other.hairColor &&
            gender == other.gender &&
            mass == other.mass &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    height,

    id,

    eyeColor,

    birthYear,

    hairColor,

    gender,

    mass,

    name,

    PeoplePage_allPeople_edges_node.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'height': this.height,

      'id': this.id,

      'eyeColor': this.eyeColor,

      'birthYear': this.birthYear,

      'hairColor': this.hairColor,

      'gender': this.gender,

      'mass': this.mass,

      'name': this.name,
    };
  }

  @experimental
  static PeoplePage_allPeople_edges_node fromJson(shalom_core.JsonObject data) {
    final int? height$value = data['height'] as int?;
    final String id$value = data['id'] as String;
    final String? eyeColor$value = data['eyeColor'] as String?;
    final String? birthYear$value = data['birthYear'] as String?;
    final String? hairColor$value = data['hairColor'] as String?;
    final String? gender$value = data['gender'] as String?;
    final double? mass$value = data['mass'] as double?;
    final String? name$value = data['name'] as String?;
    return PeoplePage_allPeople_edges_node(
      height: height$value,

      id: id$value,

      eyeColor: eyeColor$value,

      birthYear: birthYear$value,

      hairColor: hairColor$value,

      gender: gender$value,

      mass: mass$value,

      name: name$value,
    );
  }
}

class PeoplePage_allPeople_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final bool hasNextPage;

  final String? endCursor;

  // keywordargs constructor
  PeoplePage_allPeople_pageInfo({required this.hasNextPage, this.endCursor});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePage_allPeople_pageInfo &&
            hasNextPage == other.hasNextPage &&
            endCursor == other.endCursor);
  }

  @override
  int get hashCode => Object.hashAll([
    hasNextPage,

    endCursor,

    PeoplePage_allPeople_pageInfo.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'hasNextPage': this.hasNextPage, 'endCursor': this.endCursor};
  }

  @experimental
  static PeoplePage_allPeople_pageInfo fromJson(shalom_core.JsonObject data) {
    final bool hasNextPage$value = data['hasNextPage'] as bool;
    final String? endCursor$value = data['endCursor'] as String?;
    return PeoplePage_allPeople_pageInfo(
      hasNextPage: hasNextPage$value,

      endCursor: endCursor$value,
    );
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------

// ------------ V2 WIDGET API -------------

final class PeoplePageData {
  final PeoplePage_allPeople? allPeople;

  const PeoplePageData({required this.allPeople});

  @experimental
  static PeoplePageData fromCache(shalom_core.JsonObject data) {
    final PeoplePage_allPeople? allPeople$value =
        data['allPeople'] == null
            ? null
            : PeoplePage_allPeople.fromJson(
              data['allPeople'] as shalom_core.JsonObject,
            );
    return PeoplePageData(allPeople: allPeople$value);
  }

  shalom_core.JsonObject toJson() {
    return {'allPeople': this.allPeople?.toJson()};
  }
}

final class PeoplePageVariables {
  final shalom_core.Maybe<String?> after;

  final shalom_core.Maybe<int?> first;

  const PeoplePageVariables({
    this.after = const shalom_core.None(),

    this.first = const shalom_core.None(),
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    if (after.isSome()) {
      final value = this.after.some();
      data["after"] = value;
    }
    if (first.isSome()) {
      final value = this.first.some();
      data["first"] = value;
    }

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PeoplePageVariables &&
            this.after == other.after &&
            this.first == other.first);
  }

  @override
  int get hashCode => Object.hashAll([after, first]);
}

// ------------ END V2 WIDGET API -------------
