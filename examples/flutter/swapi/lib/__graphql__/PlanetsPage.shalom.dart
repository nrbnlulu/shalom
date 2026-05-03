// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'PlanetWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class PlanetsPageResponse {
  static String G__typename = "query";

  /// class members
  final PlanetsPage_allPlanets? allPlanets;

  // keywordargs constructor
  PlanetsPageResponse({this.allPlanets});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlanetsPageResponse && allPlanets == other.allPlanets);
  }

  @override
  int get hashCode =>
      Object.hashAll([allPlanets, PlanetsPageResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'allPlanets': this.allPlanets?.toJson()};
  }

  @experimental
  static PlanetsPageResponse fromJson(shalom_core.JsonObject data) {
    final PlanetsPage_allPlanets? allPlanets$value =
        data['allPlanets'] == null
            ? null
            : PlanetsPage_allPlanets.fromJson(
              data['allPlanets'] as shalom_core.JsonObject,
            );
    return PlanetsPageResponse(allPlanets: allPlanets$value);
  }
}

class PlanetsPage_allPlanets {
  static String G__typename = "PlanetsConnection";

  /// class members
  final PlanetsPage_allPlanets_pageInfo pageInfo;

  final List<PlanetsPage_allPlanets_edges?>? edges;

  // keywordargs constructor
  PlanetsPage_allPlanets({required this.pageInfo, this.edges});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlanetsPage_allPlanets &&
            pageInfo == other.pageInfo &&
            const ListEquality().equals(edges, other.edges));
  }

  @override
  int get hashCode =>
      Object.hashAll([pageInfo, edges, PlanetsPage_allPlanets.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'pageInfo': this.pageInfo.toJson(),

      'edges': this.edges?.map((e) => e?.toJson()).toList(),
    };
  }

  @experimental
  static PlanetsPage_allPlanets fromJson(shalom_core.JsonObject data) {
    final PlanetsPage_allPlanets_pageInfo pageInfo$value =
        PlanetsPage_allPlanets_pageInfo.fromJson(
          data['pageInfo'] as shalom_core.JsonObject,
        );
    final List<PlanetsPage_allPlanets_edges?>? edges$value =
        data['edges'] == null
            ? null
            : (data['edges'] as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : PlanetsPage_allPlanets_edges.fromJson(
                            e as shalom_core.JsonObject,
                          ),
                )
                .toList();
    return PlanetsPage_allPlanets(pageInfo: pageInfo$value, edges: edges$value);
  }
}

class PlanetsPage_allPlanets_edges {
  static String G__typename = "PlanetsEdge";

  /// class members
  final String cursor;

  final PlanetWidgetRef? node;

  // keywordargs constructor
  PlanetsPage_allPlanets_edges({required this.cursor, this.node});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlanetsPage_allPlanets_edges &&
            cursor == other.cursor &&
            node == other.node);
  }

  @override
  int get hashCode =>
      Object.hashAll([cursor, node, PlanetsPage_allPlanets_edges.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'cursor': this.cursor, 'node': this.node?.toJson()};
  }

  @experimental
  static PlanetsPage_allPlanets_edges fromJson(shalom_core.JsonObject data) {
    final String cursor$value = data['cursor'] as String;
    final PlanetWidgetRef? node$value =
        data['node'] == null
            ? null
            : PlanetWidgetRef.fromInput(
              shalom_core.observedRefInputFromJson(
                (data['node'] as shalom_core.JsonObject)[r'$PlanetWidget']
                    as shalom_core.JsonObject,
              ),
            );
    return PlanetsPage_allPlanets_edges(cursor: cursor$value, node: node$value);
  }
}

class PlanetsPage_allPlanets_edges_node {
  static String G__typename = "Planet";

  /// class members
  final List<String?>? terrains;

  final String id;

  final int? diameter;

  final String? name;

  final double? population;

  final List<String?>? climates;

  // keywordargs constructor
  PlanetsPage_allPlanets_edges_node({
    this.terrains,

    required this.id,

    this.diameter,

    this.name,

    this.population,

    this.climates,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlanetsPage_allPlanets_edges_node &&
            const ListEquality().equals(terrains, other.terrains) &&
            id == other.id &&
            diameter == other.diameter &&
            name == other.name &&
            population == other.population &&
            const ListEquality().equals(climates, other.climates));
  }

  @override
  int get hashCode => Object.hashAll([
    terrains,

    id,

    diameter,

    name,

    population,

    climates,

    PlanetsPage_allPlanets_edges_node.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'terrains': this.terrains?.map((e) => e).toList(),

      'id': this.id,

      'diameter': this.diameter,

      'name': this.name,

      'population': this.population,

      'climates': this.climates?.map((e) => e).toList(),
    };
  }

  @experimental
  static PlanetsPage_allPlanets_edges_node fromJson(
    shalom_core.JsonObject data,
  ) {
    final List<String?>? terrains$value =
        data['terrains'] == null
            ? null
            : (data['terrains'] as List<dynamic>)
                .map((e) => e as String?)
                .toList();
    final String id$value = data['id'] as String;
    final int? diameter$value = data['diameter'] as int?;
    final String? name$value = data['name'] as String?;
    final double? population$value = data['population'] as double?;
    final List<String?>? climates$value =
        data['climates'] == null
            ? null
            : (data['climates'] as List<dynamic>)
                .map((e) => e as String?)
                .toList();
    return PlanetsPage_allPlanets_edges_node(
      terrains: terrains$value,

      id: id$value,

      diameter: diameter$value,

      name: name$value,

      population: population$value,

      climates: climates$value,
    );
  }
}

class PlanetsPage_allPlanets_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final bool hasNextPage;

  final String? endCursor;

  // keywordargs constructor
  PlanetsPage_allPlanets_pageInfo({required this.hasNextPage, this.endCursor});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlanetsPage_allPlanets_pageInfo &&
            hasNextPage == other.hasNextPage &&
            endCursor == other.endCursor);
  }

  @override
  int get hashCode => Object.hashAll([
    hasNextPage,

    endCursor,

    PlanetsPage_allPlanets_pageInfo.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'hasNextPage': this.hasNextPage, 'endCursor': this.endCursor};
  }

  @experimental
  static PlanetsPage_allPlanets_pageInfo fromJson(shalom_core.JsonObject data) {
    final bool hasNextPage$value = data['hasNextPage'] as bool;
    final String? endCursor$value = data['endCursor'] as String?;
    return PlanetsPage_allPlanets_pageInfo(
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

final class PlanetsPageData {
  final PlanetsPage_allPlanets? allPlanets;

  const PlanetsPageData({required this.allPlanets});

  @experimental
  static PlanetsPageData fromCache(shalom_core.JsonObject data) {
    final PlanetsPage_allPlanets? allPlanets$value =
        data['allPlanets'] == null
            ? null
            : PlanetsPage_allPlanets.fromJson(
              data['allPlanets'] as shalom_core.JsonObject,
            );
    return PlanetsPageData(allPlanets: allPlanets$value);
  }

  shalom_core.JsonObject toJson() {
    return {'allPlanets': this.allPlanets?.toJson()};
  }
}

final class PlanetsPageVariables {
  final shalom_core.Maybe<String?> after;

  final shalom_core.Maybe<int?> first;

  const PlanetsPageVariables({
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
        (other is PlanetsPageVariables &&
            this.after == other.after &&
            this.first == other.first);
  }

  @override
  int get hashCode => Object.hashAll([after, first]);
}

// ------------ END V2 WIDGET API -------------
