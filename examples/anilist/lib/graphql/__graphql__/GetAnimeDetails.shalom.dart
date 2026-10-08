// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import 'CharacterCard.shalom.dart';
import 'MediaCard.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------
class GetAnimeDetailsData implements shalom_core.OperationInterface {
  static String G__typename = "query";

  /// class members
  final GetAnimeDetails_Media? Media;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetailsData({this.Media});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetailsData && Media == other.Media);
  }

  @override
  int get hashCode => Object.hashAll([Media, GetAnimeDetailsData.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'Media': this.Media?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'Media': this.Media == null
        ? shalom_core.shalomJsonValue(null)
        : this.Media!.toShalomValue(),
  });

  static GetAnimeDetailsData fromJson(shalom_core.JsonObject data) {
    final GetAnimeDetails_Media? Media$value = data['Media'] == null
        ? null
        : GetAnimeDetails_Media.fromJson(
            data['Media'] as shalom_core.JsonObject,
          );
    return GetAnimeDetailsData(Media: Media$value);
  }

  static GetAnimeDetailsData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? Media$raw = data.field('Media');
    final GetAnimeDetails_Media? Media$value =
        Media$raw == null || Media$raw!.isNull
        ? null
        : GetAnimeDetails_Media.fromShalomValue(Media$raw!);
    return GetAnimeDetailsData(Media: Media$value);
  }

  @override
  String operation$Name() => 'GetAnimeDetails';
}

class GetAnimeDetails_Media implements MediaCard {
  static String G__typename = "Media";

  /// class members
  final GetAnimeDetails_Media_characters? characters;

  final MediaCard_coverImage? coverImage;

  final String? description;

  final int? episodes;

  final MediaFormat? format;

  final int id;

  final List<GetAnimeDetails_Media_streamingEpisodes?>? streamingEpisodes;

  final MediaCard_title? title;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetails_Media({
    this.characters,

    this.coverImage,

    this.description,

    this.episodes,

    this.format,

    required this.id,

    this.streamingEpisodes,

    this.title,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media &&
            characters == other.characters &&
            coverImage == other.coverImage &&
            description == other.description &&
            episodes == other.episodes &&
            format == other.format &&
            id == other.id &&
            const ListEquality().equals(
              streamingEpisodes,
              other.streamingEpisodes,
            ) &&
            title == other.title);
  }

  @override
  int get hashCode => Object.hashAll([
    characters,

    coverImage,

    description,

    episodes,

    format,

    id,

    streamingEpisodes,

    title,

    GetAnimeDetails_Media.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'characters': this.characters?.toJson(),

      'coverImage': this.coverImage?.toJson(),

      'description': this.description,

      'episodes': this.episodes,

      'format': this.format?.name,

      'id': this.id,

      'streamingEpisodes': this.streamingEpisodes
          ?.map((e) => e?.toJson())
          .toList(),

      'title': this.title?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'characters': this.characters == null
        ? shalom_core.shalomJsonValue(null)
        : this.characters!.toShalomValue(),

    'coverImage': this.coverImage == null
        ? shalom_core.shalomJsonValue(null)
        : this.coverImage!.toShalomValue(),

    'description': this.description == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.description!),

    'episodes': this.episodes == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.episodes!),

