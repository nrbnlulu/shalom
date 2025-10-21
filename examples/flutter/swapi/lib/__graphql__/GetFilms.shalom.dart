// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast

import "../schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class GetFilmsResponse {
  /// class members

  final GetFilms_allFilms? allFilms;

  // keywordargs constructor
  GetFilmsResponse({this.allFilms});

  static void normalize$inCache(JsonObject data, CacheUpdateContext ctx) {
    final String this$normalizedID = "ROOT_QUERY";
    final this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
      "ROOT_QUERY",
    );
    final allFilmsNormalized$Key = "allFilms";
    final allFilms$normalizedID =
        "${this$normalizedID}.${allFilmsNormalized$Key}";
    ctx.addDependantRecords({allFilms$normalizedID});

    final allFilms$cached = this$NormalizedRecord[allFilmsNormalized$Key];
    final allFilms$raw = data["allFilms"];
    if (allFilms$raw != null) {
      if (allFilms$cached == null) {
        ctx.addChangedRecord(allFilms$normalizedID);
      }

      GetFilms_allFilms.normalize$inCache(
        allFilms$raw as JsonObject,
        ctx,

        this$cached:
            allFilms$cached is NormalizedObjectRecord
                ? ctx.shalomContext.getCachedRecord(
                  allFilms$cached.normalizedID(),
                )
                : allFilms$cached,
        this$fieldName: allFilmsNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final allFilms$id = (allFilms$raw as JsonObject)["id"] as RecordID?;
      if (allFilms$id != null) {
        final allFilms$normalized = NormalizedObjectRecord(
          typename: "FilmsConnection",
          id: allFilms$id,
        );
        this$NormalizedRecord[allFilmsNormalized$Key] = allFilms$normalized;

        if (allFilms$cached != null &&
            allFilms$cached is NormalizedObjectRecord &&
            allFilms$cached != allFilms$normalized) {
          ctx.addChangedRecord(allFilms$normalizedID);
        }
      } else {
        this$NormalizedRecord[allFilmsNormalized$Key] = getOrCreateObject(
          this$NormalizedRecord,
          allFilmsNormalized$Key,
        );
      }
    } else if (data.containsKey("allFilms") && allFilms$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[allFilmsNormalized$Key] = null;
      ctx.addChangedRecord(allFilms$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[allFilmsNormalized$Key] = null;
    }
  }

  static GetFilmsResponse fromCache(ShalomCtx ctx) {
    final data = ctx.getCachedRecord("ROOT_QUERY");
    final allFilms$raw = data["allFilms"];
    final GetFilms_allFilms? allFilms$value =
        allFilms$raw == null
            ? null
            : GetFilms_allFilms.fromCached(allFilms$raw, ctx);
    return GetFilmsResponse(allFilms: allFilms$value);
  }

  static (GetFilmsResponse, CacheUpdateContext) fromResponseImpl(
    JsonObject data,
    ShalomCtx ctx,
  ) {
    // first update the cache
    final updateCtx = CacheUpdateContext(shalomContext: ctx);
    normalize$inCache(data, updateCtx);
    ctx.invalidateRefs(updateCtx.changedRecords);
    return (fromCache(ctx), updateCtx);
  }

  static GetFilmsResponse fromResponse(JsonObject data, {ShalomCtx? ctx}) {
    // if ctx not provider we create dummy one
    return fromResponseImpl(data, ctx ?? ShalomCtx.withCapacity()).$1;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilmsResponse && allFilms == other.allFilms);
  }

  @override
  int get hashCode => allFilms.hashCode;

  JsonObject toJson() {
    return {'allFilms': this.allFilms?.toJson()};
  }
}

class GetFilms_allFilms {
  /// class members

  final List<GetFilms_allFilms_films?>? films;

  // keywordargs constructor
  GetFilms_allFilms({this.films});

