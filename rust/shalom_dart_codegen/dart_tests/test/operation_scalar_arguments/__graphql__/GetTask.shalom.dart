
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetTaskResponse{

    /// class members
    
        
            final GetTask_task? task;
        
    
    // keywordargs constructor
    GetTaskResponse({
    
        this.task,
    
    });
    static GetTaskResponse fromJson(JsonObject data) {
    
        
            final GetTask_task? task_value;
            
                final JsonObject? task$raw = data['task']; 
                if (task$raw != null) {
                    task_value = GetTask_task.fromJson(task$raw);
                } else {
                    task_value = null;
                }
            
        
    
    return GetTaskResponse(
    
        
        task: task_value,
    
    );
    }
    GetTaskResponse updateWithJson(JsonObject data) {
    
        
        final GetTask_task? task_value;
        if (data.containsKey('task')) {
            
                final JsonObject? task$raw = data['task']; 
                if (task$raw != null) {
                    task_value = GetTask_task.fromJson(task$raw);
                } else {
                    task_value = null;
                }
            
        } else {
            task_value = task;
        }
        
    
    return GetTaskResponse(
    
        
        task: task_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTaskResponse &&
    
        other.task == task 
    
    );
    }
    @override
    int get hashCode =>
    
        task.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'task':
            
                task?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetTask_task  {
        
    /// class members
    
        
            final String? name;
        
    
        
            final int? duration;
        
    
        
            final bool? is_easy;
        
    
    // keywordargs constructor
    GetTask_task({
    
        this.name,
    
        this.duration,
    
        this.is_easy,
    
    });
    static GetTask_task fromJson(JsonObject data) {
    
        
            final String? name_value = data['name'];
        
    
        
            final int? duration_value = data['duration'];
        
    
        
            final bool? is_easy_value = data['is_easy'];
        
    
    return GetTask_task(
    
        
        name: name_value,
    
        
        duration: duration_value,
    
        
        is_easy: is_easy_value,
    
    );
    }
    GetTask_task updateWithJson(JsonObject data) {
    
        
            final String? name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final int? duration_value;
            if (data.containsKey('duration')) {
            duration_value = data['duration'];
            } else {
            duration_value = duration;
            }
        
    
        
            final bool? is_easy_value;
            if (data.containsKey('is_easy')) {
            is_easy_value = data['is_easy'];
            } else {
            is_easy_value = is_easy;
            }
        
    
    return GetTask_task(
    
        
        name: name_value,
    
        
        duration: duration_value,
    
        
        is_easy: is_easy_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetTask_task &&
    
        other.name == name &&
    
        other.duration == duration &&
    
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
            
                name
            
        ,
    
        
        'duration':
            
                duration
            
        ,
    
        
        'is_easy':
            
                is_easy
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetTask extends Requestable {
    
    final GetTaskVariables variables;
    

    RequestGetTask(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetTask($name: String = "shalom", $duration: Int = 2, $is_easy: Boolean = false) {
  task(name: $name, duration: $duration, is_easy: $is_easy) {
    name
    duration
    is_easy
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetTask'
        );
    }
}


class GetTaskVariables {
    
        final int? duration;
    
        final bool? is_easy;
    
        final String? name;
    

    GetTaskVariables(
        
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
        
           
              data["duration"] = duration; 
           
        
           
              data["is_easy"] = is_easy; 
           
        
           
              data["name"] = name; 
           
        
        return data;
    } 
}
