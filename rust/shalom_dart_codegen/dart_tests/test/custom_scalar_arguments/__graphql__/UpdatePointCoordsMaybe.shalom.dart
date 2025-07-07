
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class UpdatePointCoordsMaybeResponse{

    /// class members
    
        final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe;
    
    // keywordargs constructor
    UpdatePointCoordsMaybeResponse({
    
        this.updatePointCoordsMaybe,
    
    });
    static UpdatePointCoordsMaybeResponse fromJson(JsonObject data) {
    
        
        final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe_value;
        
            updatePointCoordsMaybe_value = 
    
        
            data["updatePointCoordsMaybe"] == null ? null : UpdatePointCoordsMaybe_updatePointCoordsMaybe.fromJson(data["updatePointCoordsMaybe"])
        
    
;
        
    
    return UpdatePointCoordsMaybeResponse(
    
        
        updatePointCoordsMaybe: updatePointCoordsMaybe_value,
    
    );
    }
    UpdatePointCoordsMaybeResponse updateWithJson(JsonObject data) {
    
        
        final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe_value;
        if (data.containsKey('updatePointCoordsMaybe')) {
            
                updatePointCoordsMaybe_value = 
    
        
            data["updatePointCoordsMaybe"] == null ? null : UpdatePointCoordsMaybe_updatePointCoordsMaybe.fromJson(data["updatePointCoordsMaybe"])
        
    
;
            
        } else {
            updatePointCoordsMaybe_value = updatePointCoordsMaybe;
        }
    
    return UpdatePointCoordsMaybeResponse(
    
        
        updatePointCoordsMaybe: updatePointCoordsMaybe_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsMaybeResponse &&
    
        
    
        other.updatePointCoordsMaybe == updatePointCoordsMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointCoordsMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updatePointCoordsMaybe':
            
                
    
        
            this.updatePointCoordsMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdatePointCoordsMaybe_updatePointCoordsMaybe  {
        
    /// class members
    
        final rmhlxei.Point? coords;
    
        final String name;
    
        final String id;
    
    // keywordargs constructor
    UpdatePointCoordsMaybe_updatePointCoordsMaybe({
    
        this.coords,
    required
        this.name,
    required
        this.id,
    
    });
    static UpdatePointCoordsMaybe_updatePointCoordsMaybe fromJson(JsonObject data) {
    
        
        final rmhlxei.Point? coords_value;
        
            coords_value = 
    
        
            
            
                data["coords"] == null ? null : rmhlxei.pointScalarImpl.deserialize(data["coords"])
            
        
    
;
        
    
        
        final String name_value;
        
            name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
        
    
        
        final String id_value;
        
            id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
        
    
    return UpdatePointCoordsMaybe_updatePointCoordsMaybe(
    
        
        coords: coords_value,
    
        
        name: name_value,
    
        
        id: id_value,
    
    );
    }
    UpdatePointCoordsMaybe_updatePointCoordsMaybe updateWithJson(JsonObject data) {
    
        
        final rmhlxei.Point? coords_value;
        if (data.containsKey('coords')) {
            
                coords_value = 
    
        
            
            
                data["coords"] == null ? null : rmhlxei.pointScalarImpl.deserialize(data["coords"])
            
        
    
;
            
        } else {
            coords_value = coords;
        }
    
        
        final String name_value;
        if (data.containsKey('name')) {
            
                name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
            
        } else {
            name_value = name;
        }
    
        
        final String id_value;
        if (data.containsKey('id')) {
            
                id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
            
        } else {
            id_value = id;
        }
    
    return UpdatePointCoordsMaybe_updatePointCoordsMaybe(
    
        
        coords: coords_value,
    
        
        name: name_value,
    
        
        id: id_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsMaybe_updatePointCoordsMaybe &&
    
        
    
        other.coords == coords
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.id == id
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            coords,
        
            
            name,
        
            
            id,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'coords':
            
                
    
        
            
            
                this.coords == null ? null : rmhlxei.pointScalarImpl.serialize(this.coords!)
            
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestUpdatePointCoordsMaybe extends Requestable {
    
    final UpdatePointCoordsMaybeVariables variables;
    

    RequestUpdatePointCoordsMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation UpdatePointCoordsMaybe($coords: Point) {
  updatePointCoordsMaybe(coords: $coords) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            StringopName: 'UpdatePointCoordsMaybe'
        );
    }
}


class UpdatePointCoordsMaybeVariables {
    
    
        final Option<rmhlxei.Point?> coords;
    

    UpdatePointCoordsMaybeVariables (
        
            {
            

    
        
            this.coords = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (coords.isSome()) {
            final value = this.coords.some();
            data["coords"] = 
    
        
        
            value == null ? null : rmhlxei.pointScalarImpl.serialize(value!)
        
    
;
        }
    


        return data;
    }

    
UpdatePointCoordsMaybeVariables updateWith(
    {
        
            
                Option<Option<rmhlxei.Point?>> coords = const None()
            
            
        
    }
) {
    
        final Option<rmhlxei.Point?> coords$next;
        
            switch (coords) {

                case Some(value: final updateData):
                    coords$next = updateData;
                case None():
                    coords$next = this.coords;
            }

        
    
    return UpdatePointCoordsMaybeVariables(
        
            coords: coords$next
            
        
    );
}


}