  static void normalize$inCache(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject? this$cached,
    required JsonObject parent$record,
    required RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    final RecordID? this$normalizedID_temp = data["id"] as RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    } else {
      final normalized$objRecord = NormalizedObjectRecord(
        typename: "FilmsConnection",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is NormalizedObjectRecord &&
          this$cached as NormalizedObjectRecord != normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }

    final filmsNormalized$Key = "films";
    final films$normalizedID = "${this$normalizedID}.${filmsNormalized$Key}";
    ctx.addDependantRecords({films$normalizedID});

    final films$cached = this$NormalizedRecord[filmsNormalized$Key];
    final films$raw = data["films"];
    if (films$raw != null) {
      final films$rawList = films$raw as List<dynamic>;
      final films$cachedList = films$cached as List<dynamic>?;

      if (films$cachedList == null ||
          films$cachedList.length != films$rawList.length) {
        ctx.addChangedRecord(films$normalizedID);
      }

      final films$normalizedList = <dynamic>[];

      for (int i = 0; i < films$rawList.length; i++) {
        final item$raw = films$rawList[i];
        final item$cached = films$cachedList?.elementAtOrNull(i);
        final item$normalizedKey = "$i";

        if (item$raw != null) {
          if (item$cached == null) {
            ctx.addChangedRecord(films$normalizedID);
          }

          GetFilms_allFilms_films.normalize$inCache(
            item$raw as JsonObject,
            ctx,

            this$cached:
                item$cached is NormalizedObjectRecord
                    ? ctx.shalomContext.getCachedRecord(
                      item$cached.normalizedID(),
                    )
                    : item$cached,
            this$fieldName: item$normalizedKey,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID,
          );

          final films$item$id = (item$raw as JsonObject)["id"] as RecordID?;
          if (films$item$id != null) {
            final films$item$normalized = NormalizedObjectRecord(
              typename: "Film",
              id: films$item$id,
            );
            this$NormalizedRecord[item$normalizedKey] = films$item$normalized;

            if (item$cached != null &&
                item$cached is NormalizedObjectRecord &&
                item$cached != films$item$normalized) {
              ctx.addChangedRecord(films$normalizedID);
            }
          } else {
            this$NormalizedRecord[item$normalizedKey] = getOrCreateObject(
              this$NormalizedRecord,
              item$normalizedKey,
            );
          }
        } else {
          if (item$cached != null) {
            ctx.addChangedRecord(films$normalizedID);
          }
          this$NormalizedRecord[item$normalizedKey] = null;
        }

        films$normalizedList.add(this$NormalizedRecord[item$normalizedKey]);
      }

      this$NormalizedRecord[filmsNormalized$Key] = films$normalizedList;
    } else if (data.containsKey("films") && films$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[filmsNormalized$Key] = null;
      ctx.addChangedRecord(films$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[filmsNormalized$Key] = null;
    }
  }

  static GetFilms_allFilms fromCached(
    NormalizedRecordData data,
    ShalomCtx ctx,
  ) {
    final films$raw = data["films"];
    final List<GetFilms_allFilms_films?>? films$value =
        films$raw == null
            ? null
            : (films$raw as List<dynamic>)
                .map(
                  (e) =>
                      e == null
                          ? null
                          : GetFilms_allFilms_films.fromCached(e, ctx),
                )
                .toList();
    return GetFilms_allFilms(films: films$value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilms_allFilms &&
            const ListEquality().equals(films, other.films));
  }

  @override
  int get hashCode => films.hashCode;

  JsonObject toJson() {
    return {'films': this.films?.map((e) => e?.toJson()).toList()};
  }
}

class GetFilms_allFilms_films {
  /// class members

  final String? title;

  final String? director;

  final String? releaseDate;

  final int? episodeID;

  // keywordargs constructor
  GetFilms_allFilms_films({
    this.title,

    this.director,

    this.releaseDate,

    this.episodeID,
  });

