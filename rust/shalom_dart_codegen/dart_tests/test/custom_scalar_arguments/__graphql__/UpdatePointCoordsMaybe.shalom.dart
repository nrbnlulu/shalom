






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

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
            final updatePointCoordsMaybeNormalized$Key = "updatePointCoordsMaybe";
            final updatePointCoordsMaybe$cached = this$NormalizedRecord[updatePointCoordsMaybeNormalized$Key];
            final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
            if (updatePointCoordsMaybe$raw != null){
                
                    UpdatePointCoordsMaybe_updatePointCoordsMaybe.updateCachePrivate(
                        updatePointCoordsMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointCoordsMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointCoordsMaybe") && updatePointCoordsMaybe$cached != null){
                    this$NormalizedRecord[updatePointCoordsMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsMaybeResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
            final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe$value = 
    
        
            updatePointCoordsMaybe$raw == null ? null :
        
    
;
        return UpdatePointCoordsMaybeResponse(
            updatePointCoordsMaybe: updatePointCoordsMaybe$value,
            
        );
    }
    static UpdatePointCoordsMaybeResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updatePointCoordsMaybe",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "updatePointCoordsMaybe")
            );
            return fromJsonImpl(data, ctx);
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


    class UpdatePointCoordsMaybe  {
        
    
    /// class members
    
        final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe;
    
    // keywordargs constructor
    UpdatePointCoordsMaybe({
    
        this.updatePointCoordsMaybe,
    
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
            final updatePointCoordsMaybeNormalized$Key = "updatePointCoordsMaybe";
            final updatePointCoordsMaybe$cached = this$NormalizedRecord[updatePointCoordsMaybeNormalized$Key];
            final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
            if (updatePointCoordsMaybe$raw != null){
                
                    UpdatePointCoordsMaybe_updatePointCoordsMaybe.updateCachePrivate(
                        updatePointCoordsMaybe$raw as JsonObject,
                        ctx,
                        this$fieldName: updatePointCoordsMaybeNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updatePointCoordsMaybe") && updatePointCoordsMaybe$cached != null){
                    this$NormalizedRecord[updatePointCoordsMaybeNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
            final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe$value = 
    
        
            updatePointCoordsMaybe$raw == null ? null :
        
    
;
        return UpdatePointCoordsMaybe(
            updatePointCoordsMaybe: updatePointCoordsMaybe$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsMaybe &&
    
        
    
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

    static UpdatePointCoordsMaybe_updatePointCoordsMaybe fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return UpdatePointCoordsMaybe_updatePointCoordsMaybe(
            coords: coords$value,
            name: name$value,
            id: id$value,
            
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
            opName: 'UpdatePointCoordsMaybe'
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
