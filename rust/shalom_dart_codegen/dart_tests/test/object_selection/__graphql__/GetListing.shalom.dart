typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetListing {
  /// class members

  final GetListing_listing listing;

  // keywordargs constructor

  RequestGetListing({required this.listing});
  static RequestGetListing fromJson(JsonObject data) {
    final GetListing_listing listing_value;

    listing_value = GetListing_listing.fromJson(data['listing']);

    return RequestGetListing(listing: listing_value);
  }

  RequestGetListing updateWithJson(JsonObject data) {
    final GetListing_listing listing_value;
    if (data.containsKey('listing')) {
      listing_value = GetListing_listing.fromJson(data['listing']);
    } else {
      listing_value = listing;
    }

    return RequestGetListing(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetListing && other.listing == listing && true);
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
            other.price == price &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------
