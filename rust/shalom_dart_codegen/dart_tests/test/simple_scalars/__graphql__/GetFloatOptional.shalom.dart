














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetFloatOptionalResponse{

    /// class members
    
        
            final double? floatOptional;
        
    
    // keywordargs constructor
    GetFloatOptionalResponse({
    
        this.floatOptional,
    
    });
    static GetFloatOptionalResponse fromJson(JsonObject data) {
    
        
            final double? floatOptional_value;
            
                floatOptional_value = data['floatOptional'];
            

        
    
    return GetFloatOptionalResponse(
    
        
        floatOptional: floatOptional_value,
    
    );
    }
    GetFloatOptionalResponse updateWithJson(JsonObject data) {
    
        
    final double? floatOptional_value;
    if (data.containsKey('floatOptional')) {
        
            floatOptional_value = data['floatOptional'];
        
    } else {
        floatOptional_value = floatOptional;
    }

        
    
    return GetFloatOptionalResponse(
    
        
        floatOptional: floatOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetFloatOptionalResponse &&
    
        other.floatOptional == floatOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        floatOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'floatOptional':
            
                
                    floatOptional
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetFloatOptional extends Requestable {
    

    RequestGetFloatOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetFloatOptional {
  floatOptional
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetFloatOptional'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetFloatOptionalNode extends Node {
  GetFloatOptionalResponse? obj = null;
  GetFloatOptionalNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetFloatOptionalResponse.fromJson(raw);
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
     obj = GetFloatOptionalResponse.fromJson(data);
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