
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetBooleanOptionalResponse{

    /// class members
    
        
            final bool? booleanOptional;
        
    
    // keywordargs constructor
    GetBooleanOptionalResponse({
    
        this.booleanOptional,
    
    });
    static GetBooleanOptionalResponse fromJson(JsonObject data) {
    
        
            final bool? booleanOptional_value = data['booleanOptional'];
        
    
    return GetBooleanOptionalResponse(
    
        
        booleanOptional: booleanOptional_value,
    
    );
    }
    GetBooleanOptionalResponse updateWithJson(JsonObject data) {
    
        
            final bool? booleanOptional_value;
            if (data.containsKey('booleanOptional')) {
            booleanOptional_value = data['booleanOptional'];
            } else {
            booleanOptional_value = booleanOptional;
            }
        
    
    return GetBooleanOptionalResponse(
    
        
        booleanOptional: booleanOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanOptionalResponse &&
    
        other.booleanOptional == booleanOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        booleanOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'booleanOptional':
            
                booleanOptional
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBooleanOptional extends Requestable {
    final GetBooleanOptionalResponse operation;
    final GetBooleanOptionalVariables variables;

    RequestGetBooleanOptional({
        required this.operation,  
        required this.variables,
    });

    String selectionsJsonToQuery(JsonObject selection) {
        List<String> selectionItems = [];
        for (var entry in selection.entries) {
            if (entry.value is JsonObject) {
                String subSelections = selectionsJsonToQuery(entry.value);
                selectionItems.add("${entry.key} $subSelections");
            } else {
                selectionItems.add(entry.key);   
            }
        } 
        String selectionItemsString = selectionItems.join(" ");
        return "{$selectionItemsString}";
    }  

    String queryString() {
        String selectionString = this.selectionsJsonToQuery(operation.toJson()); 
        String variablesString = variables.toTypes().entries.map((entry) => '\$${entry.key}: ${entry.value}').join(", "); 
        String queryString = "query GetBooleanOptional($variablesString) $selectionString";
        return queryString;
    } 

    Request toRequest() {
        return Request(
            query: this.queryString(), 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetBooleanOptional'
        );
    }
}


class GetBooleanOptionalVariables {
    

    GetBooleanOptionalVariables(
        
    );

    JsonObject toTypes() {
        return {
              
        };
    }  

    JsonObject toJson() {
        return {
              
        };
    } 
}
