// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class GetListingOptResponse {
  /// class members

  final GetListingOpt_listingOpt? listingOpt;

  // keywordargs constructor
  GetListingOptResponse({this.listingOpt});
  static GetListingOptResponse fromJson(JsonObject data) {
    final GetListingOpt_listingOpt? listingOpt_value;
    final listingOpt$raw = data["listingOpt"];
    listingOpt_value =
        listingOpt$raw == null
            ? null
            : GetListingOpt_listingOpt.fromJson(listingOpt$raw);

    return GetListingOptResponse(listingOpt: listingOpt_value);
  }

  static GetListingOptResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = GetListingOptResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingOptResponse && other.listingOpt == listingOpt);
  }

  @override
  int get hashCode => listingOpt.hashCode;

  JsonObject toJson() {
    return {'listingOpt': this.listingOpt?.toJson()};
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
    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final int? price_value;
    final price$raw = data["price"];
    price_value = price$raw as int?;

    return GetListingOpt_listingOpt(
      id: id_value,

      name: name_value,

      price: price_value,
    );
  }

  static GetListingOpt_listingOpt deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = GetListingOpt_listingOpt.fromJson(data);

    return self;
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
    return {'id': this.id, 'name': this.name, 'price': this.price};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListingOpt extends Requestable {
  RequestGetListingOpt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetListingOpt {
  listingOpt {
    id
    name
    price
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'GetListingOpt',
    );
  }
}
