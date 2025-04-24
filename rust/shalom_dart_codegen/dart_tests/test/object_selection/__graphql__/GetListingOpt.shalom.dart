typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetListingOpt {
  /// class members

  final GetListingOpt_listingOpt? listingOpt;

  // keywordargs constructor

  RequestGetListingOpt({this.listingOpt});
  static RequestGetListingOpt fromJson(JsonObject data) {
    final GetListingOpt_listingOpt? listingOpt_value;

    final JsonObject? listingOpt$raw = data['listingOpt'];
    if (listingOpt$raw != null) {
      listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
    } else {
      listingOpt_value = null;
    }

    return RequestGetListingOpt(listingOpt: listingOpt_value);
  }

  RequestGetListingOpt updateWithJson(JsonObject data) {
    final GetListingOpt_listingOpt? listingOpt_value;
    if (data.containsKey('listingOpt')) {
      final JsonObject? listingOpt$raw = data['listingOpt'];
      if (listingOpt$raw != null) {
        listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
      } else {
        listingOpt_value = null;
      }
    } else {
      listingOpt_value = listingOpt;
    }

    return RequestGetListingOpt(listingOpt: listingOpt_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetListingOpt && other.listingOpt == listingOpt);
  }

  @override
  int get hashCode => listingOpt.hashCode;

  JsonObject toJson() {
    return {'listingOpt': listingOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListingOpt_listingOpt {
  /// class members

  final String id;

  final String name;

  final int? price;

  // keywordargs constructor
  GetListingOpt_listingOpt({required this.id, required this.name, this.price});
  static GetListingOpt_listingOpt fromJson(JsonObject data) {
    final String id_value = data['id'];

    final String name_value = data['name'];

    final int? price_value = data['price'];

    return GetListingOpt_listingOpt(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  GetListingOpt_listingOpt updateWithJson(JsonObject data) {
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

    return GetListingOpt_listingOpt(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingOpt_listingOpt &&
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
