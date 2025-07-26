





















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class SubscribeToAllFieldsWithNonNodeParentResponse {

    /// class members
    
        final SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode? userInfoNotNode;
    
    // keywordargs constructor
    SubscribeToAllFieldsWithNonNodeParentResponse({
    
        this.userInfoNotNode,
    
    });
    static SubscribeToAllFieldsWithNonNodeParentResponse fromJson(JsonObject data, ShalomContext? context) {
    
        
        final SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode? userInfoNotNode_value;
        final userInfoNotNode$raw = data["userInfoNotNode"];
        userInfoNotNode_value = 
    
           
            
                userInfoNotNode$raw == null ? null : SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode.fromJson(userInfoNotNode$raw, context)
            
        
    
;
    
    return SubscribeToAllFieldsWithNonNodeParentResponse(
    
        
        userInfoNotNode: userInfoNotNode_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is SubscribeToAllFieldsWithNonNodeParentResponse &&
    
        
    
        other.userInfoNotNode == userInfoNotNode
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        userInfoNotNode.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'userInfoNotNode':
            
                
    
        
            this.userInfoNotNode?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode  {
        
    /// class members
    
        final SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user user;
    
    // keywordargs constructor
    SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode({
    required
        this.user,
    
    });
    static SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode fromJson(JsonObject data, ShalomContext? context) {
    
        
        final SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user user_value;
        final user$raw = data["user"];
        user_value = 
    
        
            if (context != null) {
                
                    SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user.deserialize(user$raw, context)
                
            }
        
    
;
    
    return SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode(
    
        
        user: user_value,
    
    );
    }
    
   
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode &&
    
        
    
        other.user == user
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        user.hashCode;
    
     
    JsonObject toJson() {
    return {
    
        
        'user':
            
                
    
        
            this.user.toJson()
        
    

            
        ,
    
    };
    }

    }

    class SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user  extends Node  {
        
    /// class members
    
        final String id;
    
        final String name;
    
        final String email;
    
        final int? age;
    
    // keywordargs constructor
    SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user({
    required
        this.id,
    required
        this.name,
    required
        this.email,
    
        this.age,
    
    });
    static SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user fromJson(JsonObject data, ShalomContext? context) {
    
        
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
    
        
        final int? age_value;
        final age$raw = data["age"];
        age_value = 
    
        
            
                age$raw as int?
            
        
    
;
    
    return SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        email: email_value,
    
        
        age: age_value,
    
    );
    }
    
   
        static SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user deserialize(JsonObject data, ShalomContext context) {
            final self = SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user.fromJson(data); 
            
            context.manager.parseNodeData(self.toJson());
            
            
                
            
                
            
                
            
                
            
            return self;
         }
         @override
         StreamSubscription<Event> subscribeToChanges(ShalomContext context) {
            return context.manager.register(this, { 
                   
                    
                    'id',
                   
                    
                    'name',
                   
                    
                    'email',
                   
                    
                    'age',
                
                }, context 
            );
         }

         @override
         void updateWithJson(JsonObject rawData, Set<String> changedFields, ShalomContext context) {
            for (final fieldName in changedFields) {
                switch (fieldName) {
                    
                         
                         case 'id':
                            
                                id = rawData['id'];
                            
                            break;
                    
                         
                         case 'name':
                            
                                name = rawData['name'];
                            
                            break;
                    
                         
                         case 'email':
                            
                                email = rawData['email'];
                            
                            break;
                    
                         
                         case 'age':
                            
                                age = rawData['age'];
                            
                            break;
                    
                }
            }
            notifyListeners();
         }
    
    
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is SubscribeToAllFieldsWithNonNodeParent_userInfoNotNode_user &&
    
        
    
        other.id == id
    
 &&
    
        
    
        other.name == name
    
 &&
    
        
    
        other.email == email
    
 &&
    
        
    
        other.age == age
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            email,
        
            
            age,
        
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
    
        
        'age':
            
                
    
        
            this.age
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestSubscribeToAllFieldsWithNonNodeParent extends Requestable {
    

    RequestSubscribeToAllFieldsWithNonNodeParent(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query SubscribeToAllFieldsWithNonNodeParent {
  userInfoNotNode {
    user {
      id
      name
      email
      age
    }
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'SubscribeToAllFieldsWithNonNodeParent'
        );
    }
}

