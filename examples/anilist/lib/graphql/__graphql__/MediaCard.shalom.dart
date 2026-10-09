// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: MediaCard

import "../../schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Generate abstract fragment class
abstract class MediaCard {
  MediaCard_coverImage? get coverImage;
  int? get episodes;
  MediaFormat? get format;
  int get id;
  MediaCard_title? get title;

  Map<String, dynamic> toJson();
  shalom_core.ShalomJsonValue toShalomValue();
}

class MediaCardImpl implements MediaCard {
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
  MediaCardImpl({
    this.coverImage,

    this.episodes,

    this.format,

    required this.id,

    this.title,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MediaCardImpl &&
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

    MediaCardImpl.G__typename,
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

  static MediaCardImpl fromJson(shalom_core.JsonObject data) {
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
    return MediaCardImpl(
      coverImage: coverImage$value,

      episodes: episodes$value,

      format: format$value,

      id: id$value,

      title: title$value,
    );
  }

  static MediaCardImpl fromShalomValue(shalom_core.ShalomJsonValue data) {
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
    return MediaCardImpl(
      coverImage: coverImage$value,
      episodes: episodes$value,
      format: format$value,
      id: id$value,
      title: title$value,
    );
  }
}

// ------------ START OBJECT DEFINITIONS -------------
class MediaCard_coverImage {
  static String G__typename = "MediaCoverImage";

  /// class members
  final String? large;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  MediaCard_coverImage({this.large});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MediaCard_coverImage && large == other.large);
  }

  @override
  int get hashCode => Object.hashAll([large, MediaCard_coverImage.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'large': this.large};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'large': this.large == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.large!),
  });

  static MediaCard_coverImage fromJson(shalom_core.JsonObject data) {
    final String? large$value = data['large'] as String?;
    return MediaCard_coverImage(large: large$value);
  }

  static MediaCard_coverImage fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? large$raw = data.field('large');
    final String? large$value = large$raw == null || large$raw!.isNull
        ? null
        : large$raw!.stringValue;
    return MediaCard_coverImage(large: large$value);
  }
}

class MediaCard_title {
  static String G__typename = "MediaTitle";

  /// class members
  final String? english;

  final String? romaji;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  MediaCard_title({this.english, this.romaji});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MediaCard_title &&
            english == other.english &&
            romaji == other.romaji);
  }

  @override
  int get hashCode =>
      Object.hashAll([english, romaji, MediaCard_title.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'english': this.english, 'romaji': this.romaji};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'english': this.english == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.english!),

    'romaji': this.romaji == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.romaji!),
  });

  static MediaCard_title fromJson(shalom_core.JsonObject data) {
    final String? english$value = data['english'] as String?;
    final String? romaji$value = data['romaji'] as String?;
    return MediaCard_title(english: english$value, romaji: romaji$value);
  }

  static MediaCard_title fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? english$raw = data.field('english');
    final String? english$value = english$raw == null || english$raw!.isNull
        ? null
        : english$raw!.stringValue;
    final shalom_core.ShalomJsonValue? romaji$raw = data.field('romaji');
    final String? romaji$value = romaji$raw == null || romaji$raw!.isNull
        ? null
        : romaji$raw!.stringValue;
    return MediaCard_title(english: english$value, romaji: romaji$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ START UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------
