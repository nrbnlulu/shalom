





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../point.dart' as uomtoe;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetLocationResponse {

    /// class members
    
            
            final GetLocation_getLocation? getLocation;
        
    
    // keywordargs constructor
    GetLocationResponse({
    
        this.getLocation,
    
    });
    static GetLocationResponse fromJson(JsonObject data) {
    
        
        final GetLocation_getLocation? getLocation_value;
        final getLocation$raw = data["getLocation"];
        getLocation_value = 
    
        
            getLocation$raw == null ? null : GetLocation_getLocation.fromJson(getLocation$raw)
        
    
;
    
    return GetLocationResponse(
    
        
        getLocation: getLocation_value,
    
    );
    }
    
    
        GetLocationResponse updateWithJson(JsonObject data) {
        
            
            final GetLocation_getLocation? getLocation_value;
            if (data.containsKey('getLocation')) {
                final getLocation$raw = data["getLocation"];
                getLocation_value = 
    
        
            getLocation$raw == null ? null : GetLocation_getLocation.fromJson(getLocation$raw)
        
    
;
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
            
                
    
        
            this.getLocation?.toJson()
        
    

            
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
        final id$raw = data["id"];
        id_value = 
    
        
            
                id$raw as String
            
        
    
;
    
        
        final uomtoe.Point? coords_value;
        final coords$raw = data["coords"];
        coords_value = 
    
        
            
            
                coords$raw == null ? null : uomtoe.pointScalarImpl.deserialize(coords$raw)
            
        
    
;
    
    return GetLocation_getLocation(
    
        
        id: id_value,
    
        
        coords: coords_value,
    
    );
    }
    
    
        GetLocation_getLocation updateWithJson(JsonObject data) {
        
            
            final String id_value;
            if (data.containsKey('id')) {
                final id$raw = data["id"];
                id_value = 
    
        
            
                id$raw as String
            
        
    
;
            } else {
                id_value = id;
            }
        
            
            final uomtoe.Point? coords_value;
            if (data.containsKey('coords')) {
                final coords$raw = data["coords"];
                coords_value = 
    
        
            
            
                coords$raw == null ? null : uomtoe.pointScalarImpl.deserialize(coords$raw)
            
        
    
;
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
    
        
    
        other.id == id
    
 &&
    
        
    
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
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'coords':
            
                
    
        
            
            
                this.coords == null ? null : uomtoe.pointScalarImpl.serialize(this.coords!)
            
        
    

            
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
            opName: 'GetLocation'
        );
    }
}

