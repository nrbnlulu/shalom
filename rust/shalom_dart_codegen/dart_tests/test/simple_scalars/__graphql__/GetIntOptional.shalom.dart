

// ignore_for_file: non_constant_identifier_names



class 
RequestGetIntOptional
{


/// class memberes



final int? intOptional;



// keywordargs constructor

RequestGetIntOptional
({
   
   
   this.intOptional,
    
});


static 
RequestGetIntOptional
 fromJson(Map<String, dynamic> data) {
    
    
    
      final int? intOptional_value;
      intOptional_value = data['intOptional'] as int?;
    
     
    return 
RequestGetIntOptional
(
    
    
    intOptional: intOptional_value,
    
    );
}



RequestGetIntOptional
 updateWithJson(Map<String, dynamic> data) {
      
        
        
        final int? intOptional_value;
        if (data.containsKey('intOptional')) {
            intOptional_value = data['intOptional'] as int?;
        } else {
            intOptional_value = this.intOptional;
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
  

 Map<String, dynamic> toJson() {

    return { 
     
    'intOptional': 
      intOptional
    ,
    
    };
 }


}




    
