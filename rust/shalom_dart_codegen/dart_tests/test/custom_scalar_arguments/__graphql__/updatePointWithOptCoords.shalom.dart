






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class updatePointWithOptCoordsResponse{

    
    /// class members
    
        final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords;
    
    // keywordargs constructor
    updatePointWithOptCoordsResponse({
    
        this.updatePointWithOptCoords,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final updatePointWithOptCoordsNormalized$Key = "updatePointWithOptCoords";
            final updatePointWithOptCoords$cached = this$NormalizedRecord[updatePointWithOptCoordsNormalized$Key];
            final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
            if (updatePointWithOptCoords$raw != null){
                
                    updatePointWithOptCoords_updatePointWithOptCoords.updateCachePrivate(
                        updatePointWithOptCoords$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointWithOptCoordsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointWithOptCoords") && updatePointWithOptCoords$cached != null){
                    this$NormalizedRecord[updatePointWithOptCoordsNormalized$Key] = null;
                    
                }
            }

        
    }

    static updatePointWithOptCoordsResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
            final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords$value = 
    
        
            updatePointWithOptCoords$raw == null ? null :
        
    
;
        return updatePointWithOptCoordsResponse(
            updatePointWithOptCoords: updatePointWithOptCoords$value,
            
        );
    }
    static updatePointWithOptCoordsResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updatePointWithOptCoords",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "updatePointWithOptCoords")
            );
            return fromJsonImpl(data, ctx);
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


    class updatePointWithOptCoords  {
        
    
    /// class members
    
        final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords;
    
    // keywordargs constructor
    updatePointWithOptCoords({
    
        this.updatePointWithOptCoords,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final updatePointWithOptCoordsNormalized$Key = "updatePointWithOptCoords";
            final updatePointWithOptCoords$cached = this$NormalizedRecord[updatePointWithOptCoordsNormalized$Key];
            final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
            if (updatePointWithOptCoords$raw != null){
                
                    updatePointWithOptCoords_updatePointWithOptCoords.updateCachePrivate(
                        updatePointWithOptCoords$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointWithOptCoordsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointWithOptCoords") && updatePointWithOptCoords$cached != null){
                    this$NormalizedRecord[updatePointWithOptCoordsNormalized$Key] = null;
                    
                }
            }

        
    }

    static updatePointWithOptCoords fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointWithOptCoords$raw = data["updatePointWithOptCoords"];
            final updatePointWithOptCoords_updatePointWithOptCoords? updatePointWithOptCoords$value = 
    
        
            updatePointWithOptCoords$raw == null ? null :
        
    
;
        return updatePointWithOptCoords(
            updatePointWithOptCoords: updatePointWithOptCoords$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is updatePointWithOptCoords &&
    
        
    
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

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        final RecordID? this$normalizedID_temp = data["id"] as RecordID?;
            if (this$normalizedID_temp == null) {
                
                    throw UnimplementedError("Required ID cannot be null");
                
            } else {
                this$normalizedID = this$normalizedID_temp as String;
                this$data[this$fieldName] = this$normalizedID;
                ctx.addDependantRecord(this$normalizedID);
                this$NormalizedRecord = ctx.getCachedObjectRecord(this$normalizedID);
                }
        // TODO: handle arguments
            final coordsNormalized$Key = "coords";
            final coords$cached = this$NormalizedRecord[coordsNormalized$Key];
            final coords$raw = data["coords"];
            if (coords$raw != null){
                
                    if (coords$cached != coords$raw){
                        
                            ctx.addChangedRecord(this$normalizedID, coordsNormalized$Key);
                        
                    }
                    this$NormalizedRecord[coordsNormalized$Key] = coords$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("coords") && coords$cached != null){
                    this$NormalizedRecord[coordsNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, coordsNormalized$Key);
                    
                }
            }

        // TODO: handle arguments
            final nameNormalized$Key = "name";
            final name$cached = this$NormalizedRecord[nameNormalized$Key];
            final name$raw = data["name"];
            if (name$raw != null){
                
                    if (name$cached != name$raw){
                        
                            ctx.addChangedRecord(this$normalizedID, nameNormalized$Key);
                        
                    }
                    this$NormalizedRecord[nameNormalized$Key] = name$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("name") && name$cached != null){
                    this$NormalizedRecord[nameNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, nameNormalized$Key);
                    
                }
            }

        // TODO: handle arguments
            final idNormalized$Key = "id";
            final id$cached = this$NormalizedRecord[idNormalized$Key];
            final id$raw = data["id"];
            if (id$raw != null){
                
                    if (id$cached != id$raw){
                        
                            ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                        
                    }
                    this$NormalizedRecord[idNormalized$Key] = id$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("id") && id$cached != null){
                    this$NormalizedRecord[idNormalized$Key] = null;
                    
                        ctx.addChangedRecord(this$normalizedID, idNormalized$Key);
                    
                }
            }

        
    }

    static updatePointWithOptCoords_updatePointWithOptCoords fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final coords$raw = data["coords"];
            final rmhlxei.Point? coords$value = 
    
        
            
            
                coords$raw == null ? null : rmhlxei.pointScalarImpl.deserialize(coords$raw)
            
        
    
;
        
            final name$raw = data["name"];
            final String name$value = 
    
        
            
                name$raw as String
            
        
    
;
        
            final id$raw = data["id"];
            final String id$value = 
    
        
            
                id$raw as String
            
        
    
;
        return updatePointWithOptCoords_updatePointWithOptCoords(
            coords: coords$value,
            name: name$value,
            id: id$value,
            
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
