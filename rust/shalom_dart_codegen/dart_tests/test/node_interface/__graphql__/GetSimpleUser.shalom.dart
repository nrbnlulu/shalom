





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetSimpleUserResponse {

    /// class members
    
        
        GetSimpleUser_user? user;
        
    
    // keywordargs constructor
    GetSimpleUserResponse({
    
        
        
        this.user,
        
    
    
    });
    static GetSimpleUserResponse fromJson(JsonObject data, {ShalomContext? context, List<ID>? parents}) {
    final localParents = parents ?? [];   
    List<ID> currentParents = [...localParents];
    if (data.containsKey('id')) {
        currentParents.add(data['id']);
    }    
    
    
        
        final GetSimpleUser_user? user_value;
        final user$raw = data["user"];
        user_value = 
    
       
            user$raw == null ? null : GetSimpleUser_user.fromJson(user$raw, context, currentParents)
         
    
;
    
    return GetSimpleUserResponse(
    
        
        user: user_value,
    
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSimpleUserResponse &&
    
        
    
        other.user == user
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        user.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'user':
            
                
    
        
            this.user?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetSimpleUser_user  extends Node  {
        
    /// class members
    
        
    
        
        String name;
        
    
        
        String email;
        
    
    // keywordargs constructor
    GetSimpleUser_user({
    
        required
        
        super.id, 
        
    
        required
        
        this.name,
        
    
        required
        
        this.email,
        
    
    
    required super.nodeParents
    
    });
    static GetSimpleUser_user fromJson(JsonObject data, {ShalomContext? context, List<ID>? parents}) {
    final localParents = parents ?? [];   
    List<ID> currentParents = [...localParents];
    if (data.containsKey('id')) {
        currentParents.add(data['id']);
    }    
          
        if (context != null) {
            context.manager.parseNodeData(data);
        }
    
    
        
        final String id_value;
        final id$raw = data["id"];
        id_value = 
    
        
            
                id$raw as String
            
        
    
;
    
        
        final String name_value;
        final name$raw = data["name"];
        name_value = 
    
        
            
                name$raw as String
            
        
    
;
    
        
        final String email_value;
        final email$raw = data["email"];
        email_value = 
    
        
            
                email$raw as String
            
        
    
;
    
    return GetSimpleUser_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
    
    nodeParents: currentParents
    
    );
    }
    
   
         @override
         StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
            return context.manager.register(this, { 
                   
                    
                    'id',
                   
                    
                    'name',
                   
                    
                    'email',
                
                }, context 
            );
         }

         @override
         void updateWithJson(JsonObject rawData, Set<String> changedFields, ShalomContext context) {
            final currentParents = [...nodeParents, id];
            for (final fieldName in changedFields) {
                switch (fieldName) {
                    
                         
                         case 'id':
                            final id$raw = rawData['id'];
                            id = 
    
        
            
                id$raw as String
            
        
    
;
                            break;
                    
                         
                         case 'name':
                            final name$raw = rawData['name'];
                            name = 
    
        
            
                name$raw as String
            
        
    
;
                            break;
                    
                         
                         case 'email':
                            final email$raw = rawData['email'];
                            email = 
    
        
            
                email$raw as String
            
        
    
;
                            break;
                    
                }
            }
            notifyListeners();
         }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSimpleUser_user &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.email == email
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            email,
        
        ]);
    
     @override  
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
        
        'email':
            
                
    
        
            this.email
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetSimpleUser extends Requestable {
    
    final GetSimpleUserVariables variables;
    

    RequestGetSimpleUser(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetSimpleUser($userId: ID!) {
  user(id: $userId) {
    id
    name
    email
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetSimpleUser'
        );
    }
}


class GetSimpleUserVariables {
    
    
        final String userId;
    

    GetSimpleUserVariables (
        
            {
            

    
        
            required this.userId
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["userId"] = 
    
        this.userId
    
;
    


        return data;
    }

    
GetSimpleUserVariables updateWith(
    {
        
            
                String? userId
            
            
        
    }
) {
    
        final String userId$next;
        
            if (userId != null) {
                userId$next = userId;
            } else {
                userId$next = this.userId;
            }
        
    
    return GetSimpleUserVariables(
        
            userId: userId$next
            
        
    );
}


}
