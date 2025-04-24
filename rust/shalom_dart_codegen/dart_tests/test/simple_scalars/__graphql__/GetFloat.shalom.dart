



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class 
    RequestGetFloat
{

    /// class members
    
        
            final double float;
        
    
    // keywordargs constructor
    
    RequestGetFloat
({
    required
        this.float,
    
    });
    static 
    RequestGetFloat
 fromJson(JsonObject data) {
    
        
            final double float_value = data['float'];
        
    
    return 
    RequestGetFloat
(
    
        
        float: float_value,
    
    );
    }
    
    RequestGetFloat
 updateWithJson(JsonObject data) {
    
        
            final double float_value;
            if (data.containsKey('float')) {
            float_value = data['float'];
            } else {
            float_value = float;
            }
        
    
    return 
    RequestGetFloat
(
    
        
        float: float_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetFloat
 &&
    
        
        other.float == float &&
    
    true);
    }
    @override
    int get hashCode =>
    
        float.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'float':
            
                float
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------




