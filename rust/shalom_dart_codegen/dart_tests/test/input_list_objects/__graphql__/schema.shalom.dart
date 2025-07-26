// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages














import 'package:shalom_core/shalom_core.dart';








// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------


class ContainerInput {
    
    
        final List<MyInputObject> nestedItems; 
    
        final String title; 
    
    ContainerInput(
        {
        

    
        
            required this.nestedItems
        ,
    
    
    
        
            required this.title
        ,
    
    
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["nestedItems"] = 
    
        
        
            this.nestedItems.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
;
    

    
    
        data["title"] = 
    
        this.title
    
;
    

    
        return data;
    } 
  
ContainerInput updateWith(
    {
        
            
                List<MyInputObject>? nestedItems
            
            ,
        
            
                String? title
            
            
        
    }
) {
    
        final List<MyInputObject> nestedItems$next;
        
            if (nestedItems != null) {
                nestedItems$next = nestedItems;
            } else {
                nestedItems$next = this.nestedItems;
            }
        
    
        final String title$next;
        
            if (title != null) {
                title$next = title;
            } else {
                title$next = this.title;
            }
        
    
    return ContainerInput(
        
            nestedItems: nestedItems$next
            ,
        
            title: title$next
            
        
    );
}

}
     


class MyInputObject {
    
    
        final String id; 
    
        final String name; 
    
        final int value; 
    
    MyInputObject(
        {
        

    
        
            required this.id
        ,
    
    
    
        
            required this.name
        ,
    
    
    
        
            required this.value
        ,
    
    
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    

    
    
        data["name"] = 
    
        this.name
    
;
    

    
    
        data["value"] = 
    
        this.value
    
;
    

    
        return data;
    } 
  
MyInputObject updateWith(
    {
        
            
                String? id
            
            ,
        
            
                String? name
            
            ,
        
            
                int? value
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
        final String name$next;
        
            if (name != null) {
                name$next = name;
            } else {
                name$next = this.name;
            }
        
    
        final int value$next;
        
            if (value != null) {
                value$next = value;
            } else {
                value$next = this.value;
            }
        
    
    return MyInputObject(
        
            id: id$next
            ,
        
            name: name$next
            ,
        
            value: value$next
            
        
    );
}

}
     

// ------------ END Input DEFINITIONS -------------