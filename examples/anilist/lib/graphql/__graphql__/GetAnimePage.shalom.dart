// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'MediaCard.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------
class GetAnimePageData implements shalom_core.OperationInterface {
  static String G__typename = "query";

  /// class members
  final GetAnimePage_Page? Page;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimePageData({this.Page});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimePageData && Page == other.Page);
  }

  @override
  int get hashCode => Object.hashAll([Page, GetAnimePageData.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'Page': this.Page?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'Page': this.Page == null
        ? shalom_core.shalomJsonValue(null)
        : this.Page!.toShalomValue(),
  });

  static GetAnimePageData fromJson(shalom_core.JsonObject data) {
    final GetAnimePage_Page? Page$value = data['Page'] == null
        ? null
        : GetAnimePage_Page.fromJson(data['Page'] as shalom_core.JsonObject);
    return GetAnimePageData(Page: Page$value);
  }

  static GetAnimePageData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? Page$raw = data.field('Page');
    final GetAnimePage_Page? Page$value = Page$raw == null || Page$raw!.isNull
        ? null
        : GetAnimePage_Page.fromShalomValue(Page$raw!);
    return GetAnimePageData(Page: Page$value);
  }

  @override
  String operation$Name() => 'GetAnimePage';
}

class GetAnimePage_Page {
  static String G__typename = "Page";

  /// class members
  final List<GetAnimePage_Page_media?>? media;

  final GetAnimePage_Page_pageInfo? pageInfo;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimePage_Page({this.media, this.pageInfo});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimePage_Page &&
            const ListEquality().equals(media, other.media) &&
            pageInfo == other.pageInfo);
  }

  @override
  int get hashCode =>
      Object.hashAll([media, pageInfo, GetAnimePage_Page.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'media': this.media?.map((e) => e?.toJson()).toList(),

      'pageInfo': this.pageInfo?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'media': this.media == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonArray(
            this.media!.map(
              (e) => e == null
                  ? shalom_core.shalomJsonValue(null)
                  : e!.toShalomValue(),
            ),
          ),

    'pageInfo': this.pageInfo == null
        ? shalom_core.shalomJsonValue(null)
        : this.pageInfo!.toShalomValue(),
  });

  static GetAnimePage_Page fromJson(shalom_core.JsonObject data) {
    final List<GetAnimePage_Page_media?>? media$value = data['media'] == null
        ? null
        : (data['media'] as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GetAnimePage_Page_media.fromJson(
                        e as shalom_core.JsonObject,
                      ),
              )
              .toList();
    final GetAnimePage_Page_pageInfo? pageInfo$value = data['pageInfo'] == null
        ? null
        : GetAnimePage_Page_pageInfo.fromJson(
            data['pageInfo'] as shalom_core.JsonObject,
          );
    return GetAnimePage_Page(media: media$value, pageInfo: pageInfo$value);
  }

  static GetAnimePage_Page fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? media$raw = data.field('media');
    final List<GetAnimePage_Page_media?>? media$value =
        media$raw == null || media$raw!.isNull
        ? null
        : media$raw!.listValue
              .map(
                (e) => e.isNull
                    ? null
                    : GetAnimePage_Page_media.fromShalomValue(e!),
              )
              .toList();
    final shalom_core.ShalomJsonValue? pageInfo$raw = data.field('pageInfo');
    final GetAnimePage_Page_pageInfo? pageInfo$value =
        pageInfo$raw == null || pageInfo$raw!.isNull
        ? null
        : GetAnimePage_Page_pageInfo.fromShalomValue(pageInfo$raw!);
    return GetAnimePage_Page(media: media$value, pageInfo: pageInfo$value);
  }
}

class GetAnimePage_Page_media implements MediaCard {
  static String G__typename = "Media";

  /// class members
  final MediaCard_coverImage? coverImage;

  final int? episodes;

  final MediaFormat? format;

  final int id;

  final MediaCard_title? title;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimePage_Page_media({
    this.coverImage,

    this.episodes,

    this.format,

    required this.id,

    this.title,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimePage_Page_media &&
            coverImage == other.coverImage &&
            episodes == other.episodes &&
            format == other.format &&
            id == other.id &&
            title == other.title);
  }

  @override
  int get hashCode => Object.hashAll([
    coverImage,

    episodes,

    format,

    id,

    title,

    GetAnimePage_Page_media.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'coverImage': this.coverImage?.toJson(),

      'episodes': this.episodes,

      'format': this.format?.name,

      'id': this.id,

      'title': this.title?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'coverImage': this.coverImage == null
        ? shalom_core.shalomJsonValue(null)
        : this.coverImage!.toShalomValue(),

    'episodes': this.episodes == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.episodes!),

    'format': this.format == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.format!.name),

    'id': shalom_core.shalomJsonValue(this.id!),

