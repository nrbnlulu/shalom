





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class UpdatePointWithInputNonNullResponse {

    /// class members
    
        final UpdatePointWithInputNonNull_updatePointWithInput? updatePointWithInput;
    
    // keywordargs constructor
    UpdatePointWithInputNonNullResponse({
    
        this.updatePointWithInput,
    
    });
    static UpdatePointWithInputNonNullResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final UpdatePointWithInputNonNull_updatePointWithInput? updatePointWithInput_value;
        final updatePointWithInput$raw = data["updatePointWithInput"];
        updatePointWithInput_value = 
    
           
            
                updatePointWithInput$raw == null ? null : UpdatePointWithInputNonNull_updatePointWithInput.fromJson(updatePointWithInput$raw, context)
            
        
    
;
    
    return UpdatePointWithInputNonNullResponse(
    
        
        updatePointWithInput: updatePointWithInput_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointWithInputNonNullResponse &&
    
        
    
        other.updatePointWithInput == updatePointWithInput
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointWithInput.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'updatePointWithInput':
            
                
    
        
            this.updatePointWithInput?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdatePointWithInputNonNull_updatePointWithInput  {
        
    /// class members
    
        final rmhlxei.Point? coords;
    
        final String name;
    
        final String id;
    
    // keywordargs constructor
    UpdatePointWithInputNonNull_updatePointWithInput({
    
        this.coords,
    required
        this.name,
    required
        this.id,
    
    });
    static UpdatePointWithInputNonNull_updatePointWithInput fromJson(JsonObject data, ShalomContext? context) {
    
        
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
    
    return UpdatePointWithInputNonNull_updatePointWithInput(
    
        
        coords: coords_value,
    
        
        name: name_value,
    
        
        id: id_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointWithInputNonNull_updatePointWithInput &&
    
        
    
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


class RequestUpdatePointWithInputNonNull extends Requestable {
    
    final UpdatePointWithInputNonNullVariables variables;
    

    RequestUpdatePointWithInputNonNull(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation UpdatePointWithInputNonNull($pointData: PointDataInput!) {
  updatePointWithInput(pointData: $pointData) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'UpdatePointWithInputNonNull'
        );
    }
}


class UpdatePointWithInputNonNullVariables {
    
    
        final PointDataInput pointData;
    

    UpdatePointWithInputNonNullVariables (
        
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

    
UpdatePointWithInputNonNullVariables updateWith(
    {
        
            
                PointDataInput? pointData
            
            
        
    }
) {
    
        final PointDataInput pointData$next;
        
            if (pointData != null) {
                pointData$next = pointData;
            } else {
                pointData$next = this.pointData;
            }
        
    
    return UpdatePointWithInputNonNullVariables(
        
            pointData: pointData$next
            
        
    );
}


}
