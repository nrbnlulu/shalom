class RequestGetListing {
  final GetListingListing? listing;

  RequestGetListing({this.listing});

  factory RequestGetListing.fromJson(Map<String, dynamic> json) =>
      RequestGetListing(
        listing:
            json['listing'] != null
                ? GetListingListing.fromJson(
                  json['listing'] as Map<String, dynamic>,
                )
                : null,
      );

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

  Map<String, dynamic> toJson() => {'listing': listing?.toJson()};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetListing && other.listing == listing && true);

  @override
  int get hashCode => Object.hashAll([listing]);
}

class GetListingListing {
  final String id;

  final String name;

  final int? price;

  final GetListingUser? user;

  GetListingListing({
    required this.id,

    required this.name,

    this.price,

    this.user,
  });

  factory GetListingListing.fromJson(Map<String, dynamic> json) =>
      GetListingListing(
        id: json['id'] as String,

        name: json['name'] as String,

        price: json['price'] as int?,

        user:
            json['user'] != null
                ? GetListingUser.fromJson(json['user'] as Map<String, dynamic>)
                : null,
      );

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

  Map<String, dynamic> toJson() => {
    'id': id,

    'name': name,

    'price': price,

    'user': user?.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GetListingListing &&
          other.id == id &&
          other.name == name &&
          other.price == price &&
          other.user == user &&
          true);

  @override
  int get hashCode => Object.hashAll([id, name, price, user]);
}

class GetListingUser {
  final String name;

  final String email;

  GetListingUser({required this.name, required this.email});

  factory GetListingUser.fromJson(Map<String, dynamic> json) => GetListingUser(
    name: json['name'] as String,

    email: json['email'] as String,
  );

  GetListingUser updateWithJson(Map<String, dynamic> data) {
    return GetListingUser(
      name: data.containsKey('name') ? data['name'] as String : this.name,

      email: data.containsKey('email') ? data['email'] as String : this.email,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GetListingUser &&
          other.name == name &&
          other.email == email &&
          true);

  @override
  int get hashCode => Object.hashAll([name, email]);
}
