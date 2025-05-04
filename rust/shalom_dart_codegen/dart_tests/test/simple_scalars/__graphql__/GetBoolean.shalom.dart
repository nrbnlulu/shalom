
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetBooleanResponse{

    /// class members
    
        
            final bool boolean;
        
    
    // keywordargs constructor
    GetBooleanResponse({
    required
        this.boolean,
    
    });
    static GetBooleanResponse fromJson(JsonObject data) {
    
        
            final bool boolean_value = data['boolean'];
        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    GetBooleanResponse updateWithJson(JsonObject data) {
    
        
            final bool boolean_value;
            if (data.containsKey('boolean')) {
            boolean_value = data['boolean'];
            } else {
            boolean_value = boolean;
            }
        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanResponse &&
    
        other.boolean == boolean 
    
    );
    }
    @override
    int get hashCode =>
    
        boolean.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'boolean':
            
                boolean
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetBoolean extends Requestable {
    final GetBooleanResponse operation;
    final GetBooleanVariables variables;

    RequestGetBoolean({
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
        String queryString = "query GetBoolean($variablesString) $selectionString";
        return queryString;
    } 

    Request toRequest() {
        return Request(
            query: this.queryString(), 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetBoolean'
        );
    }
}


class GetBooleanVariables {
    

    GetBooleanVariables(
        
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
