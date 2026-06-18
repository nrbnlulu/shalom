// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class AlbumGifSearchResponse {
  static String G__typename = "query";

  /// class members
  final AlbumGifSearch_searchGifs searchGifs;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifSearchResponse({required this.searchGifs});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifSearchResponse && searchGifs == other.searchGifs);
  }

  @override
  int get hashCode =>
      Object.hashAll([searchGifs, AlbumGifSearchResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'searchGifs': this.searchGifs.toJson()};
  }

  static AlbumGifSearchResponse fromJson(shalom_core.JsonObject data) {
    final AlbumGifSearch_searchGifs searchGifs$value =
        AlbumGifSearch_searchGifs.fromJson(
          data['searchGifs'] as shalom_core.JsonObject,
        );
    return AlbumGifSearchResponse(searchGifs: searchGifs$value);
  }
}

class AlbumGifSearch_searchGifs {
  static String G__typename = "GifSearchPage";

  /// class members
  final bool hasNextPage;

  final List<AlbumGifSearch_searchGifs_items> items;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifSearch_searchGifs({required this.hasNextPage, required this.items});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifSearch_searchGifs &&
            hasNextPage == other.hasNextPage &&
            const ListEquality().equals(items, other.items));
  }

  @override
  int get hashCode => Object.hashAll([
    hasNextPage,

    items,

    AlbumGifSearch_searchGifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'hasNextPage': this.hasNextPage,

      'items': this.items.map((e) => e.toJson()).toList(),
    };
  }

  static AlbumGifSearch_searchGifs fromJson(shalom_core.JsonObject data) {
    final bool hasNextPage$value = data['hasNextPage'] as bool;
    final List<AlbumGifSearch_searchGifs_items> items$value =
        (data['items'] as List<dynamic>)
            .map(
              (e) => AlbumGifSearch_searchGifs_items.fromJson(
                e as shalom_core.JsonObject,
              ),
            )
            .toList();
    return AlbumGifSearch_searchGifs(
      hasNextPage: hasNextPage$value,

      items: items$value,
    );
  }
}

class AlbumGifSearch_searchGifs_items {
  static String G__typename = "PreviewGif";

  /// class members
  final String? previewUrl;

  final String title;

  final String url;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AlbumGifSearch_searchGifs_items({
    this.previewUrl,

    required this.title,

    required this.url,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifSearch_searchGifs_items &&
            previewUrl == other.previewUrl &&
            title == other.title &&
            url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([
    previewUrl,

    title,

    url,

    AlbumGifSearch_searchGifs_items.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'previewUrl': this.previewUrl,

      'title': this.title,

      'url': this.url,
    };
  }

  static AlbumGifSearch_searchGifs_items fromJson(shalom_core.JsonObject data) {
    final String? previewUrl$value = data['previewUrl'] as String?;
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    return AlbumGifSearch_searchGifs_items(
      previewUrl: previewUrl$value,

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

// ------------ V2 WIDGET API -------------

final class AlbumGifSearchData implements shalom_core.OperationInterface {
  final AlbumGifSearch_searchGifs searchGifs;

  const AlbumGifSearchData({required this.searchGifs});

  @override
  String operation$Name() => 'AlbumGifSearch';

  static AlbumGifSearchData fromCache(shalom_core.JsonObject data) {
    final AlbumGifSearch_searchGifs searchGifs$value =
        AlbumGifSearch_searchGifs.fromJson(
          data['searchGifs'] as shalom_core.JsonObject,
        );
    return AlbumGifSearchData(searchGifs: searchGifs$value);
  }

  shalom_core.JsonObject toJson() {
    return {'searchGifs': this.searchGifs.toJson()};
  }
}

final class AlbumGifSearchVariables {
  final int limit;

  final int offset;

  final String query;

  const AlbumGifSearchVariables({
    required this.limit,

    required this.offset,

    required this.query,
  });

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["limit"] = this.limit;
    data["offset"] = this.offset;
    data["query"] = this.query;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AlbumGifSearchVariables &&
            this.limit == other.limit &&
            this.offset == other.offset &&
            this.query == other.query);
  }

  @override
  int get hashCode => Object.hashAll([limit, offset, query]);
}

// ------------ END V2 WIDGET API -------------
