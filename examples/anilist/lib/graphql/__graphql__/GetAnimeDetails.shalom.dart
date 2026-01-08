// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'CharacterCard.shalom.dart';
import 'MediaCard.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class GetAnimeDetailsResponse {
  static String G__typename = "query";

  /// class members
  final GetAnimeDetails_Media? Media;

  // keywordargs constructor
  GetAnimeDetailsResponse({this.Media});

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final String this$normalizedID = "ROOT_QUERY";
    final this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
      "ROOT_QUERY",
    );
    final MediaNormalized$Key = '''Media(id:${variables.id}, type:ANIME)''';
    final Media$normalizedID = "${this$normalizedID}.${MediaNormalized$Key}";
    ctx.addDependantRecords({Media$normalizedID});
    final Media$cached = this$NormalizedRecord[MediaNormalized$Key];
    final Media$raw = data["Media"];
    if (Media$raw != null) {
      if (Media$cached == null) {
        ctx.addChangedRecord(Media$normalizedID);
      }

      GetAnimeDetails_Media.normalize$inCache(
        Media$raw as shalom_core.JsonObject,
        ctx,
        variables,
        this$cached: Media$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(Media$cached.normalizedID())
            : Media$cached,
        this$fieldName: MediaNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final Media$id =
          (Media$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
      if (Media$id != null) {
        final Media$normalized = shalom_core.NormalizedObjectRecord(
          typename: "Media",
          id: Media$id,
        );
        this$NormalizedRecord[MediaNormalized$Key] = Media$normalized;

        if (Media$cached != null &&
            Media$cached is shalom_core.NormalizedObjectRecord &&
            Media$cached != Media$normalized) {
          ctx.addChangedRecord(Media$normalizedID);
        }
      } else {
        this$NormalizedRecord[MediaNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, MediaNormalized$Key);
      }
    } else if (data.containsKey("Media") && Media$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[MediaNormalized$Key] = null;
      ctx.addChangedRecord(Media$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[MediaNormalized$Key] = null;
    }
  }

  static GetAnimeDetailsResponse fromCache(
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final data = ctx.getCachedRecord("ROOT_QUERY");
    final Media$cacheKey = '''Media(id:${variables.id}, type:ANIME)''';
    final Media$raw = data[Media$cacheKey];
    final GetAnimeDetails_Media? Media$value = Media$raw == null
        ? null
        : (Media$raw is shalom_core.NormalizedObjectRecord)
        ? GetAnimeDetails_Media.fromCached(
            ctx.getCachedRecord(
              (Media$raw as shalom_core.NormalizedObjectRecord).normalizedID(),
            ),
            ctx,
            variables,
          )
        : GetAnimeDetails_Media.fromCached(Media$raw, ctx, variables);
    return GetAnimeDetailsResponse(Media: Media$value);
  }

  static (GetAnimeDetailsResponse, shalom_core.CacheUpdateContext)
  fromResponseImpl(
    shalom_core.JsonObject data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    // first update the cache
    final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
    normalize$inCache(data, updateCtx, variables);
    ctx.invalidateRefs(updateCtx.changedRecords);
    return (fromCache(ctx, variables), updateCtx);
  }

  static GetAnimeDetailsResponse fromResponse(
    shalom_core.JsonObject data, {
    shalom_core.ShalomCtx? ctx,
    required GetAnimeDetailsVariables variables,
  }) {
    // if ctx not provider we create dummy one
    return fromResponseImpl(
      data,
      ctx ?? shalom_core.ShalomCtx.withCapacity(),
      variables,
    ).$1;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetailsResponse && Media == other.Media);
  }

  @override
  int get hashCode =>
      Object.hashAll([Media, GetAnimeDetailsResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'Media': this.Media?.toJson()};
  }

  @experimental
  static GetAnimeDetailsResponse fromJson(shalom_core.JsonObject data) {
    final GetAnimeDetails_Media? Media$value = data['Media'] == null
        ? null
        : GetAnimeDetails_Media.fromJson(
            data['Media'] as shalom_core.JsonObject,
          );
    return GetAnimeDetailsResponse(Media: Media$value);
  }
}

class GetAnimeDetails_Media implements MediaCard {
  static String G__typename = "Media";

  /// class members
  final List<GetAnimeDetails_Media_streamingEpisodes?>? streamingEpisodes;

  final MediaFormat? format;

  final int? episodes;

  final String? description;

  final MediaCard_coverImage? coverImage;

  final int id;

  final MediaCard_title? title;

  final GetAnimeDetails_Media_characters? characters;

