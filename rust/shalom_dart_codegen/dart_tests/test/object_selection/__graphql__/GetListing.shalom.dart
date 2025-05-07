import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetListingResponse {
  /// class members

  final GetListing_listing listing;

  // keywordargs constructor
  GetListingResponse({required this.listing});
  static GetListingResponse fromJson(JsonObject data) {
    final GetListing_listing listing_value;

    listing_value = GetListing_listing.fromJson(data['listing']);

    return GetListingResponse(listing: listing_value);
  }

  GetListingResponse updateWithJson(JsonObject data) {
    final GetListing_listing listing_value;
    if (data.containsKey('listing')) {
      listing_value = GetListing_listing.fromJson(data['listing']);
    } else {
      listing_value = listing;
    }

    return GetListingResponse(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingResponse && other.listing == listing);
  }

  @override
  int get hashCode => listing.hashCode;

  JsonObject toJson() {
    return {'listing': listing.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListing_listing {
  /// class members

  final String id;

  final String name;

  final int? price;

  // keywordargs constructor
  GetListing_listing({required this.id, required this.name, this.price});
  static GetListing_listing fromJson(JsonObject data) {
    final String id_value = data['id'];

    final String name_value = data['name'];

    final int? price_value = data['price'];

    return GetListing_listing(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  GetListing_listing updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final int? price_value;
    if (data.containsKey('price')) {
      price_value = data['price'];
    } else {
      price_value = price;
    }

    return GetListing_listing(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListing_listing &&
            other.id == id &&
            other.name == name &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListing extends Requestable {
  final GetListingVariables variables;

  RequestGetListing({required this.variables});

  @override
  Request toRequest() {
    return Request(
      query: r"""query GetListing {
  listing {
    id
    name
    price
  }
}""",
      variables: variables.toJson(),
      opType: OperationType.Query,
      StringopName: 'GetListing',
    );
  }
}

class GetListingVariables {
  GetListingVariables();

  JsonObject toJson() {
    JsonObject data = {};

    return data;
  }

  static GetListingVariables fromJson(JsonObject data) {
    return GetListingVariables();
  }
}
