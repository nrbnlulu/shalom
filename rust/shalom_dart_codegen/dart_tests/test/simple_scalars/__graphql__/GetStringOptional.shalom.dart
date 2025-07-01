














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetStringOptionalResponse{

    /// class members
    
        
            final String? stringOptional;
        
    
    // keywordargs constructor
    GetStringOptionalResponse({
    
        this.stringOptional,
    
    });
    static GetStringOptionalResponse fromJson(JsonObject data) {
    
        
            final String? stringOptional_value;
            
                stringOptional_value = data['stringOptional'];
            

        
    
    return GetStringOptionalResponse(
    
        
        stringOptional: stringOptional_value,
    
    );
    }
    GetStringOptionalResponse updateWithJson(JsonObject data) {
    
        
    final String? stringOptional_value;
    if (data.containsKey('stringOptional')) {
        
            stringOptional_value = data['stringOptional'];
        
    } else {
        stringOptional_value = stringOptional;
    }

        
    
    return GetStringOptionalResponse(
    
        
        stringOptional: stringOptional_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetStringOptionalResponse &&
    
        other.stringOptional == stringOptional 
    
    );
    }
    @override
    int get hashCode =>
    
        stringOptional.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'stringOptional':
            
                
                    stringOptional
                
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestGetStringOptional extends Requestable {
    

    RequestGetStringOptional(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetStringOptional {
  stringOptional
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetStringOptional'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetStringOptionalNode extends Node {
  GetStringOptionalResponse? _obj;
  GetStringOptionalNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetStringOptionalResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = GetStringOptionalResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = GetStringOptionalResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetStringOptionalResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------