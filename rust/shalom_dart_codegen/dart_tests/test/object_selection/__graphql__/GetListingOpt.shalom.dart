// ignore_for_file: non_constant_identifier_names

class RequestGetListingOpt {
  /// class memberes

  final GetListingOptListingOpt? listingOpt;

  // keywordargs constructor

  RequestGetListingOpt({this.listingOpt});
  static RequestGetListingOpt fromJson(Map<String, dynamic> data) {
    final GetListingOptListingOpt? listingOpt_value;
    final Map<String, dynamic>? listingOpt_raw = data['listingOpt'];
    if (listingOpt_raw != null) {
      listingOpt_value = GetListingOptListingOpt.fromJson(listingOpt_raw);
    } else {
      listingOpt_value = null;
    }

    return RequestGetListingOpt(listingOpt: listingOpt_value);
  }

  RequestGetListingOpt updateWithJson(Map<String, dynamic> data) {
    final GetListingOptListingOpt? listingOpt_value;
    if (data.containsKey('listingOpt')) {
      final Map<String, dynamic>? listingOpt_raw = data['listingOpt'];
      if (listingOpt_raw != null) {
        listingOpt_value = GetListingOptListingOpt.fromJson(listingOpt_raw);
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
    final String id_value = data['id'];

    final String name_value = data['name'];

    final int? price_value = data['price'];

    final GetListingOptUser? user_value;
    final Map<String, dynamic>? user_raw = data['user'];
    if (user_raw != null) {
      user_value = GetListingOptUser.fromJson(user_raw);
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

    final GetListingOptUser? user_value;
    if (data.containsKey('user')) {
      final Map<String, dynamic>? user_raw = data['user'];
      if (user_raw != null) {
        user_value = GetListingOptUser.fromJson(user_raw);
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
    final String name_value = data['name'];

    final String email_value = data['email'];

    return GetListingOptUser(name: name_value, email: email_value);
  }

  GetListingOptUser updateWithJson(Map<String, dynamic> data) {
    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final String email_value;
    if (data.containsKey('email')) {
      email_value = data['email'];
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
