// Then generate classes

/// GetListing class with selected fields from query
library;

class RequestGetListing {
  /// Class fields

  final RequestGetListingListing? listing;

  /// Constructor
  RequestGetListing({this.listing});

  /// Creates from JSON
  factory RequestGetListing.fromJson(Map<String, dynamic> json) =>
      RequestGetListing(
        listing:
            json['listing'] != null
                ? RequestGetListingListing.fromJson(
                  json['listing'] as Map<String, dynamic>,
                )
                : null,
      );

  /// Updates from JSON
  RequestGetListing updateWithJson(Map<String, dynamic> data) {
    return RequestGetListing(
      listing:
          data.containsKey('listing')
              ? (data['listing'] != null
                  ? RequestGetListingListing.fromJson(
                    data['listing'] as Map<String, dynamic>,
                  )
                  : null)
              : listing,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {'listing': listing?.toJson()};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetListing && other.listing == listing && true);

  @override
  int get hashCode => Object.hashAll([listing]);
}

/// GetListingListing class with selected fields from query

class RequestGetListingListing {
  /// Class fields

  final String id;

  final String name;

  final int? price;

  final RequestGetListingUser? user;

  /// Constructor
  RequestGetListingListing({
    required this.id,

    required this.name,

    this.price,

    this.user,
  });

  /// Creates from JSON
  factory RequestGetListingListing.fromJson(Map<String, dynamic> json) =>
      RequestGetListingListing(
        id: json['id'] as String,

        name: json['name'] as String,

        price: json['price'] as int?,

        user:
            json['user'] != null
                ? RequestGetListingUser.fromJson(
                  json['user'] as Map<String, dynamic>,
                )
                : null,
      );

  /// Updates from JSON
  RequestGetListingListing updateWithJson(Map<String, dynamic> data) {
    return RequestGetListingListing(
      id: data.containsKey('id') ? data['id'] as String : id,

      name: data.containsKey('name') ? data['name'] as String : name,

      price: data.containsKey('price') ? data['price'] as int? : price,

      user:
          data.containsKey('user')
              ? (data['user'] != null
                  ? RequestGetListingUser.fromJson(
                    data['user'] as Map<String, dynamic>,
                  )
                  : null)
              : user,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    'id': id,

    'name': name,

    'price': price,

    'user': user?.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetListingListing &&
          other.id == id &&
          other.name == name &&
          other.price == price &&
          other.user == user &&
          true);

  @override
  int get hashCode => Object.hashAll([id, name, price, user]);
}

/// GetListingUser class with selected fields from query

class RequestGetListingUser {
  /// Class fields

  final String name;

  final String email;

  /// Constructor
  RequestGetListingUser({required this.name, required this.email});

  /// Creates from JSON
  factory RequestGetListingUser.fromJson(Map<String, dynamic> json) =>
      RequestGetListingUser(
        name: json['name'] as String,

        email: json['email'] as String,
      );

  /// Updates from JSON
  RequestGetListingUser updateWithJson(Map<String, dynamic> data) {
    return RequestGetListingUser(
      name: data.containsKey('name') ? data['name'] as String : name,

      email: data.containsKey('email') ? data['email'] as String : email,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetListingUser &&
          other.name == name &&
          other.email == email &&
          true);

  @override
  int get hashCode => Object.hashAll([name, email]);
}
