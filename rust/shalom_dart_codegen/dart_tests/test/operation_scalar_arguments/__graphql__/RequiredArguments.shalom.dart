






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class RequiredArgumentsResponse{

    
    /// class members
    
        final RequiredArguments_product? product;
    
    // keywordargs constructor
    RequiredArgumentsResponse({
    
        this.product,
    
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
            final productNormalized$Key = "product";
            final product$cached = this$NormalizedRecord[productNormalized$Key];
            final product$raw = data["product"];
            if (product$raw != null){
                
                    RequiredArguments_product.updateCachePrivate(
                        product$raw as JsonObject,
                        ctx,
                        this$fieldName: productNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("product") && product$cached != null){
                    this$NormalizedRecord[productNormalized$Key] = null;
                    
                }
            }

        
    }

    static RequiredArgumentsResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final product$raw = data["product"];
            final RequiredArguments_product? product$value = 
    
        
            product$raw == null ? null :
        
    
;
        return RequiredArgumentsResponse(
            product: product$value,
            
        );
    }
    static RequiredArgumentsResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "product",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "product")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is RequiredArgumentsResponse &&
    
        
    
        other.product == product
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        product.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'product':
            
                
    
        
            this.product?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class RequiredArguments  {
        
    
    /// class members
    
        final RequiredArguments_product? product;
    
    // keywordargs constructor
    RequiredArguments({
    
        this.product,
    
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
            final productNormalized$Key = "product";
            final product$cached = this$NormalizedRecord[productNormalized$Key];
            final product$raw = data["product"];
            if (product$raw != null){
                
                    RequiredArguments_product.updateCachePrivate(
                        product$raw as JsonObject,
                        ctx,
                        this$fieldName: productNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("product") && product$cached != null){
                    this$NormalizedRecord[productNormalized$Key] = null;
                    
                }
            }

        
    }

    static RequiredArguments fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final product$raw = data["product"];
            final RequiredArguments_product? product$value = 
    
        
            product$raw == null ? null :
        
    
;
        return RequiredArguments(
            product: product$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is RequiredArguments &&
    
        
    
        other.product == product
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        product.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'product':
            
                
    
        
            this.product?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class RequiredArguments_product  {
        
    
    /// class members
    
        final String id;
    
        final String name;
    
    // keywordargs constructor
    RequiredArguments_product({
    required
        this.id,
    required
        this.name,
    
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

        
    }

    static RequiredArguments_product fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final id$raw = data["id"];
            final String id$value = 
    
        
            
                id$raw as String
            
        
    
;
        
            final name$raw = data["name"];
            final String name$value = 
    
        
            
                name$raw as String
            
        
    
;
        return RequiredArguments_product(
            id: id$value,
            name: name$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is RequiredArguments_product &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestRequiredArguments extends Requestable {
    
    final RequiredArgumentsVariables variables;
    

    RequestRequiredArguments(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query RequiredArguments($id: ID!) {
  product(id: $id) {
    id
    name
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'RequiredArguments'
        );
    }
}


class RequiredArgumentsVariables {
    
    
        final String id;
    

    RequiredArgumentsVariables (
        
            {
            

    
        
            required this.id
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    


        return data;
    }

    
RequiredArgumentsVariables updateWith(
    {
        
            
                String? id
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
    return RequiredArgumentsVariables(
        
            id: id$next
            
        
    );
}


}
