






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class OptionalWithSomeDefaultResponse{

    
    /// class members
    
        final OptionalWithSomeDefault_task? task;
    
    // keywordargs constructor
    OptionalWithSomeDefaultResponse({
    
        this.task,
    
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
            final taskNormalized$Key = "task";
            final task$cached = this$NormalizedRecord[taskNormalized$Key];
            final task$raw = data["task"];
            if (task$raw != null){
                
                    OptionalWithSomeDefault_task.updateCachePrivate(
                        task$raw as JsonObject,
                        ctx,
                        this$fieldName: taskNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("task") && task$cached != null){
                    this$NormalizedRecord[taskNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalWithSomeDefaultResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final task$raw = data["task"];
            final OptionalWithSomeDefault_task? task$value = 
    
        
            task$raw == null ? null :
        
    
;
        return OptionalWithSomeDefaultResponse(
            task: task$value,
            
        );
    }
    static OptionalWithSomeDefaultResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "task",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "task")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithSomeDefaultResponse &&
    
        
    
        other.task == task
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        task.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'task':
            
                
    
        
            this.task?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class OptionalWithSomeDefault  {
        
    
    /// class members
    
        final OptionalWithSomeDefault_task? task;
    
    // keywordargs constructor
    OptionalWithSomeDefault({
    
        this.task,
    
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
            final taskNormalized$Key = "task";
            final task$cached = this$NormalizedRecord[taskNormalized$Key];
            final task$raw = data["task"];
            if (task$raw != null){
                
                    OptionalWithSomeDefault_task.updateCachePrivate(
                        task$raw as JsonObject,
                        ctx,
                        this$fieldName: taskNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("task") && task$cached != null){
                    this$NormalizedRecord[taskNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalWithSomeDefault fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final task$raw = data["task"];
            final OptionalWithSomeDefault_task? task$value = 
    
        
            task$raw == null ? null :
        
    
;
        return OptionalWithSomeDefault(
            task: task$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithSomeDefault &&
    
        
    
        other.task == task
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        task.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'task':
            
                
    
        
            this.task?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class OptionalWithSomeDefault_task  {
        
    
    /// class members
    
        final String? name;
    
        final int? duration;
    
        final bool? is_easy;
    
    // keywordargs constructor
    OptionalWithSomeDefault_task({
    
        this.name,
    
        this.duration,
    
        this.is_easy,
    
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

        // TODO: handle arguments
            final durationNormalized$Key = "duration";
            final duration$cached = this$NormalizedRecord[durationNormalized$Key];
            final duration$raw = data["duration"];
            if (duration$raw != null){
                
                    if (duration$cached != duration$raw){
                        
                    }
                    this$NormalizedRecord[durationNormalized$Key] = duration$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("duration") && duration$cached != null){
                    this$NormalizedRecord[durationNormalized$Key] = null;
                    
                }
            }

        // TODO: handle arguments
            final is_easyNormalized$Key = "is_easy";
            final is_easy$cached = this$NormalizedRecord[is_easyNormalized$Key];
            final is_easy$raw = data["is_easy"];
            if (is_easy$raw != null){
                
                    if (is_easy$cached != is_easy$raw){
                        
                    }
                    this$NormalizedRecord[is_easyNormalized$Key] = is_easy$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("is_easy") && is_easy$cached != null){
                    this$NormalizedRecord[is_easyNormalized$Key] = null;
                    
                }
            }

        
    }

    static OptionalWithSomeDefault_task fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final name$raw = data["name"];
            final String? name$value = 
    
        
            
                name$raw as String?
            
        
    
;
        
            final duration$raw = data["duration"];
            final int? duration$value = 
    
        
            
                duration$raw as int?
            
        
    
;
        
            final is_easy$raw = data["is_easy"];
            final bool? is_easy$value = 
    
        
            
                is_easy$raw as bool?
            
        
    
;
        return OptionalWithSomeDefault_task(
            name: name$value,
            duration: duration$value,
            is_easy: is_easy$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is OptionalWithSomeDefault_task &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.duration == duration
    
 &&
    
        
    
        other.is_easy == is_easy
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            name,
        
            
            duration,
        
            
            is_easy,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'duration':
            
                
    
        
            this.duration
        
    

            
        ,
    
        
        'is_easy':
            
                
    
        
            this.is_easy
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestOptionalWithSomeDefault extends Requestable {
    
    final OptionalWithSomeDefaultVariables variables;
    

    RequestOptionalWithSomeDefault(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query OptionalWithSomeDefault($name: String = "shalom", $duration: Int = 2, $is_easy: Boolean = false) {
  task(name: $name, duration: $duration, is_easy: $is_easy) {
    name
    duration
    is_easy
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'OptionalWithSomeDefault'
        );
    }
}


class OptionalWithSomeDefaultVariables {
    
    
        final int? duration;
    
        final bool? is_easy;
    
        final String? name;
    

    OptionalWithSomeDefaultVariables (
        
            {
            

    
        
            
            
                this.duration = 2
            
        ,
    
    
    
        
            
            
                this.is_easy = false
            
        ,
    
    
    
        
            
            
                this.name = "shalom"
            
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["duration"] = 
    
        this.duration
    
;
    

    
    
        data["is_easy"] = 
    
        this.is_easy
    
;
    

    
    
        data["name"] = 
    
        this.name
    
;
    


        return data;
    }

    
OptionalWithSomeDefaultVariables updateWith(
    {
        
            
                Option<int?> duration = const None()
            
            ,
        
            
                Option<bool?> is_easy = const None()
            
            ,
        
            
                Option<String?> name = const None()
            
            
        
    }
) {
    
        final int? duration$next;
        
            switch (duration) {

                case Some(value: final updateData):
                    duration$next = updateData;
                case None():
                    duration$next = this.duration;
            }

        
    
        final bool? is_easy$next;
        
            switch (is_easy) {

                case Some(value: final updateData):
                    is_easy$next = updateData;
                case None():
                    is_easy$next = this.is_easy;
            }

        
    
        final String? name$next;
        
            switch (name) {

                case Some(value: final updateData):
                    name$next = updateData;
                case None():
                    name$next = this.name;
            }

        
    
    return OptionalWithSomeDefaultVariables(
        
            duration: duration$next
            ,
        
            is_easy: is_easy$next
            ,
        
            name: name$next
            
        
    );
}


}
