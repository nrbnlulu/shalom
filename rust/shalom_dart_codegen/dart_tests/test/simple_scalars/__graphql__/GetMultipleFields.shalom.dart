

// ignore_for_file: non_constant_identifier_names



class 
RequestGetMultipleFields
{


/// class memberes



final String id;




final int intField;



// keywordargs constructor

RequestGetMultipleFields
({
   
   
   required this.id,
   
   
   required this.intField,
    
});


static 
RequestGetMultipleFields
 fromJson(Map<String, dynamic> data) {
    
    
    
      final String id_value;
      id_value = data['id'] as String;
    
    
    
    
      final int intField_value;
      intField_value = data['intField'] as int;
    
     
    return 
RequestGetMultipleFields
(
    
    
    id: id_value,
    
    
    intField: intField_value,
    
    );
}



RequestGetMultipleFields
 updateWithJson(Map<String, dynamic> data) {
      
        
        
        final String id_value;
        if (data.containsKey('id')) {
            id_value = data['id'] as String;
        } else {
            id_value = this.id;
        }
      
      
        
        
        final int intField_value;
        if (data.containsKey('intField')) {
            intField_value = data['intField'] as int;
        } else {
            intField_value = this.intField;
        }
      
      
      return 
RequestGetMultipleFields
(
      
      
      id: id_value,
      
      
      intField: intField_value,
      
      );
}

@override
bool operator ==(Object other) { 
    return identical(this, other) ||
    (other is 
RequestGetMultipleFields
 &&
        
        
        other.id == id &&
        
        
        other.intField == intField &&
        
        true);
}        

@override
  int get hashCode => 
    
    Object.hashAll([
    
    
    id,
    
    
    intField,
    
  ]);
  

 Map<String, dynamic> toJson() {

    return { 
     
    'id': 
      id
    ,
    
     
    'intField': 
      intField
    ,
    
    };
 }


}




    
