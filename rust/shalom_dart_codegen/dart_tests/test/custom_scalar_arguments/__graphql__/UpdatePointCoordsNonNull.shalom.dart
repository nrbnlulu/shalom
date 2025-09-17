






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class UpdatePointCoordsNonNullResponse{

    
    /// class members
    
        final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords;
    
    // keywordargs constructor
    UpdatePointCoordsNonNullResponse({
    
        this.updatePointCoords,
    
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
            final updatePointCoordsNormalized$Key = "updatePointCoords";
            final updatePointCoords$cached = this$NormalizedRecord[updatePointCoordsNormalized$Key];
            final updatePointCoords$raw = data["updatePointCoords"];
            if (updatePointCoords$raw != null){
                
                    UpdatePointCoordsNonNull_updatePointCoords.updateCachePrivate(
                        updatePointCoords$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointCoordsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointCoords") && updatePointCoords$cached != null){
                    this$NormalizedRecord[updatePointCoordsNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsNonNullResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointCoords$raw = data["updatePointCoords"];
            final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords$value = 
    
        
            updatePointCoords$raw == null ? null :
        
    
;
        return UpdatePointCoordsNonNullResponse(
            updatePointCoords: updatePointCoords$value,
            
        );
    }
    static UpdatePointCoordsNonNullResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updatePointCoords",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "updatePointCoords")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsNonNullResponse &&
    
        
    
        other.updatePointCoords == updatePointCoords
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointCoords.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updatePointCoords':
            
                
    
        
            this.updatePointCoords?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdatePointCoordsNonNull  {
        
    
    /// class members
    
        final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords;
    
    // keywordargs constructor
    UpdatePointCoordsNonNull({
    
        this.updatePointCoords,
    
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
            final updatePointCoordsNormalized$Key = "updatePointCoords";
            final updatePointCoords$cached = this$NormalizedRecord[updatePointCoordsNormalized$Key];
            final updatePointCoords$raw = data["updatePointCoords"];
            if (updatePointCoords$raw != null){
                
                    UpdatePointCoordsNonNull_updatePointCoords.updateCachePrivate(
                        updatePointCoords$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointCoordsNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointCoords") && updatePointCoords$cached != null){
                    this$NormalizedRecord[updatePointCoordsNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsNonNull fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointCoords$raw = data["updatePointCoords"];
            final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords$value = 
    
        
            updatePointCoords$raw == null ? null :
        
    
;
        return UpdatePointCoordsNonNull(
            updatePointCoords: updatePointCoords$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsNonNull &&
    
        
    
        other.updatePointCoords == updatePointCoords
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointCoords.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updatePointCoords':
            
                
    
        
            this.updatePointCoords?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class UpdatePointCoordsNonNull_updatePointCoords  {
        
    
    /// class members
    
        final rmhlxei.Point? coords;
    
        final String name;
    
        final String id;
    
    // keywordargs constructor
    UpdatePointCoordsNonNull_updatePointCoords({
    
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
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
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

    static UpdatePointCoordsNonNull_updatePointCoords fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return UpdatePointCoordsNonNull_updatePointCoords(
            coords: coords$value,
            name: name$value,
            id: id$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsNonNull_updatePointCoords &&
    
        
    
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


class RequestUpdatePointCoordsNonNull extends Requestable {
    
    final UpdatePointCoordsNonNullVariables variables;
    

    RequestUpdatePointCoordsNonNull(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation UpdatePointCoordsNonNull($coords: Point!) {
  updatePointCoords(coords: $coords) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'UpdatePointCoordsNonNull'
        );
    }
}


class UpdatePointCoordsNonNullVariables {
    
    
        final rmhlxei.Point coords;
    

    UpdatePointCoordsNonNullVariables (
        
            {
            

    
        
            required this.coords
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["coords"] = 
    
        
        
            rmhlxei.pointScalarImpl.serialize(this.coords)
        
    
;
    


        return data;
    }

    
UpdatePointCoordsNonNullVariables updateWith(
    {
        
            
                rmhlxei.Point? coords
            
            
        
    }
) {
    
        final rmhlxei.Point coords$next;
        
            if (coords != null) {
                coords$next = coords;
            } else {
                coords$next = this.coords;
            }
        
    
    return UpdatePointCoordsNonNullVariables(
        
            coords: coords$next
            
        
    );
}


}
