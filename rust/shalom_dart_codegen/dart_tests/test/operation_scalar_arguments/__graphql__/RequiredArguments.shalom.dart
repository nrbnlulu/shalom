





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class RequiredArgumentsResponse {

    /// class members
    
        final RequiredArguments_product? product;
    
    // keywordargs constructor
    RequiredArgumentsResponse({
    
        this.product,
    
    });
    static RequiredArgumentsResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final RequiredArguments_product? product_value;
        final product$raw = data["product"];
        product_value = 
    
           
            
                product$raw == null ? null : RequiredArguments_product.fromJson(product$raw, context)
            
        
    
;
    
    return RequiredArgumentsResponse(
    
        
        product: product_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is RequiredArgumentsResponse &&
    
        
    
        other.product == product
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        product.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'product':
            
                
    
        
            this.product?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class RequiredArguments_product  {
        
    /// class members
    
        final String id;
    
        final String name;
    
    // keywordargs constructor
    RequiredArguments_product({
    required
        this.id,
    required
        this.name,
    
    });
    static RequiredArguments_product fromJson(JsonObject data, ShalomContext? context) {
    
        
        final String id_value;
        final id$raw = data["id"];
        id_value = 
    
        
            
                id$raw as String
            
        
    
;
    
        
        final String name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String
            
        
    
;
    
    return RequiredArguments_product(
    
        
        id: id_value,
    
        
        name: name_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is RequiredArguments_product &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
        ]);
    
     
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestRequiredArguments extends Requestable {
    
    final RequiredArgumentsVariables variables;
    

    RequestRequiredArguments(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query RequiredArguments($id: ID!) {
  product(id: $id) {
    id
    name
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'RequiredArguments'
        );
    }
}


class RequiredArgumentsVariables {
    
    
        final String id;
    

    RequiredArgumentsVariables (
        
            {
            

    
        
            required this.id
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    


        return data;
    }

    
RequiredArgumentsVariables updateWith(
    {
        
            
                String? id
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
    return RequiredArgumentsVariables(
        
            id: id$next
            
        
    );
}


}
