






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class UpdatePointCoordsOptResponse{

    
    /// class members
    
        final UpdatePointCoordsOpt_getPointById? getPointById;
    
    // keywordargs constructor
    UpdatePointCoordsOptResponse({
    
        this.getPointById,
    
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
            final getPointByIdNormalized$Key = "getPointById";
            final getPointById$cached = this$NormalizedRecord[getPointByIdNormalized$Key];
            final getPointById$raw = data["getPointById"];
            if (getPointById$raw != null){
                
                    UpdatePointCoordsOpt_getPointById.updateCachePrivate(
                        getPointById$raw as JsonObject,
                        ctx,
                        this$fieldName: getPointByIdNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getPointById") && getPointById$cached != null){
                    this$NormalizedRecord[getPointByIdNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsOptResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getPointById$raw = data["getPointById"];
            final UpdatePointCoordsOpt_getPointById? getPointById$value = 
    
        
            getPointById$raw == null ? null :
        
    
;
        return UpdatePointCoordsOptResponse(
            getPointById: getPointById$value,
            
        );
    }
    static UpdatePointCoordsOptResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "getPointById",
                this$data: getOrCreateObject(updateCtx.getCachedObjectRecord("ROOT_QUERY"), "getPointById")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsOptResponse &&
    
        
    
        other.getPointById == getPointById
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getPointById.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getPointById':
            
                
    
        
            this.getPointById?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class UpdatePointCoordsOpt  {
        
    
    /// class members
    
        final UpdatePointCoordsOpt_getPointById? getPointById;
    
    // keywordargs constructor
    UpdatePointCoordsOpt({
    
        this.getPointById,
    
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
            final getPointByIdNormalized$Key = "getPointById";
            final getPointById$cached = this$NormalizedRecord[getPointByIdNormalized$Key];
            final getPointById$raw = data["getPointById"];
            if (getPointById$raw != null){
                
                    UpdatePointCoordsOpt_getPointById.updateCachePrivate(
                        getPointById$raw as JsonObject,
                        ctx,
                        this$fieldName: getPointByIdNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getPointById") && getPointById$cached != null){
                    this$NormalizedRecord[getPointByIdNormalized$Key] = null;
                    
                }
            }

        
    }

    static UpdatePointCoordsOpt fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getPointById$raw = data["getPointById"];
            final UpdatePointCoordsOpt_getPointById? getPointById$value = 
    
        
            getPointById$raw == null ? null :
        
    
;
        return UpdatePointCoordsOpt(
            getPointById: getPointById$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsOpt &&
    
        
    
        other.getPointById == getPointById
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getPointById.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getPointById':
            
                
    
        
            this.getPointById?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class UpdatePointCoordsOpt_getPointById  {
        
    
    /// class members
    
        final rmhlxei.Point? coords;
    
        final String name;
    
        final String id;
    
    // keywordargs constructor
    UpdatePointCoordsOpt_getPointById({
    
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

    static UpdatePointCoordsOpt_getPointById fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
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
        return UpdatePointCoordsOpt_getPointById(
            coords: coords$value,
            name: name$value,
            id: id$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is UpdatePointCoordsOpt_getPointById &&
    
        
    
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


class RequestUpdatePointCoordsOpt extends Requestable {
    
    final UpdatePointCoordsOptVariables variables;
    

    RequestUpdatePointCoordsOpt(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query UpdatePointCoordsOpt($id: ID!, $coords: Point = "POINT (0,0)") {
  getPointById(id: $id, coords: $coords) {
    coords
    name
    id
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'UpdatePointCoordsOpt'
        );
    }
}


class UpdatePointCoordsOptVariables {
    
    
        final rmhlxei.Point? coords;
    
        final String id;
    

    UpdatePointCoordsOptVariables (
        
            {
            

    
        
            
            
                this.coords
            
        ,
    
    
    
        
            required this.id
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["coords"] = 
    
        
        
            this.coords == null ? null : rmhlxei.pointScalarImpl.serialize(this.coords!)
        
    
;
    

    
    
        data["id"] = 
    
        this.id
    
;
    


        return data;
    }

    
UpdatePointCoordsOptVariables updateWith(
    {
        
            
                Option<rmhlxei.Point?> coords = const None()
            
            ,
        
            
                String? id
            
            
        
    }
) {
    
        final rmhlxei.Point? coords$next;
        
            switch (coords) {

                case Some(value: final updateData):
                    coords$next = updateData;
                case None():
                    coords$next = this.coords;
            }

        
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
    return UpdatePointCoordsOptVariables(
        
            coords: coords$next
            ,
        
            id: id$next
            
        
    );
}


}
