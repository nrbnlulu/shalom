// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports

// ------------ OBJECT DEFINITIONS -------------

class UserWidgetResponse {
  static String G__typename = "query";

  /// class members
  final UserWidget_user? user;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UserWidgetResponse({this.user});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidgetResponse && user == other.user);
  }

  @override
  int get hashCode => Object.hashAll([user, UserWidgetResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'user': this.user == null
        ? shalom_core.shalomJsonValue(null)
        : this.user!.toShalomValue(),
  });

  static UserWidgetResponse fromJson(shalom_core.JsonObject data) {
    final UserWidget_user? user$value = data['user'] == null
        ? null
        : UserWidget_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserWidgetResponse(user: user$value);
  }

  static UserWidgetResponse fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? user$raw = data.field('user');
    final UserWidget_user? user$value = user$raw == null || user$raw!.isNull
        ? null
        : UserWidget_user.fromShalomValue(user$raw!);
    return UserWidgetResponse(user: user$value);
  }
}

class UserWidget_user {
  static String G__typename = "User";

  /// class members
  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UserWidget_user({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidget_user && id == other.id && name == other.name);
  }

  @override
  int get hashCode => Object.hashAll([id, name, UserWidget_user.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'id': shalom_core.shalomJsonValue(this.id!),

    'name': shalom_core.shalomJsonValue(this.name!),
  });

  static UserWidget_user fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UserWidget_user(id: id$value, name: name$value);
  }

  static UserWidget_user fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final String name$value = name$raw!.stringValue;
    return UserWidget_user(id: id$value, name: name$value);
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

final class UserWidgetData implements shalom_core.OperationInterface {
  final UserWidget_user? user;

  const UserWidgetData({required this.user});

  @override
  String operation$Name() => 'UserWidget';

  static UserWidgetData fromCache(shalom_core.JsonObject data) {
    final UserWidget_user? user$value = data['user'] == null
        ? null
        : UserWidget_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserWidgetData(user: user$value);
  }

  static UserWidgetData fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? user$raw = data.field('user');
    final UserWidget_user? user$value = user$raw == null || user$raw!.isNull
        ? null
        : UserWidget_user.fromShalomValue(user$raw!);
    return UserWidgetData(user: user$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [UserWidgetData]. Returns `null` when absent or incomplete.
  static Future<UserWidgetData?> readFrom(
    shalom_core.CacheProxy cache, {
    UserWidgetVariables? variables,
  }) async {
    return await cache.readOperation<UserWidgetData>(
      name: 'UserWidget',
      decoder: fromShalomValue,

      variables: variables?.toShalomValue(),
    );
  }

  /// Evicts this operation's cached entry (matched by [variables]) through
  /// [cache], notifying any active subscribers. Returns `false` if no
  /// matching cache entry existed.
  static Future<bool> evictFrom(
    shalom_core.CacheProxy cache, {
    UserWidgetVariables? variables,
  }) {
    return cache.evictOperation(
      name: 'UserWidget',

      variables: variables?.toShalomValue(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'user': this.user == null
        ? shalom_core.shalomJsonValue(null)
        : this.user!.toShalomValue(),
  });
}

final class UserWidgetObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final UserWidgetVariables variables;

  const UserWidgetObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'UserWidget';

  Stream<shalom_core.GraphQLResponse<UserWidgetData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<UserWidgetData>(
      name: operation$Name(),

      variables: variables.toShalomValue(),

      decoder: UserWidgetData.fromShalomValue,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

final class UserWidgetVariables {
  final String id;

  const UserWidgetVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  shalom_core.ShalomJsonValue toShalomValue() {
    final $data = <String, shalom_core.ShalomJsonValue>{};
    $data["id"] = shalom_core.shalomJsonValue(this.id!);
    return shalom_core.shalomJsonObject($data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserWidgetVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
