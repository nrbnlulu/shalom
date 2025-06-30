














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetFloatResponse{

    /// class members
    
        
            final double float;
        
    
    // keywordargs constructor
    GetFloatResponse({
    required
        this.float,
    
    });
    static GetFloatResponse fromJson(JsonObject data) {
    
        
            final double float_value;
            
                float_value = data['float'];
            

        
    
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
    

    RequestGetFloat(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetFloat {
  float
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetFloat'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetFloatNode extends Node {
  GetFloatResponse? obj = null;
  GetFloatNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetFloatResponse.fromJson(raw);
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
     obj = GetFloatResponse.fromJson(data);
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