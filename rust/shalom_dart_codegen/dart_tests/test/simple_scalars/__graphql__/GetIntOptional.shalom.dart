

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class 
    RequestGetIntOptional
{

    /// class members
    
        
            final int? intOptional;
        
    
    // keywordargs constructor
    
    RequestGetIntOptional
({
    
        this.intOptional,
    
    });
    static 
    RequestGetIntOptional
 fromJson(JsonObject data) {
    
        
            final int? intOptional_value = data['intOptional'];
        
    
    return 
    RequestGetIntOptional
(
    
        
        intOptional: intOptional_value,
    
    );
    }
    
    RequestGetIntOptional
 updateWithJson(JsonObject data) {
    
        
            final int? intOptional_value;
            if (data.containsKey('intOptional')) {
            intOptional_value = data['intOptional'];
            } else {
            intOptional_value = intOptional;
            }
        
    
    return 
    RequestGetIntOptional
(
    
        
        intOptional: intOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetIntOptional
 &&
    
        
        other.intOptional == intOptional &&
    
    true);
    }
    @override
    int get hashCode =>
    
        intOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intOptional':
            
                intOptional
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------