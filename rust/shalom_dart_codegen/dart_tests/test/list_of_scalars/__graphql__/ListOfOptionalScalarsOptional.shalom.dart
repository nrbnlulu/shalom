





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class ListOfOptionalScalarsOptionalResponse{

    /// class members
    
        final List<int>? listOfOptionalScalarsOptional;
    
    // keywordargs constructor
    ListOfOptionalScalarsOptionalResponse({
    
        this.listOfOptionalScalarsOptional,
    
    });
    static ListOfOptionalScalarsOptionalResponse fromJson(JsonObject data) {
    
        
        final List<int>? listOfOptionalScalarsOptional_value;
        final selection$raw = data["listOfOptionalScalarsOptional"];
        
            listOfOptionalScalarsOptional_value = 
    
        
        
            selection$raw == null ? null : (selection$raw as List<dynamic>).map((e) => 
    
        
            
                e as int
            
        
    
).toList()
        
    
;
        
    
    return ListOfOptionalScalarsOptionalResponse(
    
        
        listOfOptionalScalarsOptional: listOfOptionalScalarsOptional_value,
    
    );
    }
    ListOfOptionalScalarsOptionalResponse updateWithJson(JsonObject data) {
    
        
        final List<int>? listOfOptionalScalarsOptional_value;
        if (data.containsKey('listOfOptionalScalarsOptional')) {
            final listOfOptionalScalarsOptional$raw = data["listOfOptionalScalarsOptional"];
            
                listOfOptionalScalarsOptional_value = 
    
        
        
            listOfOptionalScalarsOptional$raw == null ? null : (listOfOptionalScalarsOptional$raw as List<dynamic>).map((e) => 
    
        
            
                e as int
            
        
    
).toList()
        
    
;
            
        } else {
            listOfOptionalScalarsOptional_value = listOfOptionalScalarsOptional;
        }
    
    return ListOfOptionalScalarsOptionalResponse(
    
        
        listOfOptionalScalarsOptional: listOfOptionalScalarsOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is ListOfOptionalScalarsOptionalResponse &&
    
        
    
        const ListEquality().equals(other.listOfOptionalScalarsOptional, listOfOptionalScalarsOptional)
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        listOfOptionalScalarsOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listOfOptionalScalarsOptional':
            
                
    
        
        
            this.listOfOptionalScalarsOptional?.map((e) => 
    
        
            e
        
    
).toList()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestListOfOptionalScalarsOptional extends Requestable {
    

    RequestListOfOptionalScalarsOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query ListOfOptionalScalarsOptional {
  listOfOptionalScalarsOptional
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            StringopName: 'ListOfOptionalScalarsOptional'
        );
    }
}

