
import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetFloatResponse{

    /// class members
    
        
            final double float;
        
    
    // keywordargs constructor
    GetFloatResponse({
    required
        this.float,
    
    });
    static GetFloatResponse fromJson(JsonObject data) {
    
        
            final double float_value = data['float'];
        
    
    return GetFloatResponse(
    
        
        float: float_value,
    
    );
    }
    GetFloatResponse updateWithJson(JsonObject data) {
    
        
            final double float_value;
            if (data.containsKey('float')) {
            float_value = data['float'];
            } else {
            float_value = float;
            }
        
    
    return GetFloatResponse(
    
        
        float: float_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloatResponse &&
    
        other.float == float 
    
    );
    }
    @override
    int get hashCode =>
    
        float.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'float':
            
                float
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------

class RequestGetFloat extends Requestable {
    final GetFloatResponse operation;
    final GetFloatVariables variables;

    RequestGetFloat({
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
        String queryString = "query GetFloat($variablesString) $selectionString";
        return queryString;
    } 

    Request toRequest() {
        return Request(
            query: this.queryString(), 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetFloat'
        );
    }
}


class GetFloatVariables {
    

    GetFloatVariables(
        
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
