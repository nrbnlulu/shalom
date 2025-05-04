
import "schema.shalom.dart";

import 'dart:convert';
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetTask{

    /// class members
    
        
            final GetTask_task task;
        
    
    // keywordargs constructor
    GetTask({
    required
        this.task,
    
    });
    static GetTask fromJson(JsonObject data) {
    
        
            final GetTask_task task_value;
            
                task_value = GetTask_task.fromJson(data['task']);            
            
        
    
    return GetTask(
    
        
        task: task_value,
    
    );
    }
    GetTask updateWithJson(JsonObject data) {
    
        
        final GetTask_task task_value;
        if (data.containsKey('task')) {
            
                task_value = GetTask_task.fromJson(data['task']);            
            
        } else {
            task_value = task;
        }
        
    
    return GetTask(
    
        
        task: task_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTask &&
    
        other.task == task 
    
    );
    }
    @override
    int get hashCode =>
    
        task.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'task':
            
                task.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetTask_task  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final Status status;
        
    
    // keywordargs constructor
    GetTask_task({
    required
        this.id,
    required
        this.name,
    required
        this.status,
    
    });
    static GetTask_task fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            
            final Status status_value;
            
                status_value = Status.fromString(data['status']);            
            
        
    
    return GetTask_task(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        status: status_value,
    
    );
    }
    GetTask_task updateWithJson(JsonObject data) {
    
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'];
            } else {
            id_value = id;
            }
        
    
        
            final String name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            
            final Status status_value;
            if (data.containsKey('status')) {
                
                    status_value = Status.fromString(data['status']);            
                
            } else {
                status_value = status;
            }
        
    
    return GetTask_task(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        status: status_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTask_task &&
    
        other.id == id &&
    
        other.name == name &&
    
        other.status == status 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            status,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                id
            
        ,
    
        
        'name':
            
                name
            
        ,
    
        
        'status':
            
                status.name  
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------

class RequestGetTask extends Requestable {
    final GetTask operation;
    final GetTaskVariables variables;

    RequestGetTask({
        required this.operation,  
        required this.variables,
    });

    Request toRequest() {
        final jsonEncoder = JsonEncoder();
        String queryString = jsonEncoder.convert(operation.toJson()); 
        return Request(
            query: queryString, 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: "GetTask"
        );
    }
}


class GetTaskVariables {
    

    GetTaskVariables(
        
    );

    JsonObject toJson() {
        return {
              
        };
    } 
}


