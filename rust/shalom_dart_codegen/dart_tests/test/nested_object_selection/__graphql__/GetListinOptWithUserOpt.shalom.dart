// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetListinOptWithUserOptResponse {
  /// class members

  final GetListinOptWithUserOpt_listingOpt? listingOpt;

  // keywordargs constructor
  GetListinOptWithUserOptResponse({this.listingOpt});
  static GetListinOptWithUserOptResponse fromJson(JsonObject data) {
    final GetListinOptWithUserOpt_listingOpt? listingOpt_value;

    final JsonObject? listingOpt$raw = data['listingOpt'];
    if (listingOpt$raw != null) {
      listingOpt_value = GetListinOptWithUserOpt_listingOpt.fromJson(
        listingOpt$raw,
      );
    } else {
      listingOpt_value = null;
    }

    return GetListinOptWithUserOptResponse(listingOpt: listingOpt_value);
  }

  GetListinOptWithUserOptResponse updateWithJson(JsonObject data) {
    final GetListinOptWithUserOpt_listingOpt? listingOpt_value;
    if (data.containsKey('listingOpt')) {
      final JsonObject? listingOpt$raw = data['listingOpt'];
      if (listingOpt$raw != null) {
        listingOpt_value = GetListinOptWithUserOpt_listingOpt.fromJson(
          listingOpt$raw,
        );
      } else {
        listingOpt_value = null;
      }
    } else {
      listingOpt_value = listingOpt;
    }

    return GetListinOptWithUserOptResponse(listingOpt: listingOpt_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListinOptWithUserOptResponse &&
            other.listingOpt == listingOpt);
  }

  @override
  int get hashCode => listingOpt.hashCode;

  JsonObject toJson() {
    return {'listingOpt': listingOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListinOptWithUserOpt_listingOpt {
  /// class members

  final String id;

  final String name;

  final int? price;

  final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt;

  // keywordargs constructor
  GetListinOptWithUserOpt_listingOpt({
    required this.id,
    required this.name,

    this.price,

    this.userOpt,
  });
  static GetListinOptWithUserOpt_listingOpt fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final String name_value;

    name_value = data['name'];

    final int? price_value;

    price_value = data['price'];

    final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt_value;

    final JsonObject? userOpt$raw = data['userOpt'];
    if (userOpt$raw != null) {
      userOpt_value = GetListinOptWithUserOpt_listingOpt_userOpt.fromJson(
        userOpt$raw,
      );
    } else {
      userOpt_value = null;
    }

    return GetListinOptWithUserOpt_listingOpt(
      id: id_value,

      name: name_value,

      price: price_value,

      userOpt: userOpt_value,
    );
  }

  GetListinOptWithUserOpt_listingOpt updateWithJson(JsonObject data) {
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

    final GetListinOptWithUserOpt_listingOpt_userOpt? userOpt_value;
    if (data.containsKey('userOpt')) {
      final JsonObject? userOpt$raw = data['userOpt'];
      if (userOpt$raw != null) {
        userOpt_value = GetListinOptWithUserOpt_listingOpt_userOpt.fromJson(
          userOpt$raw,
        );
      } else {
        userOpt_value = null;
      }
    } else {
      userOpt_value = userOpt;
    }

    return GetListinOptWithUserOpt_listingOpt(
      id: id_value,

      name: name_value,

      price: price_value,

      userOpt: userOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListinOptWithUserOpt_listingOpt &&
            other.id == id &&
            other.name == name &&
            other.price == price &&
            other.userOpt == userOpt);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price, userOpt]);

  JsonObject toJson() {
    return {
      'id': id,

      'name': name,

      'price': price,

      'userOpt': userOpt?.toJson(),
    };
  }
}

class GetListinOptWithUserOpt_listingOpt_userOpt {
  /// class members

  final String id;

  final String name;

  // keywordargs constructor
  GetListinOptWithUserOpt_listingOpt_userOpt({
    required this.id,
    required this.name,
  });
  static GetListinOptWithUserOpt_listingOpt_userOpt fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final String name_value;

    name_value = data['name'];

    return GetListinOptWithUserOpt_listingOpt_userOpt(
      id: id_value,

      name: name_value,
    );
  }

  GetListinOptWithUserOpt_listingOpt_userOpt updateWithJson(JsonObject data) {
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

    return GetListinOptWithUserOpt_listingOpt_userOpt(
      id: id_value,

      name: name_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListinOptWithUserOpt_listingOpt_userOpt &&
            other.id == id &&
            other.name == name);
  }

  @override
  int get hashCode => Object.hashAll([id, name]);

  JsonObject toJson() {
    return {'id': id, 'name': name};
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetListinOptWithUserOpt extends Requestable {
  RequestGetListinOptWithUserOpt();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetListinOptWithUserOpt {
  listingOpt {
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
      StringopName: 'GetListinOptWithUserOpt',
    );
  }
}

// ------------ Node DEFINITIONS -------------

class GetListinOptWithUserOptNode extends Node {
  GetListinOptWithUserOptResponse? _obj;
  GetListinOptWithUserOptNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetListinOptWithUserOptResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = GetListinOptWithUserOptResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = GetListinOptWithUserOptResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetListinOptWithUserOptResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
