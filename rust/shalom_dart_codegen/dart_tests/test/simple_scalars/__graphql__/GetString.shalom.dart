














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetStringResponse{

    /// class members
    
        
            final String string;
        
    
    // keywordargs constructor
    GetStringResponse({
    required
        this.string,
    
    });
    static GetStringResponse fromJson(JsonObject data) {
    
        
            final String string_value;
            
                string_value = data['string'];
            

        
    
    return GetStringResponse(
    
        
        string: string_value,
    
    );
    }
    GetStringResponse updateWithJson(JsonObject data) {
    
        
    final String string_value;
    if (data.containsKey('string')) {
        
            string_value = data['string'];
        
    } else {
        string_value = string;
    }

        
    
    return GetStringResponse(
    
        
        string: string_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringResponse &&
    
        other.string == string 
    
    );
    }
    @override
    int get hashCode =>
    
        string.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'string':
            
                
                    string
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetString extends Requestable {
    

    RequestGetString(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetString {
  string
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetString'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetStringNode extends Node {
  GetStringResponse? obj = null;
  GetStringNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetStringResponse.fromJson(raw);
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
     obj = GetStringResponse.fromJson(data);
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