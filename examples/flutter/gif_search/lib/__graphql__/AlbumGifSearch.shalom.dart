// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'searchGifs': this.searchGifs!.toShalomValue(),
  });

  static AlbumGifSearchResponse fromJson(shalom_core.JsonObject data) {
    final AlbumGifSearch_searchGifs searchGifs$value =
        AlbumGifSearch_searchGifs.fromJson(
          data['searchGifs'] as shalom_core.JsonObject,
        );
    return AlbumGifSearchResponse(searchGifs: searchGifs$value);
  }

  static AlbumGifSearchResponse fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? searchGifs$raw = data.field(
      'searchGifs',
    );
    final AlbumGifSearch_searchGifs searchGifs$value =
        AlbumGifSearch_searchGifs.fromShalomValue(searchGifs$raw!);
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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'hasNextPage': shalom_core.shalomJsonValue(this.hasNextPage!),

    'items': shalom_core.shalomJsonArray(
      this.items!.map((e) => e!.toShalomValue()),
    ),
  });

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

  static AlbumGifSearch_searchGifs fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? hasNextPage$raw = data.field(
      'hasNextPage',
    );
    final bool hasNextPage$value = hasNextPage$raw!.boolValue;
    final shalom_core.ShalomJsonValue? items$raw = data.field('items');
    final List<AlbumGifSearch_searchGifs_items> items$value = items$raw!
        .listValue
        .map((e) => AlbumGifSearch_searchGifs_items.fromShalomValue(e!))
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

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'previewUrl': this.previewUrl == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.previewUrl!),

    'title': shalom_core.shalomJsonValue(this.title!),

    'url': shalom_core.shalomJsonValue(this.url!),
  });

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

  static AlbumGifSearch_searchGifs_items fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? previewUrl$raw = data.field(
      'previewUrl',
    );
    final String? previewUrl$value =
        previewUrl$raw == null || previewUrl$raw!.isNull
        ? null
        : previewUrl$raw!.stringValue;
    final shalom_core.ShalomJsonValue? title$raw = data.field('title');
    final String title$value = title$raw!.stringValue;
    final shalom_core.ShalomJsonValue? url$raw = data.field('url');
    final String url$value = url$raw!.stringValue;
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

// ------------ widget API -------------

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

  static AlbumGifSearchData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? searchGifs$raw = data.field(
      'searchGifs',
    );
    final AlbumGifSearch_searchGifs searchGifs$value =
        AlbumGifSearch_searchGifs.fromShalomValue(searchGifs$raw!);
    return AlbumGifSearchData(searchGifs: searchGifs$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [AlbumGifSearchData]. Returns `null` when absent or incomplete.
  static Future<AlbumGifSearchData?> readFrom(
    shalom_core.CacheProxy cache, {
    AlbumGifSearchVariables? variables,
  }) async {
    return await cache.readOperation<AlbumGifSearchData>(
      name: 'AlbumGifSearch',
      decoder: fromShalomValue,

      variables: variables?.toShalomValue(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    AlbumGifSearchVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'AlbumGifSearch',

      variables: variables?.toShalomValue(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'searchGifs': this.searchGifs.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'searchGifs': this.searchGifs!.toShalomValue(),
  });
}

final class AlbumGifSearchObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final AlbumGifSearchVariables variables;

  const AlbumGifSearchObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'AlbumGifSearch';

  Stream<shalom_core.GraphQLResponse<AlbumGifSearchData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<AlbumGifSearchData>(
      name: operation$Name(),

      variables: variables.toShalomValue(),

      decoder: AlbumGifSearchData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
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

  shalom_core.ShalomJsonValue toShalomValue() {
    final $data = <String, shalom_core.ShalomJsonValue>{};
    $data["limit"] = shalom_core.shalomJsonValue(this.limit!);
    $data["offset"] = shalom_core.shalomJsonValue(this.offset!);
    $data["query"] = shalom_core.shalomJsonValue(this.query!);
    return shalom_core.shalomJsonObject($data);
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

// ------------ END widget API -------------