    'title': this.title == null
        ? shalom_core.shalomJsonValue(null)
        : this.title!.toShalomValue(),
  });

  static GetAnimePage_Page_media fromJson(shalom_core.JsonObject data) {
    final MediaCard_coverImage? coverImage$value = data['coverImage'] == null
        ? null
        : MediaCard_coverImage.fromJson(
            data['coverImage'] as shalom_core.JsonObject,
          );
    final int? episodes$value = data['episodes'] as int?;
    final MediaFormat? format$value = data['format'] == null
        ? null
        : MediaFormat.fromString(data['format']);
    final int id$value = data['id'] as int;
    final MediaCard_title? title$value = data['title'] == null
        ? null
        : MediaCard_title.fromJson(data['title'] as shalom_core.JsonObject);
    return GetAnimePage_Page_media(
      coverImage: coverImage$value,

      episodes: episodes$value,

      format: format$value,

      id: id$value,

      title: title$value,
    );
  }

  static GetAnimePage_Page_media fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? coverImage$raw = data.field(
      'coverImage',
    );
    final MediaCard_coverImage? coverImage$value =
        coverImage$raw == null || coverImage$raw!.isNull
        ? null
        : MediaCard_coverImage.fromShalomValue(coverImage$raw!);
    final shalom_core.ShalomJsonValue? episodes$raw = data.field('episodes');
    final int? episodes$value = episodes$raw == null || episodes$raw!.isNull
        ? null
        : episodes$raw!.intValue;
    final shalom_core.ShalomJsonValue? format$raw = data.field('format');
    final MediaFormat? format$value = format$raw == null || format$raw!.isNull
        ? null
        : MediaFormat.fromString(format$raw!.stringValue);
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final int id$value = id$raw!.intValue;
    final shalom_core.ShalomJsonValue? title$raw = data.field('title');
    final MediaCard_title? title$value = title$raw == null || title$raw!.isNull
        ? null
        : MediaCard_title.fromShalomValue(title$raw!);
    return GetAnimePage_Page_media(
      coverImage: coverImage$value,
      episodes: episodes$value,
      format: format$value,
      id: id$value,
      title: title$value,
    );
  }
}

class GetAnimePage_Page_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final int? currentPage;

  final bool? hasNextPage;

  final int? lastPage;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimePage_Page_pageInfo({
    this.currentPage,

    this.hasNextPage,

    this.lastPage,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimePage_Page_pageInfo &&
            currentPage == other.currentPage &&
            hasNextPage == other.hasNextPage &&
            lastPage == other.lastPage);
  }

  @override
  int get hashCode => Object.hashAll([
    currentPage,

    hasNextPage,

    lastPage,

    GetAnimePage_Page_pageInfo.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'currentPage': this.currentPage,

      'hasNextPage': this.hasNextPage,

      'lastPage': this.lastPage,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'currentPage': this.currentPage == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.currentPage!),

    'hasNextPage': this.hasNextPage == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.hasNextPage!),

    'lastPage': this.lastPage == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.lastPage!),
  });

  static GetAnimePage_Page_pageInfo fromJson(shalom_core.JsonObject data) {
    final int? currentPage$value = data['currentPage'] as int?;
    final bool? hasNextPage$value = data['hasNextPage'] as bool?;
    final int? lastPage$value = data['lastPage'] as int?;
    return GetAnimePage_Page_pageInfo(
      currentPage: currentPage$value,

      hasNextPage: hasNextPage$value,

      lastPage: lastPage$value,
    );
  }

  static GetAnimePage_Page_pageInfo fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? currentPage$raw = data.field(
      'currentPage',
    );
    final int? currentPage$value =
        currentPage$raw == null || currentPage$raw!.isNull
        ? null
        : currentPage$raw!.intValue;
    final shalom_core.ShalomJsonValue? hasNextPage$raw = data.field(
      'hasNextPage',
    );
    final bool? hasNextPage$value =
        hasNextPage$raw == null || hasNextPage$raw!.isNull
        ? null
        : hasNextPage$raw!.boolValue;
    final shalom_core.ShalomJsonValue? lastPage$raw = data.field('lastPage');
    final int? lastPage$value = lastPage$raw == null || lastPage$raw!.isNull
        ? null
        : lastPage$raw!.intValue;
    return GetAnimePage_Page_pageInfo(
      currentPage: currentPage$value,
      hasNextPage: hasNextPage$value,
      lastPage: lastPage$value,
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

class RequestGetAnimePage extends shalom_core.Requestable<GetAnimePageData> {
  final GetAnimePageVariables variables;

  RequestGetAnimePage({required this.variables});
  @override
  shalom_core.RequestMeta<GetAnimePageData> getRequestMeta() {
    shalom_core.JsonObject variablesJson = variables.toJson();
    final request = shalom_core.Request(
      query: r"""
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
query GetAnimePage($page: Int!, $perPage: Int!) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      currentPage
      hasNextPage
      lastPage
    }
    media(type: ANIME, sort: POPULARITY_DESC) {
      ...MediaCard
      id
    }
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
      opName: 'GetAnimePage',
    );
    return shalom_core.RequestMeta(
      request: request,
      parseFn: (shalom_core.JsonObject data) => GetAnimePageData.fromJson(data),
    );
  }
}

class GetAnimePageVariables {
  final int page;

  final int perPage;

  GetAnimePageVariables({required this.page, required this.perPage});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["page"] = this.page;
    data["perPage"] = this.perPage;

    return data;
  }

  GetAnimePageVariables updateWith({int? page, int? perPage}) {
    final page$next = page ?? this.page;

    final perPage$next = perPage ?? this.perPage;

    return GetAnimePageVariables(page: page$next, perPage: perPage$next);
  }
}
