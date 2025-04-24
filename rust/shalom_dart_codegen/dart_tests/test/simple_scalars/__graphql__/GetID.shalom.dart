



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class 
    RequestGetID
{

    /// class members
    
        
            final String id;
        
    
    // keywordargs constructor
    
    RequestGetID
({
    required
        this.id,
    
    });
    static 
    RequestGetID
 fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
    return 
    RequestGetID
(
    
        
        id: id_value,
    
    );
    }
    
    RequestGetID
 updateWithJson(JsonObject data) {
    
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'];
            } else {
            id_value = id;
            }
        
    
    return 
    RequestGetID
(
    
        
        id: id_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetID
 &&
    
        
        other.id == id &&
    
    true);
    }
    @override
    int get hashCode =>
    
        id.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                id
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------




