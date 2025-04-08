// ignore_for_file: non_constant_identifier_names

class RequestGetListing {
  /// class memberes

  final GetListingListing? listing;

  // keywordargs constructor

  RequestGetListing({this.listing});

  static RequestGetListing fromJson(Map<String, dynamic> data) {
    return RequestGetListing(
      listing:
          data['listing'] != null
              ? GetListingListing.fromJson(
                data['listing'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  RequestGetListing updateWithJson(Map<String, dynamic> data) {
    return RequestGetListing(
      listing:
          data.containsKey('listing')
              ? (data['listing'] != null
                  ? GetListingListing.fromJson(
                    data['listing'] as Map<String, dynamic>,
                  )
                  : null)
              : this.listing,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RequestGetListing && other.listing == listing && true);
  }

  @override
  int get hashCode => Object.hashAll([listing]);

  Map<String, dynamic> toJson() {
    return {'listing': listing?.toJson()};
  }
}

class GetListingListing {
  /// class memberes

  final String id;

  final String name;

  final int? price;

  final GetListingUser? user;

  // keywordargs constructor
  GetListingListing({
    required this.id,

    required this.name,

    this.price,

    this.user,
  });

  static GetListingListing fromJson(Map<String, dynamic> data) {
    return GetListingListing(
      id: data['id'] as String,

      name: data['name'] as String,

      price: data['price'] as int?,

      user:
          data['user'] != null
              ? GetListingUser.fromJson(data['user'] as Map<String, dynamic>)
              : null,
    );
  }

  GetListingListing updateWithJson(Map<String, dynamic> data) {
    return GetListingListing(
      id: data.containsKey('id') ? data['id'] as String : this.id,

      name: data.containsKey('name') ? data['name'] as String : this.name,

      price: data.containsKey('price') ? data['price'] as int? : this.price,

      user:
          data.containsKey('user')
              ? (data['user'] != null
                  ? GetListingUser.fromJson(
                    data['user'] as Map<String, dynamic>,
                  )
                  : null)
              : this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingListing &&
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

class GetListingUser {
  /// class memberes

  final String name;

  final String email;

  // keywordargs constructor
  GetListingUser({required this.name, required this.email});

  static GetListingUser fromJson(Map<String, dynamic> data) {
    return GetListingUser(
      name: data['name'] as String,

      email: data['email'] as String,
    );
  }

  GetListingUser updateWithJson(Map<String, dynamic> data) {
    return GetListingUser(
      name: data.containsKey('name') ? data['name'] as String : this.name,

      email: data.containsKey('email') ? data['email'] as String : this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetListingUser &&
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