  static void normalize$inCache(
    JsonObject data,
    CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required RecordID this$fieldName,
    required JsonObject? this$cached,
    required JsonObject parent$record,
    required RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    JsonObject this$NormalizedRecord;

    final RecordID? this$normalizedID_temp = data["id"] as RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = getOrCreateObject(parent$record, this$fieldName);
    } else {
      final normalized$objRecord = NormalizedObjectRecord(
        typename: "Film",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is NormalizedObjectRecord &&
          this$cached as NormalizedObjectRecord != normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }

    final titleNormalized$Key = "title";
    final title$normalizedID = "${this$normalizedID}.${titleNormalized$Key}";
    final directorNormalized$Key = "director";
    final director$normalizedID =
        "${this$normalizedID}.${directorNormalized$Key}";
    final releaseDateNormalized$Key = "releaseDate";
    final releaseDate$normalizedID =
        "${this$normalizedID}.${releaseDateNormalized$Key}";
    final episodeIDNormalized$Key = "episodeID";
    final episodeID$normalizedID =
        "${this$normalizedID}.${episodeIDNormalized$Key}";
    ctx.addDependantRecords({
      title$normalizedID,
      director$normalizedID,
      releaseDate$normalizedID,
      episodeID$normalizedID,
    });

    final title$cached = this$NormalizedRecord[titleNormalized$Key];
    final title$raw = data["title"];
    if (title$raw != null) {
      if (title$cached != title$raw) {
        ctx.addChangedRecord(title$normalizedID);
      }
      this$NormalizedRecord[titleNormalized$Key] = title$raw;
    } else if (data.containsKey("title") && title$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[titleNormalized$Key] = null;
      ctx.addChangedRecord(title$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[titleNormalized$Key] = null;
    }

    final director$cached = this$NormalizedRecord[directorNormalized$Key];
    final director$raw = data["director"];
    if (director$raw != null) {
      if (director$cached != director$raw) {
        ctx.addChangedRecord(director$normalizedID);
      }
      this$NormalizedRecord[directorNormalized$Key] = director$raw;
    } else if (data.containsKey("director") && director$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[directorNormalized$Key] = null;
      ctx.addChangedRecord(director$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[directorNormalized$Key] = null;
    }

    final releaseDate$cached = this$NormalizedRecord[releaseDateNormalized$Key];
    final releaseDate$raw = data["releaseDate"];
    if (releaseDate$raw != null) {
      if (releaseDate$cached != releaseDate$raw) {
        ctx.addChangedRecord(releaseDate$normalizedID);
      }
      this$NormalizedRecord[releaseDateNormalized$Key] = releaseDate$raw;
    } else if (data.containsKey("releaseDate") && releaseDate$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[releaseDateNormalized$Key] = null;
      ctx.addChangedRecord(releaseDate$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[releaseDateNormalized$Key] = null;
    }

    final episodeID$cached = this$NormalizedRecord[episodeIDNormalized$Key];
    final episodeID$raw = data["episodeID"];
    if (episodeID$raw != null) {
      if (episodeID$cached != episodeID$raw) {
        ctx.addChangedRecord(episodeID$normalizedID);
      }
      this$NormalizedRecord[episodeIDNormalized$Key] = episodeID$raw;
    } else if (data.containsKey("episodeID") && episodeID$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[episodeIDNormalized$Key] = null;
      ctx.addChangedRecord(episodeID$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[episodeIDNormalized$Key] = null;
    }
  }

  static GetFilms_allFilms_films fromCached(
    NormalizedRecordData data,
    ShalomCtx ctx,
  ) {
    final title$raw = data["title"];
    final String? title$value = title$raw as String?;
    final director$raw = data["director"];
    final String? director$value = director$raw as String?;
    final releaseDate$raw = data["releaseDate"];
    final String? releaseDate$value = releaseDate$raw as String?;
    final episodeID$raw = data["episodeID"];
    final int? episodeID$value = episodeID$raw as int?;
    return GetFilms_allFilms_films(
      title: title$value,

      director: director$value,

      releaseDate: releaseDate$value,

      episodeID: episodeID$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetFilms_allFilms_films &&
            title == other.title &&
            director == other.director &&
            releaseDate == other.releaseDate &&
            episodeID == other.episodeID);
  }

  @override
  int get hashCode => Object.hashAll([title, director, releaseDate, episodeID]);

  JsonObject toJson() {
    return {
      'title': this.title,

      'director': this.director,

      'releaseDate': this.releaseDate,

      'episodeID': this.episodeID,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

class RequestGetFilms extends Requestable<GetFilmsResponse> {
  RequestGetFilms();
  @override
  RequestMeta<GetFilmsResponse> getRequestMeta() {
    JsonObject variablesJson = {};
    final request = Request(
      query: r"""query GetFilms {
  allFilms {
    films {
      title
      director
      releaseDate
      episodeID
    }
  }
}
""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetFilms',
    );
    return RequestMeta(
      request: request,
      loadFn: ({required JsonObject data, required ShalomCtx ctx}) {
        final (deserialized, updatedCtx) = GetFilmsResponse.fromResponseImpl(
          data,
          ctx,
        );
        return (deserialized, updatedCtx.dependantRecords);
      },
      fromCacheFn: (ShalomCtx ctx) {
        final updateCtx = CacheUpdateContext(shalomContext: ctx);
        final deserialized = GetFilmsResponse.fromCache(ctx);
        return (deserialized, updateCtx.dependantRecords);
      },
    );
  }
}
