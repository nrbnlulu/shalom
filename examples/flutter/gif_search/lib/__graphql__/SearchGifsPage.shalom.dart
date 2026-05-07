// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'GifWidget.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class SearchGifsPageResponse {
  static String G__typename = "query";

  /// class members
  final SearchGifsPage_searchGifs searchGifs;

  // keywordargs constructor
  SearchGifsPageResponse({required this.searchGifs});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPageResponse && searchGifs == other.searchGifs);
  }

  @override
  int get hashCode =>
      Object.hashAll([searchGifs, SearchGifsPageResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'searchGifs': this.searchGifs.toJson()};
  }

  @experimental
  static SearchGifsPageResponse fromJson(shalom_core.JsonObject data) {
    final SearchGifsPage_searchGifs searchGifs$value =
        SearchGifsPage_searchGifs.fromJson(
          data['searchGifs'] as shalom_core.JsonObject,
        );
    return SearchGifsPageResponse(searchGifs: searchGifs$value);
  }
}

class SearchGifsPage_searchGifs {
  static String G__typename = "GifSearchPage";

  /// class members
  final int offset;

  final int? totalCount;

  final int limit;

  final List<GifWidgetRef> items;

  final bool hasNextPage;

  // keywordargs constructor
  SearchGifsPage_searchGifs({
    required this.offset,

    this.totalCount,

    required this.limit,

    required this.items,

    required this.hasNextPage,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs &&
            offset == other.offset &&
            totalCount == other.totalCount &&
            limit == other.limit &&
            const ListEquality().equals(items, other.items) &&
            hasNextPage == other.hasNextPage);
  }

  @override
  int get hashCode => Object.hashAll([
    offset,

    totalCount,

    limit,

    items,

    hasNextPage,

    SearchGifsPage_searchGifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'offset': this.offset,

      'totalCount': this.totalCount,

      'limit': this.limit,

      'items': this.items.map((e) => e.toJson()).toList(),

      'hasNextPage': this.hasNextPage,
    };
  }

  @experimental
  static SearchGifsPage_searchGifs fromJson(shalom_core.JsonObject data) {
    final int offset$value = data['offset'] as int;
    final int? totalCount$value = data['totalCount'] as int?;
    final int limit$value = data['limit'] as int;
    final List<GifWidgetRef> items$value =
        (data['items'] as List<dynamic>)
            .map(
              (e) => GifWidgetRef.fromInput(
                shalom_core.observedRefInputFromJson(
                  (e as shalom_core.JsonObject)[r'$GifWidget']
                      as shalom_core.JsonObject,
                ),
              ),
            )
            .toList();
    final bool hasNextPage$value = data['hasNextPage'] as bool;
    return SearchGifsPage_searchGifs(
      offset: offset$value,

      totalCount: totalCount$value,

      limit: limit$value,

      items: items$value,

      hasNextPage: hasNextPage$value,
    );
  }
}

class SearchGifsPage_searchGifs_items {
  static String G__typename = "Gif";

  /// class members
  final String? previewUrl;

  final String url;

  final String title;

  final String id;

  // keywordargs constructor
  SearchGifsPage_searchGifs_items({
    this.previewUrl,

    required this.url,

    required this.title,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs_items &&
            previewUrl == other.previewUrl &&
            url == other.url &&
            title == other.title &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    previewUrl,

    url,

    title,

    id,

    SearchGifsPage_searchGifs_items.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'previewUrl': this.previewUrl,

      'url': this.url,

      'title': this.title,

      'id': this.id,
    };
  }

  @experimental
  static SearchGifsPage_searchGifs_items fromJson(shalom_core.JsonObject data) {
    final String? previewUrl$value = data['previewUrl'] as String?;
    final String url$value = data['url'] as String;
    final String title$value = data['title'] as String;
    final String id$value = data['id'] as String;
    return SearchGifsPage_searchGifs_items(
      previewUrl: previewUrl$value,

      url: url$value,

      title: title$value,

      id: id$value,
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

final class SearchGifsPageData {
  final SearchGifsPage_searchGifs searchGifs;

  const SearchGifsPageData({required this.searchGifs});

  @experimental
  static SearchGifsPageData fromCache(shalom_core.JsonObject data) {
    final SearchGifsPage_searchGifs searchGifs$value =
        SearchGifsPage_searchGifs.fromJson(
          data['searchGifs'] as shalom_core.JsonObject,
        );
    return SearchGifsPageData(searchGifs: searchGifs$value);
  }

  shalom_core.JsonObject toJson() {
    return {'searchGifs': this.searchGifs.toJson()};
  }
}

final class SearchGifsPageVariables {
  final int limit;

  final int offset;

  final String query;

  const SearchGifsPageVariables({
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
        (other is SearchGifsPageVariables &&
            this.limit == other.limit &&
            this.offset == other.offset &&
            this.query == other.query);
  }

  @override
  int get hashCode => Object.hashAll([limit, offset, query]);
}

// ------------ END V2 WIDGET API -------------
