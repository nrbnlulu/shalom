





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class updatePointWithOptCoordsResponse {

    /// class members
    
            
            final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords;
        
    
    // keywordargs constructor
    updatePointWithOptCoordsResponse({
    
        this.updatePointWithOptCoords,
    
    });
    
    
        updatePointWithOptCoordsResponse updateWithJson(JsonObject data) {
        
            
            final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords_value;
            if (data.containsKey('updatePointWithOptCoords')) {
                final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
                updatePointWithOptCoords_value = 
    
        
            updatePointWithOptCoords$raw == null ? null : updatePointWithOptCoords_updatePointWithOptCoords.fromJson(updatePointWithOptCoords$raw)
        
    
;
            } else {
                updatePointWithOptCoords_value = updatePointWithOptCoords;
            }
        
        return updatePointWithOptCoordsResponse(
        
            
            updatePointWithOptCoords: updatePointWithOptCoords_value,
        
        );
        }
    
    static updatePointWithOptCoordsResponse fromJson(JsonObject data) {
    
        
        final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords_value;
        final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
        updatePointWithOptCoords_value = 
    
        
            updatePointWithOptCoords$raw == null ? null : updatePointWithOptCoords_updatePointWithOptCoords.fromJson(updatePointWithOptCoords$raw)
        
    
;
    
    return updatePointWithOptCoordsResponse(
    
        
        updatePointWithOptCoords: updatePointWithOptCoords_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is updatePointWithOptCoordsResponse &&
    
        
    
        other.updatePointWithOptCoords == updatePointWithOptCoords
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointWithOptCoords.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'updatePointWithOptCoords':
            
                
    
        
            this.updatePointWithOptCoords?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class updatePointWithOptCoords_updatePointWithOptCoords  {
        
    /// class members
    
            
            final rmhlxei.Point? coords;
        
    
            
            final String name;
        
    
            
            final String id;
        
    
    // keywordargs constructor
    updatePointWithOptCoords_updatePointWithOptCoords({
    
        this.coords,
    required
        this.name,
    required
        this.id,
    
    });
    
    
        updatePointWithOptCoords_updatePointWithOptCoords updateWithJson(JsonObject data) {
        
            
            final rmhlxei.Point? coords_value;
            if (data.containsKey('coords')) {
                final coords$raw = data["coords"];
                coords_value = 
    
        
            
            
                coords$raw == null ? null : rmhlxei.pointScalarImpl.deserialize(coords$raw)
            
        
    
;
            } else {
                coords_value = coords;
            }
        
            
            final String name_value;
            if (data.containsKey('name')) {
                final name$raw = data["name"];
                name_value = 
    
        
            
                name$raw as String
            
        
    
;
            } else {
                name_value = name;
            }
        
            
            final String id_value;
            if (data.containsKey('id')) {
                final id$raw = data["id"];
                id_value = 
    
        
            
                id$raw as String
            
        
    
;
            } else {
                id_value = id;
            }
        
        return updatePointWithOptCoords_updatePointWithOptCoords(
        
            
            coords: coords_value,
        
            
            name: name_value,
        
            
            id: id_value,
        
        );
        }
    
    static updatePointWithOptCoords_updatePointWithOptCoords fromJson(JsonObject data) {
    
        
        final rmhlxei.Point? coords_value;
        final coords$raw = data["coords"];
        coords_value = 
    
        
            
            
                coords$raw == null ? null : rmhlxei.pointScalarImpl.deserialize(coords$raw)
            
        
    
;
    
        
        final String name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String
            
        
    
;
    
        
        final String id_value;
        final id$raw = data["id"];
        id_value = 
    
        
            
                id$raw as String
            
        
    
;
    
    return updatePointWithOptCoords_updatePointWithOptCoords(
    
        
        coords: coords_value,
    
        
        name: name_value,
    
        
        id: id_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is updatePointWithOptCoords_updatePointWithOptCoords &&
    
        
    
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


class RequestupdatePointWithOptCoords extends Requestable {
    
    final updatePointWithOptCoordsVariables variables;
    

    RequestupdatePointWithOptCoords(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation updatePointWithOptCoords($pointData: PointDataOptCoordsInput!) {
  updatePointWithOptCoords(pointData: $pointData) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'updatePointWithOptCoords'
        );
    }
}


class updatePointWithOptCoordsVariables {
    
    
        final PointDataOptCoordsInput pointData;
    

    updatePointWithOptCoordsVariables (
        
            {
            

    
        
            required this.pointData
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["pointData"] = 
    
        
            this.pointData.toJson()
        
    
;
    


        return data;
    }

    
updatePointWithOptCoordsVariables updateWith(
    {
        
            
                PointDataOptCoordsInput? pointData
            
            
        
    }
) {
    
        final PointDataOptCoordsInput pointData$next;
        
            if (pointData != null) {
                pointData$next = pointData;
            } else {
                pointData$next = this.pointData;
            }
        
    
    return updatePointWithOptCoordsVariables(
        
            pointData: pointData$next
            
        
    );
}


}
