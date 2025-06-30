














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetMultipleFieldsResponse{

    /// class members
    
        
            final String id;
        
    
        
            final int intField;
        
    
    // keywordargs constructor
    GetMultipleFieldsResponse({
    required
        this.id,
    required
        this.intField,
    
    });
    static GetMultipleFieldsResponse fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final int intField_value;
            
                intField_value = data['intField'];
            

        
    
    return GetMultipleFieldsResponse(
    
        
        id: id_value,
    
        
        intField: intField_value,
    
    );
    }
    GetMultipleFieldsResponse updateWithJson(JsonObject data) {
    
        
    final String id_value;
    if (data.containsKey('id')) {
        
            id_value = data['id'];
        
    } else {
        id_value = id;
    }

        
    
        
    final int intField_value;
    if (data.containsKey('intField')) {
        
            intField_value = data['intField'];
        
    } else {
        intField_value = intField;
    }

        
    
    return GetMultipleFieldsResponse(
    
        
        id: id_value,
    
        
        intField: intField_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetMultipleFieldsResponse &&
    
        other.id == id &&
    
        other.intField == intField 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            intField,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
                    id
                
            
        ,
    
        
        'intField':
            
                
                    intField
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetMultipleFields extends Requestable {
    

    RequestGetMultipleFields(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetMultipleFields {
  id
  intField
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetMultipleFields'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetMultipleFieldsNode extends Node {
  GetMultipleFieldsResponse? obj = null;
  GetMultipleFieldsNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetMultipleFieldsResponse.fromJson(raw);
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
     obj = GetMultipleFieldsResponse.fromJson(data);
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