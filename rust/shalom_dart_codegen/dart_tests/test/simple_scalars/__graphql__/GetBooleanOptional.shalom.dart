














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetBooleanOptionalResponse{

    /// class members
    
        
            final bool? booleanOptional;
        
    
    // keywordargs constructor
    GetBooleanOptionalResponse({
    
        this.booleanOptional,
    
    });
    static GetBooleanOptionalResponse fromJson(JsonObject data) {
    
        
            final bool? booleanOptional_value;
            
                booleanOptional_value = data['booleanOptional'];
            

        
    
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



// ------------ Node DEFINITIONS -------------

class GetBooleanOptionalNode extends Node {
  GetBooleanOptionalResponse? obj = null;
  GetBooleanOptionalNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetBooleanOptionalResponse.fromJson(raw);
      manager.addOrUpdateNode(this);
     } else {
      throw Exception("must subscribe to node through manager");
     }
  }

  @override
  void updateWithJson(JsonObject newData) {
    final newObj = obj?.updateWithJson(newData);
    if (newObj != null) {
      obj = newObj;
      notifyListeners();
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }

  @override
  void convertToObjAndSet(JsonObject data) {
     obj = GetBooleanOptionalResponse.fromJson(data);
  }
  
  @override
  JsonObject data() {
    final data = obj?.toJson();
    if (data != null) {
        return data;
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }
} 
// ------------ END Node DEFINITIONS -------------