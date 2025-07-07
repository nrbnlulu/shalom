
























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetTaskStatusOptResponse{

    /// class members
    
        final GetTaskStatusOpt_task task;
    
    // keywordargs constructor
    GetTaskStatusOptResponse({
    required
        this.task,
    
    });
    static GetTaskStatusOptResponse fromJson(JsonObject data) {
    
        
        final GetTaskStatusOpt_task task_value;
        
            task_value = 
    
        
            GetTaskStatusOpt_task.fromJson(data["task"])
        
    
;
        
    
    return GetTaskStatusOptResponse(
    
        
        task: task_value,
    
    );
    }
    GetTaskStatusOptResponse updateWithJson(JsonObject data) {
    
        
        final GetTaskStatusOpt_task task_value;
        if (data.containsKey('task')) {
            
                task_value = 
    
        
            GetTaskStatusOpt_task.fromJson(data["task"])
        
    
;
            
        } else {
            task_value = task;
        }
    
    return GetTaskStatusOptResponse(
    
        
        task: task_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTaskStatusOptResponse &&
    
        
    
        other.task == task
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        task.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'task':
            
                
    
        
            this.task.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetTaskStatusOpt_task  {
        
    /// class members
    
        final String id;
    
        final String name;
    
        final Status? statusOpt;
    
    // keywordargs constructor
    GetTaskStatusOpt_task({
    required
        this.id,
    required
        this.name,
    
        this.statusOpt,
    
    });
    static GetTaskStatusOpt_task fromJson(JsonObject data) {
    
        
        final String id_value;
        
            id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
        
    
        
        final String name_value;
        
            name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
        
    
        
        final Status? statusOpt_value;
        
            statusOpt_value = 
    
        
        
            data["statusOpt"] == null ? null : Status.fromString(data["statusOpt"])
        
    
;
        
    
    return GetTaskStatusOpt_task(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        statusOpt: statusOpt_value,
    
    );
    }
    GetTaskStatusOpt_task updateWithJson(JsonObject data) {
    
        
        final String id_value;
        if (data.containsKey('id')) {
            
                id_value = 
    
        
            
                data["id"] as 
    String

            
        
    
;
            
        } else {
            id_value = id;
        }
    
        
        final String name_value;
        if (data.containsKey('name')) {
            
                name_value = 
    
        
            
                data["name"] as 
    String

            
        
    
;
            
        } else {
            name_value = name;
        }
    
        
        final Status? statusOpt_value;
        if (data.containsKey('statusOpt')) {
            
                statusOpt_value = 
    
        
        
            data["statusOpt"] == null ? null : Status.fromString(data["statusOpt"])
        
    
;
            
        } else {
            statusOpt_value = statusOpt;
        }
    
    return GetTaskStatusOpt_task(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        statusOpt: statusOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTaskStatusOpt_task &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.statusOpt == statusOpt
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            statusOpt,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'statusOpt':
            
                
    
        
            this.statusOpt?.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetTaskStatusOpt extends Requestable {
    

    RequestGetTaskStatusOpt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetTaskStatusOpt {
  task {
    id
    name
    statusOpt
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            StringopName: 'GetTaskStatusOpt'
        );
    }
}

