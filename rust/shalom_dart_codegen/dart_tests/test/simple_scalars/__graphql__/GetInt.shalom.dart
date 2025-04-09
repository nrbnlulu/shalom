

// ignore_for_file: non_constant_identifier_names

class 
    RequestGetInt
{

    /// class memberes
    
        
        
            final int intField;
        
    
    // keywordargs constructor
    
    RequestGetInt
({
    
        
        required
        this.intField,
    
    });
    static 
    RequestGetInt
 fromJson(Map<String , dynamic> data) {
    
        
        
            final int intField_value;
            intField_value = data['intField'] as int;
        
    
    return 
    RequestGetInt
(
    
        
        intField: intField_value,
    
    );
    }
    
    RequestGetInt
 updateWithJson(Map<String , dynamic> data) {
    
        
        
            final int intField_value;
            if (data.containsKey('intField')) {
            intField_value = data['intField'] as int;
            } else {
            intField_value = intField;
            }
        
    
    return 
    RequestGetInt
(
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is 
    RequestGetInt
 &&
    
        
        other.intField == intField &&
    
    true);
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    Map<String , dynamic> toJson() {
    return {
    
        
        'intField':
        
            intField
        
        ,
    
    };
    }

}


    
