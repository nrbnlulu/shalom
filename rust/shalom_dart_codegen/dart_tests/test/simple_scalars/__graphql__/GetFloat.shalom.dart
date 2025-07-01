














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
  GetFloatResponse? _obj;
  GetFloatNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetFloatResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = GetFloatResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = GetFloatResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetFloatResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------