    'format': this.format == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.format!.name),

    'id': shalom_core.shalomJsonValue(this.id!),

    'streamingEpisodes': this.streamingEpisodes == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonArray(
            this.streamingEpisodes!.map(
              (e) => e == null
                  ? shalom_core.shalomJsonValue(null)
                  : e!.toShalomValue(),
            ),
          ),

    'title': this.title == null
        ? shalom_core.shalomJsonValue(null)
        : this.title!.toShalomValue(),
  });

  static GetAnimeDetails_Media fromJson(shalom_core.JsonObject data) {
    final GetAnimeDetails_Media_characters? characters$value =
        data['characters'] == null
        ? null
        : GetAnimeDetails_Media_characters.fromJson(
            data['characters'] as shalom_core.JsonObject,
          );
    final MediaCard_coverImage? coverImage$value = data['coverImage'] == null
        ? null
        : MediaCard_coverImage.fromJson(
            data['coverImage'] as shalom_core.JsonObject,
          );
    final String? description$value = data['description'] as String?;
    final int? episodes$value = data['episodes'] as int?;
    final MediaFormat? format$value = data['format'] == null
        ? null
        : MediaFormat.fromString(data['format']);
    final int id$value = data['id'] as int;
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
    final MediaCard_title? title$value = data['title'] == null
        ? null
        : MediaCard_title.fromJson(data['title'] as shalom_core.JsonObject);
    return GetAnimeDetails_Media(
      characters: characters$value,

      coverImage: coverImage$value,

      description: description$value,

      episodes: episodes$value,

      format: format$value,

      id: id$value,

      streamingEpisodes: streamingEpisodes$value,

      title: title$value,
    );
  }

  static GetAnimeDetails_Media fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? characters$raw = data.field(
      'characters',
    );
    final GetAnimeDetails_Media_characters? characters$value =
        characters$raw == null || characters$raw!.isNull
        ? null
        : GetAnimeDetails_Media_characters.fromShalomValue(characters$raw!);
    final shalom_core.ShalomJsonValue? coverImage$raw = data.field(
      'coverImage',
    );
    final MediaCard_coverImage? coverImage$value =
        coverImage$raw == null || coverImage$raw!.isNull
        ? null
        : MediaCard_coverImage.fromShalomValue(coverImage$raw!);
    final shalom_core.ShalomJsonValue? description$raw = data.field(
      'description',
    );
    final String? description$value =
        description$raw == null || description$raw!.isNull
        ? null
        : description$raw!.stringValue;
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
    final shalom_core.ShalomJsonValue? streamingEpisodes$raw = data.field(
      'streamingEpisodes',
    );
    final List<GetAnimeDetails_Media_streamingEpisodes?>?
    streamingEpisodes$value =
        streamingEpisodes$raw == null || streamingEpisodes$raw!.isNull
        ? null
        : streamingEpisodes$raw!.listValue
              .map(
                (e) => e.isNull
                    ? null
                    : GetAnimeDetails_Media_streamingEpisodes.fromShalomValue(
                        e!,
                      ),
              )
              .toList();
    final shalom_core.ShalomJsonValue? title$raw = data.field('title');
    final MediaCard_title? title$value = title$raw == null || title$raw!.isNull
        ? null
        : MediaCard_title.fromShalomValue(title$raw!);
    return GetAnimeDetails_Media(
      characters: characters$value,
      coverImage: coverImage$value,
      description: description$value,
      episodes: episodes$value,
      format: format$value,
      id: id$value,
      streamingEpisodes: streamingEpisodes$value,
      title: title$value,
    );
  }
}

class GetAnimeDetails_Media_characters {
  static String G__typename = "CharacterConnection";

  /// class members
  final List<GetAnimeDetails_Media_characters_nodes?>? nodes;

  final GetAnimeDetails_Media_characters_pageInfo? pageInfo;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetails_Media_characters({this.nodes, this.pageInfo});

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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'nodes': this.nodes == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonArray(
            this.nodes!.map(
              (e) => e == null
                  ? shalom_core.shalomJsonValue(null)
                  : e!.toShalomValue(),
            ),
          ),

    'pageInfo': this.pageInfo == null
        ? shalom_core.shalomJsonValue(null)
        : this.pageInfo!.toShalomValue(),
  });

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

  static GetAnimeDetails_Media_characters fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? nodes$raw = data.field('nodes');
    final List<GetAnimeDetails_Media_characters_nodes?>? nodes$value =
        nodes$raw == null || nodes$raw!.isNull
        ? null
        : nodes$raw!.listValue
              .map(
                (e) => e.isNull
                    ? null
                    : GetAnimeDetails_Media_characters_nodes.fromShalomValue(
                        e!,
                      ),
              )
              .toList();
    final shalom_core.ShalomJsonValue? pageInfo$raw = data.field('pageInfo');
    final GetAnimeDetails_Media_characters_pageInfo? pageInfo$value =
        pageInfo$raw == null || pageInfo$raw!.isNull
        ? null
        : GetAnimeDetails_Media_characters_pageInfo.fromShalomValue(
            pageInfo$raw!,
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
  final int id;

  final CharacterCard_image? image;

  final CharacterCard_name? name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetails_Media_characters_nodes({
    required this.id,

    this.image,

    this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_characters_nodes &&
            id == other.id &&
            image == other.image &&
            name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    image,

    name,

    GetAnimeDetails_Media_characters_nodes.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'image': this.image?.toJson(),

      'name': this.name?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'id': shalom_core.shalomJsonValue(this.id!),

    'image': this.image == null
        ? shalom_core.shalomJsonValue(null)
        : this.image!.toShalomValue(),

    'name': this.name == null
        ? shalom_core.shalomJsonValue(null)
        : this.name!.toShalomValue(),
  });

  static GetAnimeDetails_Media_characters_nodes fromJson(
    shalom_core.JsonObject data,
  ) {
    final int id$value = data['id'] as int;
    final CharacterCard_image? image$value = data['image'] == null
        ? null
        : CharacterCard_image.fromJson(data['image'] as shalom_core.JsonObject);
    final CharacterCard_name? name$value = data['name'] == null
        ? null
        : CharacterCard_name.fromJson(data['name'] as shalom_core.JsonObject);
    return GetAnimeDetails_Media_characters_nodes(
      id: id$value,

      image: image$value,

      name: name$value,
    );
  }

  static GetAnimeDetails_Media_characters_nodes fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final int id$value = id$raw!.intValue;
    final shalom_core.ShalomJsonValue? image$raw = data.field('image');
    final CharacterCard_image? image$value =
        image$raw == null || image$raw!.isNull
        ? null
        : CharacterCard_image.fromShalomValue(image$raw!);
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final CharacterCard_name? name$value = name$raw == null || name$raw!.isNull
        ? null
        : CharacterCard_name.fromShalomValue(name$raw!);
    return GetAnimeDetails_Media_characters_nodes(
      id: id$value,
      image: image$value,
      name: name$value,
    );
  }
}

