typedef JsonObject = Map<String, dynamic>;


// ignore_for_file: non_constant_identifier_names

class 
    RequestGetListingOpt
{

    /// class memberes
    
        
            final GetListingOpt_listingOpt? listingOpt;
        
    
    // keywordargs constructor
    
    RequestGetListingOpt
({
    
        this.listingOpt,
    
    });
    static 
    RequestGetListingOpt
 fromJson(JsonObject data) {
    
        
            final GetListingOpt_listingOpt? listingOpt_value;
            
                final JsonObject? listingOpt$raw = data['listingOpt']; 
                if (listingOpt$raw != null) {
                    listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
                } else {
                    listingOpt_value = null;
                }
            
        
    
    return 
    RequestGetListingOpt
(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    
    RequestGetListingOpt
 updateWithJson(JsonObject data) {
    
        
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
        
    
    return 
    RequestGetListingOpt
(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetListingOpt
 &&
    
        
        other.listingOpt == listingOpt &&
    
    true);
    }
    @override
    int get hashCode =>
    
        listingOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listingOpt':
            
                listingOpt?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetListingOpt_listingOpt  {
        
    /// class memberes
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final int? price;
        
    
        
            final GetListingOpt_listingOpt_user? user;
        
    
    // keywordargs constructor
    GetListingOpt_listingOpt({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
        this.user,
    
    });
    static GetListingOpt_listingOpt fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final int? price_value = data['price'];
        
    
        
            final GetListingOpt_listingOpt_user? user_value;
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetListingOpt_listingOpt_user.fromJson(user$raw);
                } else {
                    user_value = null;
                }
            
        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
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
        
    
        
        final GetListingOpt_listingOpt_user? user_value;
        if (data.containsKey('user')) {
            
                final JsonObject? user$raw = data['user']; 
                if (user$raw != null) {
                    user_value = GetListingOpt_listingOpt_user.fromJson(user$raw);
                } else {
                    user_value = null;
                }
            
        } else {
            user_value = user;
        }
        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        user: user_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOpt_listingOpt &&
    
        
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

    class GetListingOpt_listingOpt_user  {
        
    /// class memberes
    
        
            final String name;
        
    
        
            final String email;
        
    
    // keywordargs constructor
    GetListingOpt_listingOpt_user({
    required
        this.name,
    required
        this.email,
    
    });
    static GetListingOpt_listingOpt_user fromJson(JsonObject data) {
    
        
            final String name_value = data['name'];
        
    
        
            final String email_value = data['email'];
        
    
    return GetListingOpt_listingOpt_user(
    
        
        name: name_value,
    
        
        email: email_value,
    
    );
    }
    GetListingOpt_listingOpt_user updateWithJson(JsonObject data) {
    
        
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
        
    
    return GetListingOpt_listingOpt_user(
    
        
        name: name_value,
    
        
        email: email_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOpt_listingOpt_user &&
    
        
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