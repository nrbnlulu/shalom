// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'FilmWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class FilmsPageResponse {
  static String G__typename = "query";

  /// class members
  final FilmsPage_allFilms? allFilms;

  // keywordargs constructor
  FilmsPageResponse({this.allFilms});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPageResponse && allFilms == other.allFilms);
  }

  @override
  int get hashCode => Object.hashAll([allFilms, FilmsPageResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'allFilms': this.allFilms?.toJson()};
  }

  @experimental
  static FilmsPageResponse fromJson(shalom_core.JsonObject data) {
    final FilmsPage_allFilms? allFilms$value =
        data['allFilms'] == null
            ? null
            : FilmsPage_allFilms.fromJson(
              data['allFilms'] as shalom_core.JsonObject,
            );
    return FilmsPageResponse(allFilms: allFilms$value);
  }
}

class FilmsPage_allFilms {
  static String G__typename = "FilmsConnection";

  /// class members
  final FilmsPage_allFilms_pageInfo pageInfo;

  final List<FilmsPage_allFilms_edges?>? edges;

  // keywordargs constructor
  FilmsPage_allFilms({required this.pageInfo, this.edges});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms &&
            pageInfo == other.pageInfo &&
            const ListEquality().equals(edges, other.edges));
  }

  @override
  int get hashCode =>
      Object.hashAll([pageInfo, edges, FilmsPage_allFilms.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'pageInfo': this.pageInfo.toJson(),

      'edges': this.edges?.map((e) => e?.toJson()).toList(),
    };
  }

  @experimental
  static FilmsPage_allFilms fromJson(shalom_core.JsonObject data) {
    final FilmsPage_allFilms_pageInfo pageInfo$value =
        FilmsPage_allFilms_pageInfo.fromJson(
          data['pageInfo'] as shalom_core.JsonObject,
        );
    final List<FilmsPage_allFilms_edges?>? edges$value =
        data['edges'] == null
            ? null
            : (data['edges'] as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : FilmsPage_allFilms_edges.fromJson(
                            e as shalom_core.JsonObject,
                          ),
                )
                .toList();
    return FilmsPage_allFilms(pageInfo: pageInfo$value, edges: edges$value);
  }
}

class FilmsPage_allFilms_edges {
  static String G__typename = "FilmsEdge";

  /// class members
  final FilmWidgetRef? node;

  final String cursor;

  // keywordargs constructor
  FilmsPage_allFilms_edges({this.node, required this.cursor});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms_edges &&
            node == other.node &&
            cursor == other.cursor);
  }

  @override
  int get hashCode =>
      Object.hashAll([node, cursor, FilmsPage_allFilms_edges.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'node': this.node?.toJson(), 'cursor': this.cursor};
  }

  @experimental
  static FilmsPage_allFilms_edges fromJson(shalom_core.JsonObject data) {
    final FilmWidgetRef? node$value =
        data['node'] == null
            ? null
            : FilmWidgetRef.fromInput(
              shalom_core.observedRefInputFromJson(
                (data['node'] as shalom_core.JsonObject)[r'$FilmWidget']
                    as shalom_core.JsonObject,
              ),
            );
    final String cursor$value = data['cursor'] as String;
    return FilmsPage_allFilms_edges(node: node$value, cursor: cursor$value);
  }
}

class FilmsPage_allFilms_edges_node {
  static String G__typename = "Film";

  /// class members
  final String? releaseDate;

  final String id;

  final String? title;

  final int? episodeID;

  final String? director;

  // keywordargs constructor
  FilmsPage_allFilms_edges_node({
    this.releaseDate,

    required this.id,

    this.title,

    this.episodeID,

    this.director,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms_edges_node &&
            releaseDate == other.releaseDate &&
            id == other.id &&
            title == other.title &&
            episodeID == other.episodeID &&
            director == other.director);
  }

  @override
  int get hashCode => Object.hashAll([
    releaseDate,

    id,

    title,

    episodeID,

    director,

    FilmsPage_allFilms_edges_node.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'releaseDate': this.releaseDate,

      'id': this.id,

      'title': this.title,

      'episodeID': this.episodeID,

      'director': this.director,
    };
  }

  @experimental
  static FilmsPage_allFilms_edges_node fromJson(shalom_core.JsonObject data) {
    final String? releaseDate$value = data['releaseDate'] as String?;
    final String id$value = data['id'] as String;
    final String? title$value = data['title'] as String?;
    final int? episodeID$value = data['episodeID'] as int?;
    final String? director$value = data['director'] as String?;
    return FilmsPage_allFilms_edges_node(
      releaseDate: releaseDate$value,

      id: id$value,

      title: title$value,

      episodeID: episodeID$value,

      director: director$value,
    );
  }
}

class FilmsPage_allFilms_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final String? endCursor;

  final bool hasNextPage;

  // keywordargs constructor
  FilmsPage_allFilms_pageInfo({this.endCursor, required this.hasNextPage});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms_pageInfo &&
            endCursor == other.endCursor &&
            hasNextPage == other.hasNextPage);
  }

  @override
  int get hashCode => Object.hashAll([
    endCursor,

    hasNextPage,

    FilmsPage_allFilms_pageInfo.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'endCursor': this.endCursor, 'hasNextPage': this.hasNextPage};
  }

  @experimental
  static FilmsPage_allFilms_pageInfo fromJson(shalom_core.JsonObject data) {
    final String? endCursor$value = data['endCursor'] as String?;
    final bool hasNextPage$value = data['hasNextPage'] as bool;
    return FilmsPage_allFilms_pageInfo(
      endCursor: endCursor$value,

      hasNextPage: hasNextPage$value,
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

final class FilmsPageData {
  final FilmsPage_allFilms? allFilms;

  const FilmsPageData({required this.allFilms});

  @experimental
  static FilmsPageData fromCache(shalom_core.JsonObject data) {
    final FilmsPage_allFilms? allFilms$value =
        data['allFilms'] == null
            ? null
            : FilmsPage_allFilms.fromJson(
              data['allFilms'] as shalom_core.JsonObject,
            );
    return FilmsPageData(allFilms: allFilms$value);
  }

  shalom_core.JsonObject toJson() {
    return {'allFilms': this.allFilms?.toJson()};
  }
}

final class FilmsPageVariables {
  final shalom_core.Maybe<String?> after;

  final shalom_core.Maybe<int?> first;

  const FilmsPageVariables({
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
        (other is FilmsPageVariables &&
            this.after == other.after &&
            this.first == other.first);
  }

  @override
  int get hashCode => Object.hashAll([after, first]);
}

// ------------ END V2 WIDGET API -------------
