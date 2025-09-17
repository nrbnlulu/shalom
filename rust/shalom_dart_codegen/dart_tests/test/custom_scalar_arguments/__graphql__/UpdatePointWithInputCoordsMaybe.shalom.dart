






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class UpdatePointWithInputCoordsMaybeResponse{

    
    /// class members
    
        final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe? updatePointWithInputCoordsMaybe;
    
    // keywordargs constructor
    UpdatePointWithInputCoordsMaybeResponse({
    
        this.updatePointWithInputCoordsMaybe,
    
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
            final updatePointWithInputCoordsMaybeNormalized$Key = "updatePointWithInputCoordsMaybe";
            final updatePointWithInputCoordsMaybe$cached = this$NormalizedRecord[updatePointWithInputCoordsMaybeNormalized$Key];
            final updatePointWithInputCoordsMaybe$raw = data["updatePointWithInputCoordsMaybe"];
            if (updatePointWithInputCoordsMaybe$raw != null){
                
                    UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.updateCachePrivate(
                        updatePointWithInputCoordsMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointWithInputCoordsMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointWithInputCoordsMaybe") && updatePointWithInputCoordsMaybe$cached != null){
                    this$NormalizedRecord[updatePointWithInputCoordsMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointWithInputCoordsMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointWithInputCoordsMaybe$raw = data["updatePointWithInputCoordsMaybe"];
            final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe? updatePointWithInputCoordsMaybe$value = 
    
        
            updatePointWithInputCoordsMaybe$raw == null ? null :
        
    
;
        return UpdatePointWithInputCoordsMaybeResponse(
            updatePointWithInputCoordsMaybe: updatePointWithInputCoordsMaybe$value,
            
        );
    }
    static UpdatePointWithInputCoordsMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updatePointWithInputCoordsMaybe",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "updatePointWithInputCoordsMaybe")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointWithInputCoordsMaybeResponse &&
    
        
    
        other.updatePointWithInputCoordsMaybe == updatePointWithInputCoordsMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointWithInputCoordsMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updatePointWithInputCoordsMaybe':
            
                
    
        
            this.updatePointWithInputCoordsMaybe?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdatePointWithInputCoordsMaybe  {
        
    
    /// class members
    
        final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe? updatePointWithInputCoordsMaybe;
    
    // keywordargs constructor
    UpdatePointWithInputCoordsMaybe({
    
        this.updatePointWithInputCoordsMaybe,
    
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
            final updatePointWithInputCoordsMaybeNormalized$Key = "updatePointWithInputCoordsMaybe";
            final updatePointWithInputCoordsMaybe$cached = this$NormalizedRecord[updatePointWithInputCoordsMaybeNormalized$Key];
            final updatePointWithInputCoordsMaybe$raw = data["updatePointWithInputCoordsMaybe"];
            if (updatePointWithInputCoordsMaybe$raw != null){
                
                    UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.updateCachePrivate(
                        updatePointWithInputCoordsMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointWithInputCoordsMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointWithInputCoordsMaybe") && updatePointWithInputCoordsMaybe$cached != null){
                    this$NormalizedRecord[updatePointWithInputCoordsMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointWithInputCoordsMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointWithInputCoordsMaybe$raw = data["updatePointWithInputCoordsMaybe"];
            final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe? updatePointWithInputCoordsMaybe$value = 
    
        
            updatePointWithInputCoordsMaybe$raw == null ? null :
        
    
;
        return UpdatePointWithInputCoordsMaybe(
            updatePointWithInputCoordsMaybe: updatePointWithInputCoordsMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointWithInputCoordsMaybe &&
    
        
    
        other.updatePointWithInputCoordsMaybe == updatePointWithInputCoordsMaybe
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updatePointWithInputCoordsMaybe.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updatePointWithInputCoordsMaybe':
            
                
    
        
            this.updatePointWithInputCoordsMaybe?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe  {
        
    
    /// class members
    
        final rmhlxei.Point? coords;
    
        final String name;
    
        final String id;
    
    // keywordargs constructor
    UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe({
    
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

    static UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe(
            coords: coords$value,
            name: name$value,
            id: id$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe &&
    
        
    
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


class RequestUpdatePointWithInputCoordsMaybe extends Requestable {
    
    final UpdatePointWithInputCoordsMaybeVariables variables;
    

    RequestUpdatePointWithInputCoordsMaybe(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation UpdatePointWithInputCoordsMaybe($pointData: PointUpdateCoordsMaybe!) {
  updatePointWithInputCoordsMaybe(pointData: $pointData) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'UpdatePointWithInputCoordsMaybe'
        );
    }
}


class UpdatePointWithInputCoordsMaybeVariables {
    
    
        final PointUpdateCoordsMaybe pointData;
    

    UpdatePointWithInputCoordsMaybeVariables (
        
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

    
UpdatePointWithInputCoordsMaybeVariables updateWith(
    {
        
            
                PointUpdateCoordsMaybe? pointData
            
            
        
    }
) {
    
        final PointUpdateCoordsMaybe pointData$next;
        
            if (pointData != null) {
                pointData$next = pointData;
            } else {
                pointData$next = this.pointData;
            }
        
    
    return UpdatePointWithInputCoordsMaybeVariables(
        
            pointData: pointData$next
            
        
    );
}


}
