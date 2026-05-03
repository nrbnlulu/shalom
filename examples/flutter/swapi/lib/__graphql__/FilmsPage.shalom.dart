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
  final List<FilmWidgetRef?>? films;

  // keywordargs constructor
  FilmsPage_allFilms({this.films});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms &&
            const ListEquality().equals(films, other.films));
  }

  @override
  int get hashCode => Object.hashAll([films, FilmsPage_allFilms.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'films': this.films?.map((e) => e?.toJson()).toList()};
  }

  @experimental
  static FilmsPage_allFilms fromJson(shalom_core.JsonObject data) {
    final List<FilmWidgetRef?>? films$value =
        data['films'] == null
            ? null
            : (data['films'] as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : FilmWidgetRef.fromInput(
                            shalom_core.observedRefInputFromJson(
                              (e as shalom_core.JsonObject)[r'$FilmWidget']
                                  as shalom_core.JsonObject,
                            ),
                          ),
                )
                .toList();
    return FilmsPage_allFilms(films: films$value);
  }
}

class FilmsPage_allFilms_films {
  static String G__typename = "Film";

  /// class members
  final String? releaseDate;

  final String? title;

  final String id;

  final int? episodeID;

  final String? director;

  // keywordargs constructor
  FilmsPage_allFilms_films({
    this.releaseDate,

    this.title,

    required this.id,

    this.episodeID,

    this.director,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPage_allFilms_films &&
            releaseDate == other.releaseDate &&
            title == other.title &&
            id == other.id &&
            episodeID == other.episodeID &&
            director == other.director);
  }

  @override
  int get hashCode => Object.hashAll([
    releaseDate,

    title,

    id,

    episodeID,

    director,

    FilmsPage_allFilms_films.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'releaseDate': this.releaseDate,

      'title': this.title,

      'id': this.id,

      'episodeID': this.episodeID,

      'director': this.director,
    };
  }

  @experimental
  static FilmsPage_allFilms_films fromJson(shalom_core.JsonObject data) {
    final String? releaseDate$value = data['releaseDate'] as String?;
    final String? title$value = data['title'] as String?;
    final String id$value = data['id'] as String;
    final int? episodeID$value = data['episodeID'] as int?;
    final String? director$value = data['director'] as String?;
    return FilmsPage_allFilms_films(
      releaseDate: releaseDate$value,

      title: title$value,

      id: id$value,

      episodeID: episodeID$value,

      director: director$value,
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

  final shalom_core.Maybe<String?> before;

  final shalom_core.Maybe<int?> first;

  final shalom_core.Maybe<int?> last;

  const FilmsPageVariables({
    this.after = const shalom_core.None(),

    this.before = const shalom_core.None(),

    this.first = const shalom_core.None(),

    this.last = const shalom_core.None(),
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    if (after.isSome()) {
      final value = this.after.some();
      data["after"] = value;
    }
    if (before.isSome()) {
      final value = this.before.some();
      data["before"] = value;
    }
    if (first.isSome()) {
      final value = this.first.some();
      data["first"] = value;
    }
    if (last.isSome()) {
      final value = this.last.some();
      data["last"] = value;
    }

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FilmsPageVariables &&
            this.after == other.after &&
            this.before == other.before &&
            this.first == other.first &&
            this.last == other.last);
  }

  @override
  int get hashCode => Object.hashAll([after, before, first, last]);
}

// ------------ END V2 WIDGET API -------------
