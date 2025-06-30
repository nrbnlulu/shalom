














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetIDOptionalResponse{

    /// class members
    
        
            final String? idOptional;
        
    
    // keywordargs constructor
    GetIDOptionalResponse({
    
        this.idOptional,
    
    });
    static GetIDOptionalResponse fromJson(JsonObject data) {
    
        
            final String? idOptional_value;
            
                idOptional_value = data['idOptional'];
            

        
    
    return GetIDOptionalResponse(
    
        
        idOptional: idOptional_value,
    
    );
    }
    GetIDOptionalResponse updateWithJson(JsonObject data) {
    
        
    final String? idOptional_value;
    if (data.containsKey('idOptional')) {
        
            idOptional_value = data['idOptional'];
        
    } else {
        idOptional_value = idOptional;
    }

        
    
    return GetIDOptionalResponse(
    
        
        idOptional: idOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetIDOptionalResponse &&
    
        other.idOptional == idOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        idOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'idOptional':
            
                
                    idOptional
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetIDOptional extends Requestable {
    

    RequestGetIDOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetIDOptional {
  idOptional
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetIDOptional'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetIDOptionalNode extends Node {
  GetIDOptionalResponse? obj = null;
  GetIDOptionalNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetIDOptionalResponse.fromJson(raw);
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
     obj = GetIDOptionalResponse.fromJson(data);
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