// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetListingWithUserOptResponse {
  /// class members

  final GetListingWithUserOpt_listing listing;

  // keywordargs constructor
  GetListingWithUserOptResponse({required this.listing});

  GetListingWithUserOptResponse updateWithJson(JsonObject data) {
    final GetListingWithUserOpt_listing listing_value;
    if (data.containsKey('listing')) {
      final listing$raw = data["listing"];
      listing_value = GetListingWithUserOpt_listing.fromJson(listing$raw);
    } else {
      listing_value = listing;
    }

    return GetListingWithUserOptResponse(listing: listing_value);
  }

  static GetListingWithUserOptResponse fromJson(JsonObject data) {
    final GetListingWithUserOpt_listing listing_value;
    final listing$raw = data["listing"];
    listing_value = GetListingWithUserOpt_listing.fromJson(listing$raw);

    return GetListingWithUserOptResponse(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUserOptResponse && other.listing == listing);
  }

  @override
  int get hashCode => listing.hashCode;

  JsonObject toJson() {
    return {'listing': this.listing.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListingWithUserOpt_listing {
  /// class members

  final String id;

  final String name;

  final int? price;

  final GetListingWithUserOpt_listing_userOpt? userOpt;

  // keywordargs constructor
  GetListingWithUserOpt_listing({
    required this.id,
    required this.name,

    this.price,

    this.userOpt,
  });

  GetListingWithUserOpt_listing updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      final id$raw = data["id"];
      id_value = id$raw as String;
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      final name$raw = data["name"];
      name_value = name$raw as String;
    } else {
      name_value = name;
    }

    final int? price_value;
    if (data.containsKey('price')) {
      final price$raw = data["price"];
      price_value = price$raw as int?;
    } else {
      price_value = price;
    }

    final GetListingWithUserOpt_listing_userOpt? userOpt_value;
    if (data.containsKey('userOpt')) {
      final userOpt$raw = data["userOpt"];
      userOpt_value =
          userOpt$raw == null
              ? null
              : GetListingWithUserOpt_listing_userOpt.fromJson(userOpt$raw);
    } else {
      userOpt_value = userOpt;
    }

    return GetListingWithUserOpt_listing(
      id: id_value,

      name: name_value,

      price: price_value,

      userOpt: userOpt_value,
    );
  }

  static GetListingWithUserOpt_listing fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final int? price_value;
    final price$raw = data["price"];
    price_value = price$raw as int?;

    final GetListingWithUserOpt_listing_userOpt? userOpt_value;
    final userOpt$raw = data["userOpt"];
    userOpt_value =
        userOpt$raw == null
            ? null
            : GetListingWithUserOpt_listing_userOpt.fromJson(userOpt$raw);

    return GetListingWithUserOpt_listing(
      id: id_value,

      name: name_value,

      price: price_value,

      userOpt: userOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUserOpt_listing &&
            other.id == id &&
            other.name == name &&
            other.price == price &&
            other.userOpt == userOpt);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price, userOpt]);

  JsonObject toJson() {
    return {
      'id': this.id,

      'name': this.name,

      'price': this.price,

      'userOpt': this.userOpt?.toJson(),
    };
  }
}

class GetListingWithUserOpt_listing_userOpt {
  /// class members

  final String id;

  final String name;

  // keywordargs constructor
  GetListingWithUserOpt_listing_userOpt({required this.id, required this.name});

  GetListingWithUserOpt_listing_userOpt updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      final id$raw = data["id"];
      id_value = id$raw as String;
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      final name$raw = data["name"];
      name_value = name$raw as String;
    } else {
      name_value = name;
    }

    return GetListingWithUserOpt_listing_userOpt(
      id: id_value,

      name: name_value,
    );
  }

  static GetListingWithUserOpt_listing_userOpt fromJson(JsonObject data) {
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    return GetListingWithUserOpt_listing_userOpt(
      id: id_value,

      name: name_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingWithUserOpt_listing_userOpt &&
            other.id == id &&
            other.name == name);
  }

  @override
  int get hashCode => Object.hashAll([id, name]);

  JsonObject toJson() {
    return {'id': this.id, 'name': this.name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListingWithUserOpt extends Requestable {
  RequestGetListingWithUserOpt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetListingWithUserOpt {
  listing {
    id
    name
    price
    userOpt {
      id
      name
    }
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetListingWithUserOpt',
    );
  }
}
