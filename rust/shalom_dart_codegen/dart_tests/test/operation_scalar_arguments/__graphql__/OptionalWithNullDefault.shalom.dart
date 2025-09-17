






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OptionalWithNullDefaultResponse{

    
    /// class members
    
        final OptionalWithNullDefault_updateUser? updateUser;
    
    // keywordargs constructor
    OptionalWithNullDefaultResponse({
    
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
                
                    OptionalWithNullDefault_updateUser.updateCachePrivate(
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

    static OptionalWithNullDefaultResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateUser$raw = data["updateUser"];
            final OptionalWithNullDefault_updateUser? updateUser$value = 
    
        
            updateUser$raw == null ? null :
        
    
;
        return OptionalWithNullDefaultResponse(
            updateUser: updateUser$value,
            
        );
    }
    static OptionalWithNullDefaultResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
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
    (other is OptionalWithNullDefaultResponse &&
    
        
    
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


    class OptionalWithNullDefault  {
        
    
    /// class members
    
        final OptionalWithNullDefault_updateUser? updateUser;
    
    // keywordargs constructor
    OptionalWithNullDefault({
    
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
                
                    OptionalWithNullDefault_updateUser.updateCachePrivate(
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

    static OptionalWithNullDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final updateUser$raw = data["updateUser"];
            final OptionalWithNullDefault_updateUser? updateUser$value = 
    
        
            updateUser$raw == null ? null :
        
    
;
        return OptionalWithNullDefault(
            updateUser: updateUser$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithNullDefault &&
    
        
    
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

    class OptionalWithNullDefault_updateUser  {
        
    
    /// class members
    
        final String? email;
    
        final String? name;
    
        final String? phone;
    
    // keywordargs constructor
    OptionalWithNullDefault_updateUser({
    
        this.email,
    
        this.name,
    
        this.phone,
    
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
            final emailNormalized$Key = "email";
            final email$cached = this$NormalizedRecord[emailNormalized$Key];
            final email$raw = data["email"];
            if (email$raw != null){
                
                    if (email$cached != email$raw){
                        
                    }
                    this$NormalizedRecord[emailNormalized$Key] = email$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("email") && email$cached != null){
                    this$NormalizedRecord[emailNormalized$Key] = null;
                    
                }
            }

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

        // TODO: handle arguments
            final phoneNormalized$Key = "phone";
            final phone$cached = this$NormalizedRecord[phoneNormalized$Key];
            final phone$raw = data["phone"];
            if (phone$raw != null){
                
                    if (phone$cached != phone$raw){
                        
                    }
                    this$NormalizedRecord[phoneNormalized$Key] = phone$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("phone") && phone$cached != null){
                    this$NormalizedRecord[phoneNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalWithNullDefault_updateUser fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final email$raw = data["email"];
            final String? email$value = 
    
        
            
                email$raw as String?
            
        
    
;
        
            final name$raw = data["name"];
            final String? name$value = 
    
        
            
                name$raw as String?
            
        
    
;
        
            final phone$raw = data["phone"];
            final String? phone$value = 
    
        
            
                phone$raw as String?
            
        
    
;
        return OptionalWithNullDefault_updateUser(
            email: email$value,
            name: name$value,
            phone: phone$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithNullDefault_updateUser &&
    
        
    
        other.email == email
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.phone == phone
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            email,
        
            
            name,
        
            
            phone,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'email':
            
                
    
        
            this.email
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'phone':
            
                
    
        
            this.phone
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestOptionalWithNullDefault extends Requestable {
    
    final OptionalWithNullDefaultVariables variables;
    

    RequestOptionalWithNullDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation OptionalWithNullDefault($phone: String = null) {
  updateUser(phone: $phone) {
    email
    name
    phone
  }
}""",
            variables: variablesJson,
            opType: OperationType.Mutation,
            opName: 'OptionalWithNullDefault'
        );
    }
}


class OptionalWithNullDefaultVariables {
    
    
        final String? phone;
    

    OptionalWithNullDefaultVariables (
        
            {
            

    
        
            
            
                this.phone
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["phone"] = 
    
        this.phone
    
;
    


        return data;
    }

    
OptionalWithNullDefaultVariables updateWith(
    {
        
            
                Option<String?> phone = const None()
            
            
        
    }
) {
    
        final String? phone$next;
        
            switch (phone) {

                case Some(value: final updateData):
                    phone$next = updateData;
                case None():
                    phone$next = this.phone;
            }

        
    
    return OptionalWithNullDefaultVariables(
        
            phone: phone$next
            
        
    );
}


}
