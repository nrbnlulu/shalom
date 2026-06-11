// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

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

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

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

  final bool hasNextPage;

  final List<GifWidgetRef> items;

  final int? totalCount;

  final int limit;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  SearchGifsPage_searchGifs({
    required this.offset,

    required this.hasNextPage,

    required this.items,

    this.totalCount,

    required this.limit,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs &&
            offset == other.offset &&
            hasNextPage == other.hasNextPage &&
            const ListEquality().equals(items, other.items) &&
            totalCount == other.totalCount &&
            limit == other.limit);
  }

  @override
  int get hashCode => Object.hashAll([
    offset,

    hasNextPage,

    items,

    totalCount,

    limit,

    SearchGifsPage_searchGifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'offset': this.offset,

      'hasNextPage': this.hasNextPage,

      'items': this.items.map((e) => e.toJson()).toList(),

      'totalCount': this.totalCount,

      'limit': this.limit,
    };
  }

  @experimental
  static SearchGifsPage_searchGifs fromJson(shalom_core.JsonObject data) {
    final int offset$value = data['offset'] as int;
    final bool hasNextPage$value = data['hasNextPage'] as bool;
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
    final int? totalCount$value = data['totalCount'] as int?;
    final int limit$value = data['limit'] as int;
    return SearchGifsPage_searchGifs(
      offset: offset$value,

      hasNextPage: hasNextPage$value,

      items: items$value,

      totalCount: totalCount$value,

      limit: limit$value,
    );
  }
}

class SearchGifsPage_searchGifs_items {
  static String G__typename = "Gif";

  /// class members
  final String title;

  final String url;

  final String? previewUrl;

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  SearchGifsPage_searchGifs_items({
    required this.title,

    required this.url,

    this.previewUrl,

    required this.id,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs_items &&
            title == other.title &&
            url == other.url &&
            previewUrl == other.previewUrl &&
            id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([
    title,

    url,

    previewUrl,

    id,

    SearchGifsPage_searchGifs_items.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'title': this.title,

      'url': this.url,

      'previewUrl': this.previewUrl,

      'id': this.id,
    };
  }

  @experimental
  static SearchGifsPage_searchGifs_items fromJson(shalom_core.JsonObject data) {
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    final String? previewUrl$value = data['previewUrl'] as String?;
    final String id$value = data['id'] as String;
    return SearchGifsPage_searchGifs_items(
      title: title$value,

      url: url$value,

      previewUrl: previewUrl$value,

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