  // keywordargs constructor
  GetAnimeDetails_Media({
    this.streamingEpisodes,

    this.format,

    this.episodes,

    this.description,

    this.coverImage,

    required this.id,

    this.title,

    this.characters,
  });

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "Media",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final streamingEpisodesNormalized$Key = "streamingEpisodes";
    final streamingEpisodes$normalizedID =
        "${this$normalizedID}.${streamingEpisodesNormalized$Key}";
    final formatNormalized$Key = "format";
    final format$normalizedID = "${this$normalizedID}.${formatNormalized$Key}";
    final episodesNormalized$Key = "episodes";
    final episodes$normalizedID =
        "${this$normalizedID}.${episodesNormalized$Key}";
    final descriptionNormalized$Key = '''description(asHtml:false)''';
    final description$normalizedID =
        "${this$normalizedID}.${descriptionNormalized$Key}";
    final coverImageNormalized$Key = "coverImage";
    final coverImage$normalizedID =
        "${this$normalizedID}.${coverImageNormalized$Key}";
    final idNormalized$Key = "id";
    final id$normalizedID = "${this$normalizedID}.${idNormalized$Key}";
    final titleNormalized$Key = "title";
    final title$normalizedID = "${this$normalizedID}.${titleNormalized$Key}";
    final charactersNormalized$Key =
        '''characters(page:${variables.page}, perPage:${variables.perPage})''';
    final characters$normalizedID =
        "${this$normalizedID}.${charactersNormalized$Key}";
    ctx.addDependantRecords({
      streamingEpisodes$normalizedID,
      format$normalizedID,
      episodes$normalizedID,
      description$normalizedID,
      coverImage$normalizedID,
      id$normalizedID,
      title$normalizedID,
      characters$normalizedID,
    });
    final streamingEpisodes$cached =
        this$NormalizedRecord[streamingEpisodesNormalized$Key];
    final streamingEpisodes$raw = data["streamingEpisodes"];
    if (streamingEpisodes$raw != null) {
      final streamingEpisodes$rawList = streamingEpisodes$raw as List<dynamic>;
      final streamingEpisodes$cachedList =
          streamingEpisodes$cached as List<dynamic>?;

      if (streamingEpisodes$cachedList == null ||
          streamingEpisodes$cachedList.length !=
              streamingEpisodes$rawList.length) {
        ctx.addChangedRecord(streamingEpisodes$normalizedID);
      }

      final streamingEpisodes$normalizedList = <dynamic>[];

      for (int i = 0; i < streamingEpisodes$rawList.length; i++) {
        final item$raw = streamingEpisodes$rawList[i];
        final item$cached = streamingEpisodes$cachedList?.elementAtOrNull(i);
        final item$normalizedKey = "streamingEpisodes$i";

        if (item$raw != null) {
          if (item$cached == null) {
            ctx.addChangedRecord(streamingEpisodes$normalizedID);
          }

          GetAnimeDetails_Media_streamingEpisodes.normalize$inCache(
            item$raw as shalom_core.JsonObject,
            ctx,
            variables,
            this$cached: item$cached is shalom_core.NormalizedObjectRecord
                ? ctx.shalomContext.getCachedRecord(item$cached.normalizedID())
                : item$cached,
            this$fieldName: item$normalizedKey,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID,
          );

          final streamingEpisodes$item$id =
              (item$raw as shalom_core.JsonObject)["id"]
                  as shalom_core.RecordID?;
          if (streamingEpisodes$item$id != null) {
            final streamingEpisodes$item$normalized =
                shalom_core.NormalizedObjectRecord(
                  typename: "MediaStreamingEpisode",
                  id: streamingEpisodes$item$id,
                );
            this$NormalizedRecord[item$normalizedKey] =
                streamingEpisodes$item$normalized;

            if (item$cached != null &&
                item$cached is shalom_core.NormalizedObjectRecord &&
                item$cached != streamingEpisodes$item$normalized) {
              ctx.addChangedRecord(streamingEpisodes$normalizedID);
            }
          } else {
            this$NormalizedRecord[item$normalizedKey] = shalom_core
                .getOrCreateObject(this$NormalizedRecord, item$normalizedKey);
          }
        } else {
          if (item$cached != null) {
            ctx.addChangedRecord(streamingEpisodes$normalizedID);
          }
          this$NormalizedRecord[item$normalizedKey] = null;
        }

        streamingEpisodes$normalizedList.add(
          this$NormalizedRecord[item$normalizedKey],
        );
      }

      this$NormalizedRecord[streamingEpisodesNormalized$Key] =
          streamingEpisodes$normalizedList;
    } else if (data.containsKey("streamingEpisodes") &&
        streamingEpisodes$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[streamingEpisodesNormalized$Key] = null;
      ctx.addChangedRecord(streamingEpisodes$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[streamingEpisodesNormalized$Key] = null;
    }
    final format$cached = this$NormalizedRecord[formatNormalized$Key];
    final format$raw = data["format"];
    if (format$raw != null) {
      if (format$cached != format$raw) {
        ctx.addChangedRecord(format$normalizedID);
      }
      this$NormalizedRecord[formatNormalized$Key] = format$raw;
    } else if (data.containsKey("format") && format$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[formatNormalized$Key] = null;
      ctx.addChangedRecord(format$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[formatNormalized$Key] = null;
    }
    final episodes$cached = this$NormalizedRecord[episodesNormalized$Key];
    final episodes$raw = data["episodes"];
    if (episodes$raw != null) {
      if (episodes$cached != episodes$raw) {
        ctx.addChangedRecord(episodes$normalizedID);
      }
      this$NormalizedRecord[episodesNormalized$Key] = episodes$raw;
    } else if (data.containsKey("episodes") && episodes$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[episodesNormalized$Key] = null;
      ctx.addChangedRecord(episodes$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[episodesNormalized$Key] = null;
    }
    final description$cached = this$NormalizedRecord[descriptionNormalized$Key];
    final description$raw = data["description"];
    if (description$raw != null) {
      if (description$cached != description$raw) {
        ctx.addChangedRecord(description$normalizedID);
      }
      this$NormalizedRecord[descriptionNormalized$Key] = description$raw;
    } else if (data.containsKey("description") && description$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[descriptionNormalized$Key] = null;
      ctx.addChangedRecord(description$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[descriptionNormalized$Key] = null;
    }
    final coverImage$cached = this$NormalizedRecord[coverImageNormalized$Key];
    final coverImage$raw = data["coverImage"];
    if (coverImage$raw != null) {
      if (coverImage$cached == null) {
        ctx.addChangedRecord(coverImage$normalizedID);
      }

      MediaCard_coverImage.normalize$inCache(
        coverImage$raw as shalom_core.JsonObject,
        ctx,

        this$cached: coverImage$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(
                coverImage$cached.normalizedID(),
              )
            : coverImage$cached,
        this$fieldName: coverImageNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final coverImage$id =
          (coverImage$raw as shalom_core.JsonObject)["id"]
              as shalom_core.RecordID?;
      if (coverImage$id != null) {
        final coverImage$normalized = shalom_core.NormalizedObjectRecord(
          typename: "MediaCoverImage",
          id: coverImage$id,
        );
        this$NormalizedRecord[coverImageNormalized$Key] = coverImage$normalized;

        if (coverImage$cached != null &&
            coverImage$cached is shalom_core.NormalizedObjectRecord &&
            coverImage$cached != coverImage$normalized) {
          ctx.addChangedRecord(coverImage$normalizedID);
        }
      } else {
        this$NormalizedRecord[coverImageNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, coverImageNormalized$Key);
      }
    } else if (data.containsKey("coverImage") && coverImage$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[coverImageNormalized$Key] = null;
      ctx.addChangedRecord(coverImage$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[coverImageNormalized$Key] = null;
    }
    final id$cached = this$NormalizedRecord[idNormalized$Key];
    final id$raw = data["id"];
    if (id$raw != null) {
      if (id$cached != id$raw) {
        ctx.addChangedRecord(id$normalizedID);
      }
      this$NormalizedRecord[idNormalized$Key] = id$raw;
    } else if (data.containsKey("id") && id$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[idNormalized$Key] = null;
      ctx.addChangedRecord(id$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[idNormalized$Key] = null;
    }
    final title$cached = this$NormalizedRecord[titleNormalized$Key];
    final title$raw = data["title"];
    if (title$raw != null) {
      if (title$cached == null) {
        ctx.addChangedRecord(title$normalizedID);
      }

      MediaCard_title.normalize$inCache(
        title$raw as shalom_core.JsonObject,
        ctx,

        this$cached: title$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(title$cached.normalizedID())
            : title$cached,
        this$fieldName: titleNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final title$id =
          (title$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
      if (title$id != null) {
        final title$normalized = shalom_core.NormalizedObjectRecord(
          typename: "MediaTitle",
          id: title$id,
        );
        this$NormalizedRecord[titleNormalized$Key] = title$normalized;

        if (title$cached != null &&
            title$cached is shalom_core.NormalizedObjectRecord &&
            title$cached != title$normalized) {
          ctx.addChangedRecord(title$normalizedID);
        }
      } else {
        this$NormalizedRecord[titleNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, titleNormalized$Key);
      }
    } else if (data.containsKey("title") && title$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[titleNormalized$Key] = null;
      ctx.addChangedRecord(title$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[titleNormalized$Key] = null;
    }
    final characters$cached = this$NormalizedRecord[charactersNormalized$Key];
    final characters$raw = data["characters"];
    if (characters$raw != null) {
      if (characters$cached == null) {
        ctx.addChangedRecord(characters$normalizedID);
      }

      GetAnimeDetails_Media_characters.normalize$inCache(
        characters$raw as shalom_core.JsonObject,
        ctx,
        variables,
        this$cached: characters$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(
                characters$cached.normalizedID(),
              )
            : characters$cached,
        this$fieldName: charactersNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final characters$id =
          (characters$raw as shalom_core.JsonObject)["id"]
              as shalom_core.RecordID?;
      if (characters$id != null) {
        final characters$normalized = shalom_core.NormalizedObjectRecord(
          typename: "CharacterConnection",
          id: characters$id,
        );
        this$NormalizedRecord[charactersNormalized$Key] = characters$normalized;

        if (characters$cached != null &&
            characters$cached is shalom_core.NormalizedObjectRecord &&
            characters$cached != characters$normalized) {
          ctx.addChangedRecord(characters$normalizedID);
        }
      } else {
        this$NormalizedRecord[charactersNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, charactersNormalized$Key);
      }
    } else if (data.containsKey("characters") && characters$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[charactersNormalized$Key] = null;
      ctx.addChangedRecord(characters$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[charactersNormalized$Key] = null;
    }
  }

  static GetAnimeDetails_Media fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final streamingEpisodes$raw = data["streamingEpisodes"];
    final List<GetAnimeDetails_Media_streamingEpisodes?>?
    streamingEpisodes$value = streamingEpisodes$raw == null
        ? null
        : (streamingEpisodes$raw as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : (e is shalom_core.NormalizedObjectRecord)
                    ? GetAnimeDetails_Media_streamingEpisodes.fromCached(
                        ctx.getCachedRecord(
                          (e as shalom_core.NormalizedObjectRecord)
                              .normalizedID(),
                        ),
                        ctx,
                        variables,
                      )
                    : GetAnimeDetails_Media_streamingEpisodes.fromCached(
                        e,
                        ctx,
                        variables,
                      ),
              )
              .toList();
    final format$raw = data["format"];
    final MediaFormat? format$value = format$raw == null
        ? null
        : MediaFormat.fromString(format$raw);
    final episodes$raw = data["episodes"];
    final int? episodes$value = episodes$raw as int?;
    final description$cacheKey = '''description(asHtml:false)''';
    final description$raw = data[description$cacheKey];
    final String? description$value = description$raw as String?;
    final coverImage$raw = data["coverImage"];
    final MediaCard_coverImage? coverImage$value = coverImage$raw == null
        ? null
        : (coverImage$raw is shalom_core.NormalizedObjectRecord)
        ? MediaCard_coverImage.fromCached(
            ctx.getCachedRecord(
              (coverImage$raw as shalom_core.NormalizedObjectRecord)
                  .normalizedID(),
            ),
            ctx,
          )
        : MediaCard_coverImage.fromCached(coverImage$raw, ctx);
    final id$raw = data["id"];
    final int id$value = id$raw as int;
    final title$raw = data["title"];
    final MediaCard_title? title$value = title$raw == null
        ? null
        : (title$raw is shalom_core.NormalizedObjectRecord)
        ? MediaCard_title.fromCached(
            ctx.getCachedRecord(
              (title$raw as shalom_core.NormalizedObjectRecord).normalizedID(),
            ),
            ctx,
          )
        : MediaCard_title.fromCached(title$raw, ctx);
    final characters$cacheKey =
        '''characters(page:${variables.page}, perPage:${variables.perPage})''';
    final characters$raw = data[characters$cacheKey];
    final GetAnimeDetails_Media_characters? characters$value =
        characters$raw == null
        ? null
        : (characters$raw is shalom_core.NormalizedObjectRecord)
        ? GetAnimeDetails_Media_characters.fromCached(
            ctx.getCachedRecord(
              (characters$raw as shalom_core.NormalizedObjectRecord)
                  .normalizedID(),
            ),
            ctx,
            variables,
          )
        : GetAnimeDetails_Media_characters.fromCached(
            characters$raw,
            ctx,
            variables,
          );
    return GetAnimeDetails_Media(
      streamingEpisodes: streamingEpisodes$value,

      format: format$value,

      episodes: episodes$value,

      description: description$value,

      coverImage: coverImage$value,

      id: id$value,

      title: title$value,

      characters: characters$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media &&
            const ListEquality().equals(
              streamingEpisodes,
              other.streamingEpisodes,
            ) &&
            format == other.format &&
            episodes == other.episodes &&
            description == other.description &&
            coverImage == other.coverImage &&
            id == other.id &&
            title == other.title &&
            characters == other.characters);
  }

  @override
  int get hashCode => Object.hashAll([
    streamingEpisodes,

    format,

    episodes,

    description,

    coverImage,

    id,

    title,

    characters,

    GetAnimeDetails_Media.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'streamingEpisodes': this.streamingEpisodes
          ?.map((e) => e?.toJson())
          .toList(),

      'format': this.format?.name,

      'episodes': this.episodes,

      'description': this.description,

      'coverImage': this.coverImage?.toJson(),

      'id': this.id,

      'title': this.title?.toJson(),

      'characters': this.characters?.toJson(),
    };
  }

  @experimental
  static GetAnimeDetails_Media fromJson(shalom_core.JsonObject data) {
    final List<GetAnimeDetails_Media_streamingEpisodes?>?
    streamingEpisodes$value = data['streamingEpisodes'] == null
        ? null
        : (data['streamingEpisodes'] as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GetAnimeDetails_Media_streamingEpisodes.fromJson(
                        e as shalom_core.JsonObject,
                      ),
              )
              .toList();
    final MediaFormat? format$value = data['format'] == null
        ? null
        : MediaFormat.fromString(data['format']);
    final int? episodes$value = data['episodes'] as int?;
    final String? description$value = data['description'] as String?;
    final MediaCard_coverImage? coverImage$value = data['coverImage'] == null
        ? null
        : MediaCard_coverImage.fromJson(
            data['coverImage'] as shalom_core.JsonObject,
          );
    final int id$value = data['id'] as int;
    final MediaCard_title? title$value = data['title'] == null
        ? null
        : MediaCard_title.fromJson(data['title'] as shalom_core.JsonObject);
    final GetAnimeDetails_Media_characters? characters$value =
        data['characters'] == null
        ? null
        : GetAnimeDetails_Media_characters.fromJson(
            data['characters'] as shalom_core.JsonObject,
          );
    return GetAnimeDetails_Media(
      streamingEpisodes: streamingEpisodes$value,

      format: format$value,

      episodes: episodes$value,

      description: description$value,

      coverImage: coverImage$value,

      id: id$value,

      title: title$value,

      characters: characters$value,
    );
  }
}

class GetAnimeDetails_Media_characters {
  static String G__typename = "CharacterConnection";

  /// class members
  final List<GetAnimeDetails_Media_characters_nodes?>? nodes;

  final GetAnimeDetails_Media_characters_pageInfo? pageInfo;

  // keywordargs constructor
  GetAnimeDetails_Media_characters({this.nodes, this.pageInfo});

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "CharacterConnection",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final nodesNormalized$Key = "nodes";
    final nodes$normalizedID = "${this$normalizedID}.${nodesNormalized$Key}";
    final pageInfoNormalized$Key = "pageInfo";
    final pageInfo$normalizedID =
        "${this$normalizedID}.${pageInfoNormalized$Key}";
    ctx.addDependantRecords({nodes$normalizedID, pageInfo$normalizedID});
    final nodes$cached = this$NormalizedRecord[nodesNormalized$Key];
    final nodes$raw = data["nodes"];
    if (nodes$raw != null) {
      final nodes$rawList = nodes$raw as List<dynamic>;
      final nodes$cachedList = nodes$cached as List<dynamic>?;

      if (nodes$cachedList == null ||
          nodes$cachedList.length != nodes$rawList.length) {
        ctx.addChangedRecord(nodes$normalizedID);
      }

      final nodes$normalizedList = <dynamic>[];

      for (int i = 0; i < nodes$rawList.length; i++) {
        final item$raw = nodes$rawList[i];
        final item$cached = nodes$cachedList?.elementAtOrNull(i);
        final item$normalizedKey = "nodes$i";

        if (item$raw != null) {
          if (item$cached == null) {
            ctx.addChangedRecord(nodes$normalizedID);
          }

          GetAnimeDetails_Media_characters_nodes.normalize$inCache(
            item$raw as shalom_core.JsonObject,
            ctx,
            variables,
            this$cached: item$cached is shalom_core.NormalizedObjectRecord
                ? ctx.shalomContext.getCachedRecord(item$cached.normalizedID())
                : item$cached,
            this$fieldName: item$normalizedKey,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID,
          );

          final nodes$item$id =
              (item$raw as shalom_core.JsonObject)["id"]
                  as shalom_core.RecordID?;
          if (nodes$item$id != null) {
            final nodes$item$normalized = shalom_core.NormalizedObjectRecord(
              typename: "Character",
              id: nodes$item$id,
            );
            this$NormalizedRecord[item$normalizedKey] = nodes$item$normalized;

            if (item$cached != null &&
                item$cached is shalom_core.NormalizedObjectRecord &&
                item$cached != nodes$item$normalized) {
              ctx.addChangedRecord(nodes$normalizedID);
            }
          } else {
            this$NormalizedRecord[item$normalizedKey] = shalom_core
                .getOrCreateObject(this$NormalizedRecord, item$normalizedKey);
          }
        } else {
          if (item$cached != null) {
            ctx.addChangedRecord(nodes$normalizedID);
          }
          this$NormalizedRecord[item$normalizedKey] = null;
        }

        nodes$normalizedList.add(this$NormalizedRecord[item$normalizedKey]);
      }

      this$NormalizedRecord[nodesNormalized$Key] = nodes$normalizedList;
    } else if (data.containsKey("nodes") && nodes$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[nodesNormalized$Key] = null;
      ctx.addChangedRecord(nodes$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[nodesNormalized$Key] = null;
    }
    final pageInfo$cached = this$NormalizedRecord[pageInfoNormalized$Key];
    final pageInfo$raw = data["pageInfo"];
    if (pageInfo$raw != null) {
      if (pageInfo$cached == null) {
        ctx.addChangedRecord(pageInfo$normalizedID);
      }

      GetAnimeDetails_Media_characters_pageInfo.normalize$inCache(
        pageInfo$raw as shalom_core.JsonObject,
        ctx,
        variables,
        this$cached: pageInfo$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(pageInfo$cached.normalizedID())
            : pageInfo$cached,
        this$fieldName: pageInfoNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final pageInfo$id =
          (pageInfo$raw as shalom_core.JsonObject)["id"]
              as shalom_core.RecordID?;
      if (pageInfo$id != null) {
        final pageInfo$normalized = shalom_core.NormalizedObjectRecord(
          typename: "PageInfo",
          id: pageInfo$id,
        );
        this$NormalizedRecord[pageInfoNormalized$Key] = pageInfo$normalized;

        if (pageInfo$cached != null &&
            pageInfo$cached is shalom_core.NormalizedObjectRecord &&
            pageInfo$cached != pageInfo$normalized) {
          ctx.addChangedRecord(pageInfo$normalizedID);
        }
      } else {
        this$NormalizedRecord[pageInfoNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, pageInfoNormalized$Key);
      }
    } else if (data.containsKey("pageInfo") && pageInfo$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[pageInfoNormalized$Key] = null;
      ctx.addChangedRecord(pageInfo$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[pageInfoNormalized$Key] = null;
    }
  }

  static GetAnimeDetails_Media_characters fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final nodes$raw = data["nodes"];
    final List<GetAnimeDetails_Media_characters_nodes?>? nodes$value =
        nodes$raw == null
        ? null
        : (nodes$raw as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : (e is shalom_core.NormalizedObjectRecord)
                    ? GetAnimeDetails_Media_characters_nodes.fromCached(
                        ctx.getCachedRecord(
                          (e as shalom_core.NormalizedObjectRecord)
                              .normalizedID(),
                        ),
                        ctx,
                        variables,
                      )
                    : GetAnimeDetails_Media_characters_nodes.fromCached(
                        e,
                        ctx,
                        variables,
                      ),
              )
              .toList();
    final pageInfo$raw = data["pageInfo"];
    final GetAnimeDetails_Media_characters_pageInfo? pageInfo$value =
        pageInfo$raw == null
        ? null
        : (pageInfo$raw is shalom_core.NormalizedObjectRecord)
        ? GetAnimeDetails_Media_characters_pageInfo.fromCached(
            ctx.getCachedRecord(
              (pageInfo$raw as shalom_core.NormalizedObjectRecord)
                  .normalizedID(),
            ),
            ctx,
            variables,
          )
        : GetAnimeDetails_Media_characters_pageInfo.fromCached(
            pageInfo$raw,
            ctx,
            variables,
          );
    return GetAnimeDetails_Media_characters(
      nodes: nodes$value,

      pageInfo: pageInfo$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_characters &&
            const ListEquality().equals(nodes, other.nodes) &&
            pageInfo == other.pageInfo);
  }

  @override
  int get hashCode => Object.hashAll([
    nodes,

    pageInfo,

    GetAnimeDetails_Media_characters.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'nodes': this.nodes?.map((e) => e?.toJson()).toList(),

      'pageInfo': this.pageInfo?.toJson(),
    };
  }

  @experimental
  static GetAnimeDetails_Media_characters fromJson(
    shalom_core.JsonObject data,
  ) {
    final List<GetAnimeDetails_Media_characters_nodes?>? nodes$value =
        data['nodes'] == null
        ? null
        : (data['nodes'] as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GetAnimeDetails_Media_characters_nodes.fromJson(
                        e as shalom_core.JsonObject,
                      ),
              )
              .toList();
    final GetAnimeDetails_Media_characters_pageInfo? pageInfo$value =
        data['pageInfo'] == null
        ? null
        : GetAnimeDetails_Media_characters_pageInfo.fromJson(
            data['pageInfo'] as shalom_core.JsonObject,
          );
    return GetAnimeDetails_Media_characters(
      nodes: nodes$value,

      pageInfo: pageInfo$value,
    );
  }
}

class GetAnimeDetails_Media_characters_nodes implements CharacterCard {
  static String G__typename = "Character";

  /// class members
  final CharacterCard_name? name;

  final CharacterCard_image? image;

  final int id;

  // keywordargs constructor
  GetAnimeDetails_Media_characters_nodes({
    this.name,

    this.image,

    required this.id,
  });

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "Character",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final nameNormalized$Key = "name";
    final name$normalizedID = "${this$normalizedID}.${nameNormalized$Key}";
    final imageNormalized$Key = "image";
    final image$normalizedID = "${this$normalizedID}.${imageNormalized$Key}";
    final idNormalized$Key = "id";
    final id$normalizedID = "${this$normalizedID}.${idNormalized$Key}";
    ctx.addDependantRecords({
      name$normalizedID,
      image$normalizedID,
      id$normalizedID,
    });
    final name$cached = this$NormalizedRecord[nameNormalized$Key];
    final name$raw = data["name"];
    if (name$raw != null) {
      if (name$cached == null) {
        ctx.addChangedRecord(name$normalizedID);
      }

      CharacterCard_name.normalize$inCache(
        name$raw as shalom_core.JsonObject,
        ctx,

        this$cached: name$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(name$cached.normalizedID())
            : name$cached,
        this$fieldName: nameNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final name$id =
          (name$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
      if (name$id != null) {
        final name$normalized = shalom_core.NormalizedObjectRecord(
          typename: "CharacterName",
          id: name$id,
        );
        this$NormalizedRecord[nameNormalized$Key] = name$normalized;

        if (name$cached != null &&
            name$cached is shalom_core.NormalizedObjectRecord &&
            name$cached != name$normalized) {
          ctx.addChangedRecord(name$normalizedID);
        }
      } else {
        this$NormalizedRecord[nameNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, nameNormalized$Key);
      }
    } else if (data.containsKey("name") && name$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[nameNormalized$Key] = null;
      ctx.addChangedRecord(name$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[nameNormalized$Key] = null;
    }
    final image$cached = this$NormalizedRecord[imageNormalized$Key];
    final image$raw = data["image"];
    if (image$raw != null) {
      if (image$cached == null) {
        ctx.addChangedRecord(image$normalizedID);
      }

      CharacterCard_image.normalize$inCache(
        image$raw as shalom_core.JsonObject,
        ctx,

        this$cached: image$cached is shalom_core.NormalizedObjectRecord
            ? ctx.shalomContext.getCachedRecord(image$cached.normalizedID())
            : image$cached,
        this$fieldName: imageNormalized$Key,
        parent$record: this$NormalizedRecord,
        parent$normalizedID: this$normalizedID,
      );

      final image$id =
          (image$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
      if (image$id != null) {
        final image$normalized = shalom_core.NormalizedObjectRecord(
          typename: "CharacterImage",
          id: image$id,
        );
        this$NormalizedRecord[imageNormalized$Key] = image$normalized;

        if (image$cached != null &&
            image$cached is shalom_core.NormalizedObjectRecord &&
            image$cached != image$normalized) {
          ctx.addChangedRecord(image$normalizedID);
        }
      } else {
        this$NormalizedRecord[imageNormalized$Key] = shalom_core
            .getOrCreateObject(this$NormalizedRecord, imageNormalized$Key);
      }
    } else if (data.containsKey("image") && image$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[imageNormalized$Key] = null;
      ctx.addChangedRecord(image$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[imageNormalized$Key] = null;
    }
    final id$cached = this$NormalizedRecord[idNormalized$Key];
    final id$raw = data["id"];
    if (id$raw != null) {
      if (id$cached != id$raw) {
        ctx.addChangedRecord(id$normalizedID);
      }
      this$NormalizedRecord[idNormalized$Key] = id$raw;
    } else if (data.containsKey("id") && id$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[idNormalized$Key] = null;
      ctx.addChangedRecord(id$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[idNormalized$Key] = null;
    }
  }

  static GetAnimeDetails_Media_characters_nodes fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final name$raw = data["name"];
    final CharacterCard_name? name$value = name$raw == null
        ? null
        : (name$raw is shalom_core.NormalizedObjectRecord)
        ? CharacterCard_name.fromCached(
            ctx.getCachedRecord(
              (name$raw as shalom_core.NormalizedObjectRecord).normalizedID(),
            ),
            ctx,
          )
        : CharacterCard_name.fromCached(name$raw, ctx);
    final image$raw = data["image"];
    final CharacterCard_image? image$value = image$raw == null
        ? null
        : (image$raw is shalom_core.NormalizedObjectRecord)
        ? CharacterCard_image.fromCached(
            ctx.getCachedRecord(
              (image$raw as shalom_core.NormalizedObjectRecord).normalizedID(),
            ),
            ctx,
          )
        : CharacterCard_image.fromCached(image$raw, ctx);
    final id$raw = data["id"];
    final int id$value = id$raw as int;
    return GetAnimeDetails_Media_characters_nodes(
      name: name$value,

      image: image$value,

      id: id$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_characters_nodes &&
            name == other.name &&
            image == other.image &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    name,

    image,

    id,

    GetAnimeDetails_Media_characters_nodes.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'name': this.name?.toJson(),

      'image': this.image?.toJson(),

      'id': this.id,
    };
  }

  @experimental
  static GetAnimeDetails_Media_characters_nodes fromJson(
    shalom_core.JsonObject data,
  ) {
    final CharacterCard_name? name$value = data['name'] == null
        ? null
        : CharacterCard_name.fromJson(data['name'] as shalom_core.JsonObject);
    final CharacterCard_image? image$value = data['image'] == null
        ? null
        : CharacterCard_image.fromJson(data['image'] as shalom_core.JsonObject);
    final int id$value = data['id'] as int;
    return GetAnimeDetails_Media_characters_nodes(
      name: name$value,

      image: image$value,

      id: id$value,
    );
  }
}

class GetAnimeDetails_Media_characters_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final int? currentPage;

  final bool? hasNextPage;

  // keywordargs constructor
  GetAnimeDetails_Media_characters_pageInfo({
    this.currentPage,

    this.hasNextPage,
  });

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "PageInfo",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final currentPageNormalized$Key = "currentPage";
    final currentPage$normalizedID =
        "${this$normalizedID}.${currentPageNormalized$Key}";
    final hasNextPageNormalized$Key = "hasNextPage";
    final hasNextPage$normalizedID =
        "${this$normalizedID}.${hasNextPageNormalized$Key}";
    ctx.addDependantRecords({
      currentPage$normalizedID,
      hasNextPage$normalizedID,
    });
    final currentPage$cached = this$NormalizedRecord[currentPageNormalized$Key];
    final currentPage$raw = data["currentPage"];
    if (currentPage$raw != null) {
      if (currentPage$cached != currentPage$raw) {
        ctx.addChangedRecord(currentPage$normalizedID);
      }
      this$NormalizedRecord[currentPageNormalized$Key] = currentPage$raw;
    } else if (data.containsKey("currentPage") && currentPage$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[currentPageNormalized$Key] = null;
      ctx.addChangedRecord(currentPage$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[currentPageNormalized$Key] = null;
    }
    final hasNextPage$cached = this$NormalizedRecord[hasNextPageNormalized$Key];
    final hasNextPage$raw = data["hasNextPage"];
    if (hasNextPage$raw != null) {
      if (hasNextPage$cached != hasNextPage$raw) {
        ctx.addChangedRecord(hasNextPage$normalizedID);
      }
      this$NormalizedRecord[hasNextPageNormalized$Key] = hasNextPage$raw;
    } else if (data.containsKey("hasNextPage") && hasNextPage$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[hasNextPageNormalized$Key] = null;
      ctx.addChangedRecord(hasNextPage$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[hasNextPageNormalized$Key] = null;
    }
  }

  static GetAnimeDetails_Media_characters_pageInfo fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final currentPage$raw = data["currentPage"];
    final int? currentPage$value = currentPage$raw as int?;
    final hasNextPage$raw = data["hasNextPage"];
    final bool? hasNextPage$value = hasNextPage$raw as bool?;
    return GetAnimeDetails_Media_characters_pageInfo(
      currentPage: currentPage$value,

      hasNextPage: hasNextPage$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_characters_pageInfo &&
            currentPage == other.currentPage &&
            hasNextPage == other.hasNextPage);
  }

  @override
  int get hashCode => Object.hashAll([
    currentPage,

    hasNextPage,

    GetAnimeDetails_Media_characters_pageInfo.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {'currentPage': this.currentPage, 'hasNextPage': this.hasNextPage};
  }

  @experimental
  static GetAnimeDetails_Media_characters_pageInfo fromJson(
    shalom_core.JsonObject data,
  ) {
    final int? currentPage$value = data['currentPage'] as int?;
    final bool? hasNextPage$value = data['hasNextPage'] as bool?;
    return GetAnimeDetails_Media_characters_pageInfo(
      currentPage: currentPage$value,

      hasNextPage: hasNextPage$value,
    );
  }
}

class GetAnimeDetails_Media_streamingEpisodes {
  static String G__typename = "MediaStreamingEpisode";

  /// class members
  final String? url;

  final String? thumbnail;

  final String? title;

  final String? site;

  // keywordargs constructor
  GetAnimeDetails_Media_streamingEpisodes({
    this.url,

    this.thumbnail,

    this.title,

    this.site,
  });

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx,
    GetAnimeDetailsVariables variables, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "MediaStreamingEpisode",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final urlNormalized$Key = "url";
    final url$normalizedID = "${this$normalizedID}.${urlNormalized$Key}";
    final thumbnailNormalized$Key = "thumbnail";
    final thumbnail$normalizedID =
        "${this$normalizedID}.${thumbnailNormalized$Key}";
    final titleNormalized$Key = "title";
    final title$normalizedID = "${this$normalizedID}.${titleNormalized$Key}";
    final siteNormalized$Key = "site";
    final site$normalizedID = "${this$normalizedID}.${siteNormalized$Key}";
    ctx.addDependantRecords({
      url$normalizedID,
      thumbnail$normalizedID,
      title$normalizedID,
      site$normalizedID,
    });
    final url$cached = this$NormalizedRecord[urlNormalized$Key];
    final url$raw = data["url"];
    if (url$raw != null) {
      if (url$cached != url$raw) {
        ctx.addChangedRecord(url$normalizedID);
      }
      this$NormalizedRecord[urlNormalized$Key] = url$raw;
    } else if (data.containsKey("url") && url$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[urlNormalized$Key] = null;
      ctx.addChangedRecord(url$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[urlNormalized$Key] = null;
    }
    final thumbnail$cached = this$NormalizedRecord[thumbnailNormalized$Key];
    final thumbnail$raw = data["thumbnail"];
    if (thumbnail$raw != null) {
      if (thumbnail$cached != thumbnail$raw) {
        ctx.addChangedRecord(thumbnail$normalizedID);
      }
      this$NormalizedRecord[thumbnailNormalized$Key] = thumbnail$raw;
    } else if (data.containsKey("thumbnail") && thumbnail$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[thumbnailNormalized$Key] = null;
      ctx.addChangedRecord(thumbnail$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[thumbnailNormalized$Key] = null;
    }
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
    final site$cached = this$NormalizedRecord[siteNormalized$Key];
    final site$raw = data["site"];
    if (site$raw != null) {
      if (site$cached != site$raw) {
        ctx.addChangedRecord(site$normalizedID);
      }
      this$NormalizedRecord[siteNormalized$Key] = site$raw;
    } else if (data.containsKey("site") && site$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[siteNormalized$Key] = null;
      ctx.addChangedRecord(site$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[siteNormalized$Key] = null;
    }
  }

  static GetAnimeDetails_Media_streamingEpisodes fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
    GetAnimeDetailsVariables variables,
  ) {
    final url$raw = data["url"];
    final String? url$value = url$raw as String?;
    final thumbnail$raw = data["thumbnail"];
    final String? thumbnail$value = thumbnail$raw as String?;
    final title$raw = data["title"];
    final String? title$value = title$raw as String?;
    final site$raw = data["site"];
    final String? site$value = site$raw as String?;
    return GetAnimeDetails_Media_streamingEpisodes(
      url: url$value,

      thumbnail: thumbnail$value,

      title: title$value,

      site: site$value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_streamingEpisodes &&
            url == other.url &&
            thumbnail == other.thumbnail &&
            title == other.title &&
            site == other.site);
  }

  @override
  int get hashCode => Object.hashAll([
    url,

    thumbnail,

    title,

    site,

    GetAnimeDetails_Media_streamingEpisodes.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'url': this.url,

      'thumbnail': this.thumbnail,

      'title': this.title,

      'site': this.site,
    };
  }

  @experimental
  static GetAnimeDetails_Media_streamingEpisodes fromJson(
    shalom_core.JsonObject data,
  ) {
    final String? url$value = data['url'] as String?;
    final String? thumbnail$value = data['thumbnail'] as String?;
    final String? title$value = data['title'] as String?;
    final String? site$value = data['site'] as String?;
    return GetAnimeDetails_Media_streamingEpisodes(
      url: url$value,

      thumbnail: thumbnail$value,

      title: title$value,

      site: site$value,
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

class RequestGetAnimeDetails
    extends shalom_core.Requestable<GetAnimeDetailsResponse> {
  final GetAnimeDetailsVariables variables;

  RequestGetAnimeDetails({required this.variables});
  @override
  shalom_core.RequestMeta<GetAnimeDetailsResponse> getRequestMeta() {
    shalom_core.JsonObject variablesJson = variables.toJson();
    final request = shalom_core.Request(
      query: r"""
            query GetAnimeDetails($id: Int!, $page: Int!, $perPage: Int!) {
  Media(id: $id, type: ANIME) {
    ...MediaCard
    description(asHtml: false)
    streamingEpisodes {
      title
      site
      url
      thumbnail
    }
    characters(page: $page, perPage: $perPage) {
      pageInfo {
        currentPage
        hasNextPage
      }
      nodes {
        ...CharacterCard
        id
      }
    }
    id
  }
}
 fragment CharacterCard on Character {
  id
  name {
    full
  }
  image {
    large
  }
}
 fragment MediaCard on Media {
  id
  title {
    romaji
    english
  }
  coverImage {
    large
  }
  episodes
  format
}
            """,
      variables: variablesJson,
      opType: shalom_core.OperationType.Query,
      opName: 'GetAnimeDetails',
    );
    return shalom_core.RequestMeta(
      request: request,
      loadFn:
          ({
            required shalom_core.JsonObject data,
            required shalom_core.ShalomCtx ctx,
          }) {
            final (deserialized, updatedCtx) =
                GetAnimeDetailsResponse.fromResponseImpl(data, ctx, variables);
            return (deserialized, updatedCtx.dependantRecords);
          },
      fromCacheFn: (shalom_core.ShalomCtx ctx) {
        final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
        final deserialized = GetAnimeDetailsResponse.fromCache(ctx, variables);
        return (deserialized, updateCtx.dependantRecords);
      },
    );
  }
}

class GetAnimeDetailsVariables {
  final int id;

  final int page;

  final int perPage;

  GetAnimeDetailsVariables({
    required this.id,

    required this.page,

    required this.perPage,
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;
    data["page"] = this.page;
    data["perPage"] = this.perPage;

    return data;
  }

  GetAnimeDetailsVariables updateWith({int? id, int? page, int? perPage}) {
    final id$next = id ?? this.id;

    final page$next = page ?? this.page;

    final perPage$next = perPage ?? this.perPage;

    return GetAnimeDetailsVariables(
      id: id$next,

      page: page$next,

      perPage: perPage$next,
    );
  }
}
