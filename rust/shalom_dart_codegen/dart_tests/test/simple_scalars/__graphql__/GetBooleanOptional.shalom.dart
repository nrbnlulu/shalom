




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
    

    RequestGetBooleanOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetBooleanOptional {
  booleanOptional
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetBooleanOptional'
        );
    }
}

