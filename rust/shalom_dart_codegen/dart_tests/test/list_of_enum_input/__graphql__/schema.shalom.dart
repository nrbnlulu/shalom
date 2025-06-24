// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import
















import 'package:shalom_core/shalom_core.dart';








// ------------ Enum DEFINITIONS -------------

     
     
     enum Color  {
          
                BLUE ,
          
                GREEN ,
          
                RED ;
          
          
          static Color fromString(String name) {
              switch (name) {
                  
                  case 'BLUE':
                    return Color.BLUE;                   
                  case 'GREEN':
                    return Color.GREEN;                   
                  case 'RED':
                    return Color.RED;                   
                  default:  
                      throw ArgumentError.value(name, 'name', 'No Status enum member with this name');  
              }
          }

      }

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------


class ListOfEnumInput {
    
    
        final Option<List<Color>?> colorsMaybe; 
    
        final Option<List<Color>?> colorsOptional; 
    
        final List<Color> colorsRequired; 
    
    ListOfEnumInput(
        {
        

    
         
            this.colorsMaybe = const None() 
        ,
    
    
    
         
            this.colorsOptional = const None() 
        ,
    
    
    
        
            required this.colorsRequired  
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    

    
        if (colorsMaybe.isSome()) {
            
                data["colorsMaybe"] = colorsMaybe.some();
            
        }
    

    

    
        if (colorsOptional.isSome()) {
            
                data["colorsOptional"] = colorsOptional.some();
            
        }
    

    

    
        
            data["colorsRequired"] = colorsRequired; 
        
    

    
        return data;
    } 
  
ListOfEnumInput updateWith(
    {
        
            
                Option<Option<List<Color>?>> colorsMaybe = const None()
            
            ,
        
            
                Option<Option<List<Color>?>> colorsOptional = const None()
            
            ,
        
            
                List<Color>? colorsRequired
            
            
        
    }
) {
    
        final Option<List<Color>?> colorsMaybe$next;
        
            switch (colorsMaybe) {

                case Some(value: final data):
                    colorsMaybe$next = data;
                case None():
                    colorsMaybe$next = this.colorsMaybe;
            }
        
    
        final Option<List<Color>?> colorsOptional$next;
        
            switch (colorsOptional) {

                case Some(value: final data):
                    colorsOptional$next = data;
                case None():
                    colorsOptional$next = this.colorsOptional;
            }
        
    
        final List<Color> colorsRequired$next;
        
            if (colorsRequired != null) {
                colorsRequired$next = colorsRequired;
            } else {
                colorsRequired$next = this.colorsRequired;
            }
        
    
    return ListOfEnumInput(
        
            colorsMaybe: colorsMaybe$next
            ,
        
            colorsOptional: colorsOptional$next
            ,
        
            colorsRequired: colorsRequired$next
            
        
    );
}

}
     

// ------------ END Input DEFINITIONS -------------