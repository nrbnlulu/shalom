typedef JsonObject = Map<String, dynamic>;


// ignore_for_file: non_constant_identifier_names

class 
    RequestGetListing
{

    /// class memberes
    
        
            final GetListing_listing listing;
        
    
    // keywordargs constructor
    
    RequestGetListing
({
    required
        this.listing,
    
    });
    static 
    RequestGetListing
 fromJson(JsonObject data) {
    
        
            final GetListing_listing listing_value;
            
                listing_value = GetListing_listing.fromJson(data['listing']);            
            
        
    
    return 
    RequestGetListing
(
    
        
        listing: listing_value,
    
    );
    }
    
    RequestGetListing
 updateWithJson(JsonObject data) {
    
        
        final GetListing_listing listing_value;
        if (data.containsKey('listing')) {
            
                listing_value = GetListing_listing.fromJson(data['listing']);            
            
        } else {
            listing_value = listing;
        }
        
    
    return 
    RequestGetListing
(
    
        
        listing: listing_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetListing
 &&
    
        
        other.listing == listing &&
    
    true);
    }
    @override
    int get hashCode =>
    
        listing.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listing':
            
                listing.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetListing_listing  {
        
    /// class memberes
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final int? price;
        
    
        
            final GetListing_listing_user? user;
        
    
    // keywordargs constructor
    GetListing_listing({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
        this.user,
    
    });
    static GetListing_listing fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final int? price_value = data['price'];
        
    
        
            final GetListing_listing_user? user_value;
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetListing_listing_user.fromJson(user$raw);
                } else {
                    user_value = null;
                }
            
        
    
    return GetListing_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
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
        
    
        
        final GetListing_listing_user? user_value;
        if (data.containsKey('user')) {
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetListing_listing_user.fromJson(user$raw);
                } else {
                    user_value = null;
                }
            
        } else {
            user_value = user;
        }
        
    
    return GetListing_listing(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListing_listing &&
    
        
        other.id == id &&
    
        
        other.name == name &&
    
        
        other.price == price &&
    
        
        other.user == user &&
    
    true);
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
            
            user,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                id
            
        ,
    
        
        'name':
            
                name
            
        ,
    
        
        'price':
            
                price
            
        ,
    
        
        'user':
            
                user?.toJson()
            
        ,
    
    };
    }

    }

    class GetListing_listing_user  {
        
    /// class memberes
    
        
            final String name;
        
    
        
            final String email;
        
    
    // keywordargs constructor
    GetListing_listing_user({
    required
        this.name,
    required
        this.email,
    
    });
    static GetListing_listing_user fromJson(JsonObject data) {
    
        
            final String name_value = data['name'];
        
    
        
            final String email_value = data['email'];
        
    
    return GetListing_listing_user(
    
        
        name: name_value,
    
        
        email: email_value,
    
    );
    }
    GetListing_listing_user updateWithJson(JsonObject data) {
    
        
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
        
    
    return GetListing_listing_user(
    
        
        name: name_value,
    
        
        email: email_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListing_listing_user &&
    
        
        other.name == name &&
    
        
        other.email == email &&
    
    true);
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            name,
        
            
            email,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'name':
            
                name
            
        ,
    
        
        'email':
            
                email
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------