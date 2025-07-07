// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetListingWithUserResponse {
  /// class members

  final GetListingWithUser_listing listing;

  // keywordargs constructor
  GetListingWithUserResponse({required this.listing});
  static GetListingWithUserResponse fromJson(JsonObject data) {
    final GetListingWithUser_listing listing_value;

    listing_value = GetListingWithUser_listing.fromJson(data["listing"]);

    return GetListingWithUserResponse(listing: listing_value);
  }

  GetListingWithUserResponse updateWithJson(JsonObject data) {
    final GetListingWithUser_listing listing_value;
    if (data.containsKey('listing')) {
      listing_value = GetListingWithUser_listing.fromJson(data["listing"]);
    } else {
      listing_value = listing;
    }

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

  final String id;

  final String name;

  final int? price;

  final GetListingWithUser_listing_user user;

  // keywordargs constructor
  GetListingWithUser_listing({
    required this.id,
    required this.name,

    this.price,
    required this.user,
  });
  static GetListingWithUser_listing fromJson(JsonObject data) {
    final String id_value;

    id_value = data["id"] as String;

    final String name_value;

    name_value = data["name"] as String;

    final int? price_value;

    price_value = data["price"] as int?;

    final GetListingWithUser_listing_user user_value;

    user_value = GetListingWithUser_listing_user.fromJson(data["user"]);

    return GetListingWithUser_listing(
      id: id_value,

      name: name_value,

      price: price_value,

      user: user_value,
    );
  }

  GetListingWithUser_listing updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data["id"] as String;
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data["name"] as String;
    } else {
      name_value = name;
    }

    final int? price_value;
    if (data.containsKey('price')) {
      price_value = data["price"] as int?;
    } else {
      price_value = price;
    }

    final GetListingWithUser_listing_user user_value;
    if (data.containsKey('user')) {
      user_value = GetListingWithUser_listing_user.fromJson(data["user"]);
    } else {
      user_value = user;
    }

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

  final String id;

  final String name;

  final String email;

  final int? age;

  // keywordargs constructor
  GetListingWithUser_listing_user({
    required this.id,
    required this.name,
    required this.email,

    this.age,
  });
  static GetListingWithUser_listing_user fromJson(JsonObject data) {
    final String id_value;

    id_value = data["id"] as String;

    final String name_value;

    name_value = data["name"] as String;

    final String email_value;

    email_value = data["email"] as String;

    final int? age_value;

    age_value = data["age"] as int?;

    return GetListingWithUser_listing_user(
      id: id_value,

      name: name_value,

      email: email_value,

      age: age_value,
    );
  }

  GetListingWithUser_listing_user updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data["id"] as String;
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data["name"] as String;
    } else {
      name_value = name;
    }

    final String email_value;
    if (data.containsKey('email')) {
      email_value = data["email"] as String;
    } else {
      email_value = email;
    }

    final int? age_value;
    if (data.containsKey('age')) {
      age_value = data["age"] as int?;
    } else {
      age_value = age;
    }

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
