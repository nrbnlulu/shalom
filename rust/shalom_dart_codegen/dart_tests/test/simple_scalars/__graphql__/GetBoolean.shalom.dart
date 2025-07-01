














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetBooleanResponse{

    /// class members
    
        
            final bool boolean;
        
    
    // keywordargs constructor
    GetBooleanResponse({
    required
        this.boolean,
    
    });
    static GetBooleanResponse fromJson(JsonObject data) {
    
        
            final bool boolean_value;
            
                boolean_value = data['boolean'];
            

        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    GetBooleanResponse updateWithJson(JsonObject data) {
    
        
    final bool boolean_value;
    if (data.containsKey('boolean')) {
        
            boolean_value = data['boolean'];
        
    } else {
        boolean_value = boolean;
    }

        
    
    return GetBooleanResponse(
    
        
        boolean: boolean_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetBooleanResponse &&
    
        other.boolean == boolean 
    
    );
    }
    @override
    int get hashCode =>
    
        boolean.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'boolean':
            
                
                    boolean
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetBoolean extends Requestable {
    

    RequestGetBoolean(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetBoolean {
  boolean
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetBoolean'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetBooleanNode extends Node {
  GetBooleanResponse? _obj;
  GetBooleanNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetBooleanResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = GetBooleanResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = GetBooleanResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetBooleanResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------