

// ignore_for_file: non_constant_identifier_names



class 
RequestGetBooleanOptional
{


/// class memberes



final bool? booleanOptional;



// keywordargs constructor

RequestGetBooleanOptional
({
   
   
   this.booleanOptional,
    
});


static 
RequestGetBooleanOptional
 fromJson(Map<String, dynamic> data) {
    
    
    
      final bool? booleanOptional_value;
      booleanOptional_value = data['booleanOptional'] as bool?;
    
     
    return 
RequestGetBooleanOptional
(
    
    
    booleanOptional: booleanOptional_value,
    
    );
}



RequestGetBooleanOptional
 updateWithJson(Map<String, dynamic> data) {
      
        
        
        final bool? booleanOptional_value;
        if (data.containsKey('booleanOptional')) {
            booleanOptional_value = data['booleanOptional'] as bool?;
        } else {
            booleanOptional_value = this.booleanOptional;
        }
      
      
      return 
RequestGetBooleanOptional
(
      
      
      booleanOptional: booleanOptional_value,
      
      );
}

@override
bool operator ==(Object other) { 
    return identical(this, other) ||
    (other is 
RequestGetBooleanOptional
 &&
        
        
        other.booleanOptional == booleanOptional &&
        
        true);
}        

@override
  int get hashCode => 
    
   booleanOptional.hashCode; 
  

 Map<String, dynamic> toJson() {

    return { 
     
    'booleanOptional': 
      booleanOptional
    ,
    
    };
 }


}




    
