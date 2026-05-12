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
  final int limit;

  final int offset;

  final int? totalCount;

  final bool hasNextPage;

  final List<GifWidgetRef> items;

  // keywordargs constructor
  SearchGifsPage_searchGifs({
    required this.limit,

    required this.offset,

    this.totalCount,

    required this.hasNextPage,

    required this.items,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs &&
            limit == other.limit &&
            offset == other.offset &&
            totalCount == other.totalCount &&
            hasNextPage == other.hasNextPage &&
            const ListEquality().equals(items, other.items));
  }

  @override
  int get hashCode => Object.hashAll([
    limit,

    offset,

    totalCount,

    hasNextPage,

    items,

    SearchGifsPage_searchGifs.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'limit': this.limit,

      'offset': this.offset,

      'totalCount': this.totalCount,

      'hasNextPage': this.hasNextPage,

      'items': this.items.map((e) => e.toJson()).toList(),
    };
  }

  @experimental
  static SearchGifsPage_searchGifs fromJson(shalom_core.JsonObject data) {
    final int limit$value = data['limit'] as int;
    final int offset$value = data['offset'] as int;
    final int? totalCount$value = data['totalCount'] as int?;
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
    return SearchGifsPage_searchGifs(
      limit: limit$value,

      offset: offset$value,

      totalCount: totalCount$value,

      hasNextPage: hasNextPage$value,

      items: items$value,
    );
  }
}

class SearchGifsPage_searchGifs_items {
  static String G__typename = "Gif";

  /// class members
  final String id;

  final String? previewUrl;

  final String title;

  final String url;

  // keywordargs constructor
  SearchGifsPage_searchGifs_items({
    required this.id,

    this.previewUrl,

    required this.title,

    required this.url,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchGifsPage_searchGifs_items &&
            id == other.id &&
            previewUrl == other.previewUrl &&
            title == other.title &&
            url == other.url);
  }

  @override
  int get hashCode => Object.hashAll([
    id,

    previewUrl,

    title,

    url,

    SearchGifsPage_searchGifs_items.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'previewUrl': this.previewUrl,

      'title': this.title,

      'url': this.url,
    };
  }

  @experimental
  static SearchGifsPage_searchGifs_items fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String? previewUrl$value = data['previewUrl'] as String?;
    final String title$value = data['title'] as String;
    final String url$value = data['url'] as String;
    return SearchGifsPage_searchGifs_items(
      id: id$value,

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
