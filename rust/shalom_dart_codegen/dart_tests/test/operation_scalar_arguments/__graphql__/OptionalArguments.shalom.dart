






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OptionalArgumentsResponse{

    
    /// class members
    
        final OptionalArguments_updateUser? updateUser;
    
    // keywordargs constructor
    OptionalArgumentsResponse({
    
        this.updateUser,
    
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
            final updateUserNormalized$Key = "updateUser";
            final updateUser$cached = this$NormalizedRecord[updateUserNormalized$Key];
            final updateUser$raw = data["updateUser"];
            if (updateUser$raw != null){
                
                    OptionalArguments_updateUser.updateCachePrivate(
                        updateUser$raw as JsonObject,
                        ctx,
                        this$fieldName: updateUserNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateUser") && updateUser$cached != null){
                    this$NormalizedRecord[updateUserNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalArgumentsResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateUser$raw = data["updateUser"];
            final OptionalArguments_updateUser? updateUser$value = 
    
        
            updateUser$raw == null ? null :
        
    
;
        return OptionalArgumentsResponse(
            updateUser: updateUser$value,
            
        );
    }
    static OptionalArgumentsResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "updateUser",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "updateUser")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalArgumentsResponse &&
    
        
    
        other.updateUser == updateUser
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateUser.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateUser':
            
                
    
        
            this.updateUser?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OptionalArguments  {
        
    
    /// class members
    
        final OptionalArguments_updateUser? updateUser;
    
    // keywordargs constructor
    OptionalArguments({
    
        this.updateUser,
    
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
            final updateUserNormalized$Key = "updateUser";
            final updateUser$cached = this$NormalizedRecord[updateUserNormalized$Key];
            final updateUser$raw = data["updateUser"];
            if (updateUser$raw != null){
                
                    OptionalArguments_updateUser.updateCachePrivate(
                        updateUser$raw as JsonObject,
                        ctx,
                        this$fieldName: updateUserNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("updateUser") && updateUser$cached != null){
                    this$NormalizedRecord[updateUserNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalArguments fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateUser$raw = data["updateUser"];
            final OptionalArguments_updateUser? updateUser$value = 
    
        
            updateUser$raw == null ? null :
        
    
;
        return OptionalArguments(
            updateUser: updateUser$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalArguments &&
    
        
    
        other.updateUser == updateUser
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        updateUser.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'updateUser':
            
                
    
        
            this.updateUser?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OptionalArguments_updateUser  {
        
    
    /// class members
    
        final String? name;
    
    // keywordargs constructor
    OptionalArguments_updateUser({
    
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
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final nameNormalized$Key = "name";
            final name$cached = this$NormalizedRecord[nameNormalized$Key];
            final name$raw = data["name"];
            if (name$raw != null){
                
                    if (name$cached != name$raw){
                        
                    }
                    this$NormalizedRecord[nameNormalized$Key] = name$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("name") && name$cached != null){
                    this$NormalizedRecord[nameNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalArguments_updateUser fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final name$raw = data["name"];
            final String? name$value = 
    
        
            
                name$raw as String?
            
        
    
;
        return OptionalArguments_updateUser(
            name: name$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalArguments_updateUser &&
    
        
    
        other.name == name
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        name.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestOptionalArguments extends Requestable {
    
    final OptionalArgumentsVariables variables;
    

    RequestOptionalArguments(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OptionalArguments($id: ID, $phone: String) {
  updateUser(id: $id, phone: $phone) {
    name
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OptionalArguments'
        );
    }
}


class OptionalArgumentsVariables {
    
    
        final Option<String?> id;
    
        final Option<String?> phone;
    

    OptionalArgumentsVariables (
        
            {
            

    
        
            this.id = const None()
        ,
    
    
    
        
            this.phone = const None()
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (id.isSome()) {
            final value = this.id.some();
            data["id"] = 
    
        value
    
;
        }
    

    
    
        if (phone.isSome()) {
            final value = this.phone.some();
            data["phone"] = 
    
        value
    
;
        }
    


        return data;
    }

    
OptionalArgumentsVariables updateWith(
    {
        
            
                Option<Option<String?>> id = const None()
            
            ,
        
            
                Option<Option<String?>> phone = const None()
            
            
        
    }
) {
    
        final Option<String?> id$next;
        
            switch (id) {

                case Some(value: final updateData):
                    id$next = updateData;
                case None():
                    id$next = this.id;
            }

        
    
        final Option<String?> phone$next;
        
            switch (phone) {

                case Some(value: final updateData):
                    phone$next = updateData;
                case None():
                    phone$next = this.phone;
            }

        
    
    return OptionalArgumentsVariables(
        
            id: id$next
            ,
        
            phone: phone$next
            
        
    );
}


}
