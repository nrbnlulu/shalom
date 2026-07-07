// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";

import 'dart:async' show Stream;

import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports
import '../fragments/__graphql__/UserIdentity.shalom.dart';
import '../more_fragments/__graphql__/UserCard.shalom.dart';

// ------------ OBJECT DEFINITIONS -------------

class UserCardQueryResponse {
  static String G__typename = "query";

  /// class members
  final UserCardQuery_user? user;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UserCardQueryResponse({this.user});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCardQueryResponse && user == other.user);
  }

  @override
  int get hashCode => Object.hashAll([user, UserCardQueryResponse.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }

  static UserCardQueryResponse fromJson(shalom_core.JsonObject data) {
    final UserCardQuery_user? user$value = data['user'] == null
        ? null
        : UserCardQuery_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserCardQueryResponse(user: user$value);
  }
}

class UserCardQuery_user implements UserCard {
  static String G__typename = "User";

  /// class members
  final String email;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UserCardQuery_user({
    required this.email,

    required this.id,

    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCardQuery_user &&
            email == other.email &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([email, id, name, UserCardQuery_user.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'email': this.email, 'id': this.id, 'name': this.name};
  }

  static UserCardQuery_user fromJson(shalom_core.JsonObject data) {
    final String email$value = data['email'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UserCardQuery_user(
      email: email$value,

      id: id$value,

      name: name$value,
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

final class UserCardQueryData implements shalom_core.OperationInterface {
  final UserCardQuery_user? user;

  const UserCardQueryData({required this.user});

  @override
  String operation$Name() => 'UserCardQuery';

  static UserCardQueryData fromCache(shalom_core.JsonObject data) {
    final UserCardQuery_user? user$value = data['user'] == null
        ? null
        : UserCardQuery_user.fromJson(data['user'] as shalom_core.JsonObject);
    return UserCardQueryData(user: user$value);
  }

  /// Reads this operation's current cache entry through [cache], decoding
  /// it as [UserCardQueryData]. Returns `null` when absent or incomplete.
  static Future<UserCardQueryData?> readFrom(
    shalom_core.CacheProxy cache, {
    UserCardQueryVariables? variables,
  }) async {
    return await cache.readQuery<UserCardQueryData>(
      name: 'UserCardQuery',
      decoder: fromCache,

      variables: variables?.toJson(),
    );
  }

  shalom_core.JsonObject toJson() {
    return {'user': this.user?.toJson()};
  }
}

final class UserCardQueryObservable {
  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final UserCardQueryVariables variables;

  const UserCardQueryObservable({
    required this.variables,

    this.executionPolicy = shalom_core.ExecutionPolicyInput.cacheFirst,
    this.retryDelay = const shalom_core.RetryDelay.inherit(),
    this.autoRefetch,
  });

  String operation$Name() => 'UserCardQuery';

  Stream<shalom_core.GraphQLResponse<UserCardQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.request<UserCardQueryData>(
      name: operation$Name(),

      variables: variables.toJson(),

      decoder: UserCardQueryData.fromCache,
      executionPolicy: executionPolicy,
      retryDelay: retryDelay,
      autoRefetch: autoRefetch,
    );
  }
}

final class UserCardQueryVariables {
  final String id;

  const UserCardQueryVariables({required this.id});

  shalom_core.JsonObject toJson() {
    shalom_core.JsonObject data = {};

    data["id"] = this.id;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCardQueryVariables && this.id == other.id);
  }

  @override
  int get hashCode => Object.hashAll([id]);
}

// ------------ END widget API -------------
