














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIDResponse{

    /// class members
    
        
            final String id;
        
    
    // keywordargs constructor
    GetIDResponse({
    required
        this.id,
    
    });
    static GetIDResponse fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
    return GetIDResponse(
    
        
        id: id_value,
    
    );
    }
    GetIDResponse updateWithJson(JsonObject data) {
    
        
    final String id_value;
    if (data.containsKey('id')) {
        
            id_value = data['id'];
        
    } else {
        id_value = id;
    }

        
    
    return GetIDResponse(
    
        
        id: id_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIDResponse &&
    
        other.id == id 
    
    );
    }
    @override
    int get hashCode =>
    
        id.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
                    id
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetID extends Requestable {
    

    RequestGetID(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetID {
  id
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetID'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetIDNode extends Node {
  GetIDResponse? obj = null;
  GetIDNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetIDResponse.fromJson(raw);
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
     obj = GetIDResponse.fromJson(data);
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