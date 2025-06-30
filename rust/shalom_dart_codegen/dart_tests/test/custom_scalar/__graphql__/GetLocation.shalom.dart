














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../point.dart' as uomtoe;


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetLocationResponse{

    /// class members
    
        
            final String getLocation_id;   
        
    
    // keywordargs constructor
    GetLocationResponse({
    
        this.getLocation,
    
    });
    static GetLocationResponse fromJson(JsonObject data) {
    
        
            final GetLocation_getLocation? getLocation_value;
            
                final JsonObject? getLocation$raw = data['getLocation']; 
                if (getLocation$raw != null) {
                    getLocation_value = GetLocation_getLocation.fromJson(getLocation$raw);
                } else {
                    getLocation_value = null;
                }
            
        
    
    return GetLocationResponse(
    
        
        getLocation: getLocation_value,
    
    );
    }
    GetLocationResponse updateWithJson(JsonObject data) {
    
        
        final GetLocation_getLocation? getLocation_value;
        if (data.containsKey('getLocation')) {
            
                final JsonObject? getLocation$raw = data['getLocation'];
                if (getLocation$raw != null) {
                    getLocation_value = GetLocation_getLocation.fromJson(getLocation$raw);
                } else {
                    getLocation_value = null;
                }
            
        } else {
            getLocation_value = getLocation;
        }

    
    
    return GetLocationResponse(
    
        
        getLocation: getLocation_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetLocationResponse &&
    
        other.getLocation == getLocation 
    
    );
    }
    @override
    int get hashCode =>
    
        getLocation.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getLocation':
            
                getLocation?.toJson()
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------


    class GetLocation_getLocation  {
        
    /// class members
    
        
            final String id;
        
    
        
            final uomtoe.Point? coords;
        
    
    // keywordargs constructor
    GetLocation_getLocation({
    required
        this.id,
    
        this.coords,
    
    });
    static GetLocation_getLocation fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final uomtoe.Point? coords_value;
            
                
                coords_value = data['coords'] == null
                  ? null
                  : uomtoe.pointScalarImpl.deserialize(data['coords']);
            

        
    
    return GetLocation_getLocation(
    
        
        id: id_value,
    
        
        coords: coords_value,
    
    );
    }
    GetLocation_getLocation updateWithJson(JsonObject data) {
    
        
    final String id_value;
    if (data.containsKey('id')) {
        
            id_value = data['id'];
        
    } else {
        id_value = id;
    }

        
    
        
    final uomtoe.Point? coords_value;
    if (data.containsKey('coords')) {
        
            
            coords_value = data['coords'] == null
                ? null
                : uomtoe.pointScalarImpl.deserialize(data['coords']);
        
    } else {
        coords_value = coords;
    }

        
    
    return GetLocation_getLocation(
    
        
        id: id_value,
    
        
        coords: coords_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetLocation_getLocation &&
    
        other.id == id &&
    
        other.coords == coords 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            coords,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
                    id
                
            
        ,
    
        
        'coords':
            
                
                    
                    coords == null ? null : uomtoe.pointScalarImpl.serialize(coords!)
                
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetLocation extends Requestable {
    

    RequestGetLocation(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetLocation {
  getLocation {
    id
    coords
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetLocation'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetLocationNode extends Node {
  GetLocationResponse? obj = null;
  GetLocationNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetLocationResponse.fromJson(raw);
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
     obj = GetLocationResponse.fromJson(data);
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