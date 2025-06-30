














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetTaskResponse{

    /// class members
    
        
            final String task_id;   
        
    
    // keywordargs constructor
    GetTaskResponse({
    required
        this.task,
    
    });
    static GetTaskResponse fromJson(JsonObject data) {
    
        
            final GetTask_task task_value;
            
                task_value = GetTask_task.fromJson(data['task']);            
            
        
    
    return GetTaskResponse(
    
        
        task: task_value,
    
    );
    }
    GetTaskResponse updateWithJson(JsonObject data) {
    
        
        final GetTask_task task_value;
        if (data.containsKey('task')) {
            
                task_value = GetTask_task.fromJson(data['task']);
            
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
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            
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
    

    RequestGetTask(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetTask {
  task {
    id
    name
    status
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetTask'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetTaskNode extends Node {
  GetTaskResponse? obj = null;
  GetTaskNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = GetTaskResponse.fromJson(raw);
      manager.addOrUpdateNode(this);
     } else {
      throw Exception("must subscribe to node through manager");
     }
  }

  @override
  void updateWithJson(JsonObject newData) {
    final newObj = obj?.updateWithJson(newData);
    if (newObj != null) {
      obj = newObj;
      notifyListeners();
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }

  @override
  void convertToObjAndSet(JsonObject data) {
     obj = GetTaskResponse.fromJson(data);
  }
  
  @override
  JsonObject data() {
    final data = obj?.toJson();
    if (data != null) {
        return data;
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }
} 
// ------------ END Node DEFINITIONS -------------