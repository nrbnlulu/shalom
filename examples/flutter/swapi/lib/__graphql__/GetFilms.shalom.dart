// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class GetFilmsResponse {
  static String G__typename = "query";

  /// class members
  final GetFilms_allFilms? allFilms;

  // keywordargs constructor
  GetFilmsResponse({this.allFilms});

  static GetFilmsResponse fromJson(shalom_core.JsonObject data) {
    return fromJson(data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilmsResponse && allFilms == other.allFilms);
  }

  @override
  int get hashCode => Object.hashAll([allFilms, GetFilmsResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'allFilms': this.allFilms?.toJson()};
  }

  @experimental
  static GetFilmsResponse fromJson(shalom_core.JsonObject data) {
    final GetFilms_allFilms? allFilms$value =
        data['allFilms'] == null
            ? null
            : GetFilms_allFilms.fromJson(
              data['allFilms'] as shalom_core.JsonObject,
            );
    return GetFilmsResponse(allFilms: allFilms$value);
  }
}

class GetFilms_allFilms {
  static String G__typename = "FilmsConnection";

  /// class members
  final List<GetFilms_allFilms_films?>? films;

  // keywordargs constructor
  GetFilms_allFilms({this.films});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilms_allFilms &&
            const ListEquality().equals(films, other.films));
  }

  @override
  int get hashCode => Object.hashAll([films, GetFilms_allFilms.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'films': this.films?.map((e) => e?.toJson()).toList()};
  }

  @experimental
  static GetFilms_allFilms fromJson(shalom_core.JsonObject data) {
    final List<GetFilms_allFilms_films?>? films$value =
        data['films'] == null
            ? null
            : (data['films'] as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : GetFilms_allFilms_films.fromJson(
                            e as shalom_core.JsonObject,
                          ),
                )
                .toList();
    return GetFilms_allFilms(films: films$value);
  }
}

class GetFilms_allFilms_films {
  static String G__typename = "Film";

  /// class members
  final String? title;

  final String? director;

  final String id;

  final int? episodeID;

  final String? releaseDate;

  // keywordargs constructor
  GetFilms_allFilms_films({
    this.title,

    this.director,

    required this.id,

    this.episodeID,

    this.releaseDate,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilms_allFilms_films &&
            title == other.title &&
            director == other.director &&
            id == other.id &&
            episodeID == other.episodeID &&
            releaseDate == other.releaseDate);
  }

  @override
  int get hashCode => Object.hashAll([
    title,

    director,

    id,

    episodeID,

    releaseDate,

    GetFilms_allFilms_films.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'title': this.title,

      'director': this.director,

      'id': this.id,

      'episodeID': this.episodeID,

      'releaseDate': this.releaseDate,
    };
  }

  @experimental
  static GetFilms_allFilms_films fromJson(shalom_core.JsonObject data) {
    final String? title$value = data['title'] as String?;
    final String? director$value = data['director'] as String?;
    final String id$value = data['id'] as String;
    final int? episodeID$value = data['episodeID'] as int?;
    final String? releaseDate$value = data['releaseDate'] as String?;
    return GetFilms_allFilms_films(
      title: title$value,

      director: director$value,

      id: id$value,

      episodeID: episodeID$value,

      releaseDate: releaseDate$value,
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

class RequestGetFilms extends shalom_core.Requestable<GetFilmsResponse> {
  RequestGetFilms();
  @override
  shalom_core.RequestMeta<GetFilmsResponse> getRequestMeta() {
    shalom_core.JsonObject variablesJson = {};
    final request = shalom_core.Request(
      query: r"""
            query GetFilms {
  allFilms {
    films {
      title
      director
      releaseDate
      episodeID
      id
    }
  }
}
            """,
      variables: variablesJson,
      opType: shalom_core.OperationType.Query,
      opName: 'GetFilms',
    );
    return shalom_core.RequestMeta(
      request: request,
      parseFn: (shalom_core.JsonObject data) => GetFilmsResponse.fromJson(data),
    );
  }
}