class GetAnimeDetails_Media_characters_pageInfo {
  static String G__typename = "PageInfo";

  /// class members
  final int? currentPage;

  final bool? hasNextPage;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetails_Media_characters_pageInfo({
    this.currentPage,

    this.hasNextPage,
  });

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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'currentPage': this.currentPage == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.currentPage!),

    'hasNextPage': this.hasNextPage == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.hasNextPage!),
  });

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

  static GetAnimeDetails_Media_characters_pageInfo fromShalomValue(
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
    return GetAnimeDetails_Media_characters_pageInfo(
      currentPage: currentPage$value,
      hasNextPage: hasNextPage$value,
    );
  }
}

class GetAnimeDetails_Media_streamingEpisodes {
  static String G__typename = "MediaStreamingEpisode";

  /// class members
  final String? site;

  final String? thumbnail;

  final String? title;

  final String? url;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  GetAnimeDetails_Media_streamingEpisodes({
    this.site,

    this.thumbnail,

    this.title,

    this.url,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetAnimeDetails_Media_streamingEpisodes &&
            site == other.site &&
            thumbnail == other.thumbnail &&
            title == other.title &&
            url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([
    site,

    thumbnail,

    title,

    url,

    GetAnimeDetails_Media_streamingEpisodes.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'site': this.site,

      'thumbnail': this.thumbnail,

      'title': this.title,

      'url': this.url,
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'site': this.site == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.site!),

    'thumbnail': this.thumbnail == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.thumbnail!),

    'title': this.title == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.title!),

    'url': this.url == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.url!),
  });

  static GetAnimeDetails_Media_streamingEpisodes fromJson(
    shalom_core.JsonObject data,
  ) {
    final String? site$value = data['site'] as String?;
    final String? thumbnail$value = data['thumbnail'] as String?;
    final String? title$value = data['title'] as String?;
    final String? url$value = data['url'] as String?;
    return GetAnimeDetails_Media_streamingEpisodes(
      site: site$value,

      thumbnail: thumbnail$value,

      title: title$value,

      url: url$value,
    );
  }

  static GetAnimeDetails_Media_streamingEpisodes fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? site$raw = data.field('site');
    final String? site$value = site$raw == null || site$raw!.isNull
        ? null
        : site$raw!.stringValue;
    final shalom_core.ShalomJsonValue? thumbnail$raw = data.field('thumbnail');
    final String? thumbnail$value =
        thumbnail$raw == null || thumbnail$raw!.isNull
        ? null
        : thumbnail$raw!.stringValue;
    final shalom_core.ShalomJsonValue? title$raw = data.field('title');
    final String? title$value = title$raw == null || title$raw!.isNull
        ? null
        : title$raw!.stringValue;
    final shalom_core.ShalomJsonValue? url$raw = data.field('url');
    final String? url$value = url$raw == null || url$raw!.isNull
        ? null
        : url$raw!.stringValue;
    return GetAnimeDetails_Media_streamingEpisodes(
      site: site$value,
      thumbnail: thumbnail$value,
      title: title$value,
      url: url$value,
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
    extends shalom_core.Requestable<GetAnimeDetailsData> {
  final GetAnimeDetailsVariables variables;

  RequestGetAnimeDetails({required this.variables});
  @override
  shalom_core.RequestMeta<GetAnimeDetailsData> getRequestMeta() {
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
 fragment CharacterCard on Character {
  id
  name {
    full
  }
  image {
    large
  }
}
            """,
      variables: variablesJson,
      opType: shalom_core.OperationType.Query,
      opName: 'GetAnimeDetails',
    );
    return shalom_core.RequestMeta(
      request: request,
      parseFn: (shalom_core.JsonObject data) =>
          GetAnimeDetailsData.fromJson(data),
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
