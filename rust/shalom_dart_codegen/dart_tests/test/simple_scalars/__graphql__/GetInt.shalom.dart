














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIntResponse{

    /// class members
    
        
            final int intField;
        
    
    // keywordargs constructor
    GetIntResponse({
    required
        this.intField,
    
    });
    static GetIntResponse fromJson(JsonObject data) {
    
        
            final int intField_value;
            
                intField_value = data['intField'];
            

        
    
    return GetIntResponse(
    
        
        intField: intField_value,
    
    );
    }
    GetIntResponse updateWithJson(JsonObject data) {
    
        
    final int intField_value;
    if (data.containsKey('intField')) {
        
            intField_value = data['intField'];
        
    } else {
        intField_value = intField;
    }

        
    
    return GetIntResponse(
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIntResponse &&
    
        other.intField == intField 
    
    );
    }
    @override
    int get hashCode =>
    
        intField.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'intField':
            
                
                    intField
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetInt extends Requestable {
    

    RequestGetInt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetInt {
  intField
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetInt'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetIntNode extends Node {
  GetIntResponse? obj = null;
  GetIntNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetIntResponse.fromJson(raw);
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
     obj = GetIntResponse.fromJson(data);
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