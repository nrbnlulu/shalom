typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class RequestGetListingWithUser {
  /// class memberes

  final GetListingWithUser_listing listing;

  // keywordargs constructor

  RequestGetListingWithUser({required this.listing});
  static RequestGetListingWithUser fromJson(JsonObject data) {
    final GetListingWithUser_listing listing_value;

    listing_value = GetListingWithUser_listing.fromJson(data['listing']);

    return RequestGetListingWithUser(listing: listing_value);
  }

  RequestGetListingWithUser updateWithJson(JsonObject data) {
    final GetListingWithUser_listing listing_value;
    if (data.containsKey('listing')) {
      listing_value = GetListingWithUser_listing.fromJson(data['listing']);
    } else {
      listing_value = listing;
    }

    return RequestGetListingWithUser(listing: listing_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetListingWithUser &&
            other.listing == listing &&
            true);
  }

  @override
  int get hashCode => listing.hashCode;

  JsonObject toJson() {
    return {'listing': listing.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetListingWithUser_listing {
  /// class memberes

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
    final String id_value = data['id'];

    final String name_value = data['name'];

    final int? price_value = data['price'];

    final GetListingWithUser_listing_user user_value;

    user_value = GetListingWithUser_listing_user.fromJson(data['user']);

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

    final GetListingWithUser_listing_user user_value;
    if (data.containsKey('user')) {
      user_value = GetListingWithUser_listing_user.fromJson(data['user']);
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
            other.user == user &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, price, user]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'price': price, 'user': user.toJson()};
  }
}

class GetListingWithUser_listing_user {
  /// class memberes

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
    final String id_value = data['id'];

    final String name_value = data['name'];

    final String email_value = data['email'];

    final int? age_value = data['age'];

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

    final String email_value;
    if (data.containsKey('email')) {
      email_value = data['email'];
    } else {
      email_value = email;
    }

    final int? age_value;
    if (data.containsKey('age')) {
      age_value = data['age'];
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
            other.age == age &&
            true);
  }

  @override
  int get hashCode => Object.hashAll([id, name, email, age]);

  JsonObject toJson() {
    return {'id': id, 'name': name, 'email': email, 'age': age};
  }
}

// ------------ END OBJECT DEFINITIONS -------------
