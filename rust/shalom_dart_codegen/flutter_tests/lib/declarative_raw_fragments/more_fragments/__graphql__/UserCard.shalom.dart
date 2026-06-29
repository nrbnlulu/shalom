// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: UserCard

import "../../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import '../../fragments/__graphql__/UserIdentity.shalom.dart';

// Generate abstract fragment class
abstract class UserCard implements UserIdentity {
  String get email;
  String get id;
  String get name;

  Map<String, dynamic> toJson();
}

class UserCardImpl implements UserCard {
  static String G__typename = "User";

  /// class members
  final String email;

  final String id;

  final String name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  UserCardImpl({required this.email, required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCardImpl &&
            email == other.email &&
            id == other.id &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([email, id, name, UserCardImpl.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'email': this.email, 'id': this.id, 'name': this.name};
  }

  static UserCardImpl fromJson(shalom_core.JsonObject data) {
    final String email$value = data['email'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return UserCardImpl(email: email$value, id: id$value, name: name$value);
  }
}

// ------------ START OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

// ------------ START UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------
