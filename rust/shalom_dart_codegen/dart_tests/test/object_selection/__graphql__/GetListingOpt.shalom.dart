// ignore_for_file: non_constant_identifier_names

class RequestGetListingOpt {
  /// class memberes

  final GetListingOptListingOpt? listingOpt;

  // keywordargs constructor

  RequestGetListingOpt({this.listingOpt});
  static RequestGetListingOpt fromJson(Map<String, dynamic> data) {
    final GetListingOptListingOpt? listingOpt_value;
    if (data['listingOpt'] != null) {
      listingOpt_value = GetListingOptListingOpt.fromJson(
        data['listingOpt'] as Map<String, dynamic>,
      );
    } else {
      listingOpt_value = null;
    }

    return RequestGetListingOpt(listingOpt: listingOpt_value);
  }

  RequestGetListingOpt updateWithJson(Map<String, dynamic> data) {
    final GetListingOptListingOpt? listingOpt_value;
    if (data.containsKey('listingOpt')) {
      if (data['listingOpt'] != null) {
        listingOpt_value = GetListingOptListingOpt.fromJson(
          data['listingOpt'] as Map<String, dynamic>,
        );
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
        (other is RequestGetListingOpt &&
            other.listingOpt == listingOpt &&
            true);
  }

  @override
  int get hashCode => listingOpt.hashCode;

  Map<String, dynamic> toJson() {
    return {'listingOpt': listingOpt?.toJson()};
  }
}

class GetListingOptListingOpt {
  /// class memberes

  final String id;

  final String name;

  final int? price;

  final GetListingOptUser? user;

  // keywordargs constructor
  GetListingOptListingOpt({
    required this.id,

    required this.name,

    this.price,

    this.user,
  });
  static GetListingOptListingOpt fromJson(Map<String, dynamic> data) {
    final String id_value;
    id_value = data['id'] as String;

    final String name_value;
    name_value = data['name'] as String;

    final int? price_value;
    price_value = data['price'] as int?;

    final GetListingOptUser? user_value;
    if (data['user'] != null) {
      user_value = GetListingOptUser.fromJson(
        data['user'] as Map<String, dynamic>,
      );
    } else {
      user_value = null;
    }

    return GetListingOptListingOpt(
      id: id_value,

      name: name_value,

      price: price_value,

      user: user_value,
    );
  }

  GetListingOptListingOpt updateWithJson(Map<String, dynamic> data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'] as String;
    } else {
      id_value = id;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'] as String;
    } else {
      name_value = name;
    }

    final int? price_value;
    if (data.containsKey('price')) {
      price_value = data['price'] as int?;
    } else {
      price_value = price;
    }

    final GetListingOptUser? user_value;
    if (data.containsKey('user')) {
      if (data['user'] != null) {
        user_value = GetListingOptUser.fromJson(
          data['user'] as Map<String, dynamic>,
        );
      } else {
        user_value = null;
      }
    } else {
      user_value = user;
    }

    return GetListingOptListingOpt(
      id: id_value,

      name: name_value,

      price: price_value,

      user: user_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingOptListingOpt &&
            other.id == id &&
            other.name == name &&
            other.price == price &&
            other.user == user &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price, user]);

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'user': user?.toJson()};
  }
}

class GetListingOptUser {
  /// class memberes

  final String name;

  final String email;

  // keywordargs constructor
  GetListingOptUser({required this.name, required this.email});
  static GetListingOptUser fromJson(Map<String, dynamic> data) {
    final String name_value;
    name_value = data['name'] as String;

    final String email_value;
    email_value = data['email'] as String;

    return GetListingOptUser(name: name_value, email: email_value);
  }

  GetListingOptUser updateWithJson(Map<String, dynamic> data) {
    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'] as String;
    } else {
      name_value = name;
    }

    final String email_value;
    if (data.containsKey('email')) {
      email_value = data['email'] as String;
    } else {
      email_value = email;
    }

    return GetListingOptUser(name: name_value, email: email_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingOptUser &&
            other.name == name &&
            other.email == email &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([name, email]);

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}
