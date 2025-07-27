// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetListingWithUserResponse {
  /// class members

  GetListingWithUser_listing listing;

  // keywordargs constructor
  GetListingWithUserResponse({required this.listing});
  static GetListingWithUserResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final GetListingWithUser_listing listing_value;
    final listing$raw = data["listing"];

    listing_value = GetListingWithUser_listing.fromJson(listing$raw, context);

    return GetListingWithUserResponse(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUserResponse && other.listing == listing);
  }

  @override
  int get hashCode => listing.hashCode;

  JsonObject toJson() {
    return {'listing': this.listing.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListingWithUser_listing {
  /// class members

  String id;

  String name;

  int? price;

  GetListingWithUser_listing_user user;

  // keywordargs constructor
  GetListingWithUser_listing({
    required this.id,

    required this.name,

    this.price,

    required this.user,
  });
  static GetListingWithUser_listing fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String id_value;
    final id$raw = data["id"];

    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];

    name_value = name$raw as String;

    final int? price_value;
    final price$raw = data["price"];

    price_value = price$raw as int?;

    final GetListingWithUser_listing_user user_value;
    final user$raw = data["user"];

    user_value = GetListingWithUser_listing_user.fromJson(user$raw, context);

    return GetListingWithUser_listing(
      id: id_value,

      name: name_value,

      price: price_value,

      user: user_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUser_listing &&
            other.id == id &&
            other.name == name &&
            other.price == price &&
            other.user == user);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price, user]);

  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'price': this.price,

      'user': this.user.toJson(),
    };
  }
}

class GetListingWithUser_listing_user {
  /// class members

  String id;

  String name;

  String email;

  int? age;

  // keywordargs constructor
  GetListingWithUser_listing_user({
    required this.id,

    required this.name,

    required this.email,

    this.age,
  });
  static GetListingWithUser_listing_user fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final String id_value;
    final id$raw = data["id"];

    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];

    name_value = name$raw as String;

    final String email_value;
    final email$raw = data["email"];

    email_value = email$raw as String;

    final int? age_value;
    final age$raw = data["age"];

    age_value = age$raw as int?;

    return GetListingWithUser_listing_user(
      id: id_value,

      name: name_value,

      email: email_value,

      age: age_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUser_listing_user &&
            other.id == id &&
            other.name == name &&
            other.email == email &&
            other.age == age);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);

  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'email': this.email,

      'age': this.age,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListingWithUser extends Requestable {
  RequestGetListingWithUser();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetListingWithUser {
  listing {
    id
    name
    price
    user {
      id
      name
      email
      age
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetListingWithUser',
    );
  }
}
