




























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../graphql/__graphql__/schema.shalom.dart";




import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports















































// ------------ OBJECT DEFINITIONS -------------

    class UpdateUserMutation_updateUser   {
        
    static String G__typename = "User";
    
    
    /// class members
    final 
        String
     id;
        
    final 
        String
     name;
        
    

    // Getter for typename (public accessor for static __typename field)
    String get $__typename => G__typename;

    // keywordargs constructor
     UpdateUserMutation_updateUser(
        {
                required this.id,
        
        
                required this.name,
        }
        
    );

    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is UpdateUserMutation_updateUser &&
                    
    
        
            id == other.id
        
    
 &&
                    
    
        
            name == other.name
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                id,
        
                name,
        
        UpdateUserMutation_updateUser.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
        
    
        
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
        
    
    };
    }

    shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    
        
        'id': 
    
        
            shalom_core.shalomJsonValue(this.id!)
        
    
,
        
    
        
        'name': 
    
        
            shalom_core.shalomJsonValue(this.name!)
        
    
,
        
    
    });

    static UpdateUserMutation_updateUser fromJson(shalom_core.JsonObject data) {
        final 
        String
     id$value = 
    
        
            
                data['id'] as String
            
        
    
;
        final 
        String
     name$value = 
    
        
            
                data['name'] as String
            
        
    
;
        return UpdateUserMutation_updateUser(
            
                    id: id$value,
                
            
                    name: name$value,
                
            );
    }

    static UpdateUserMutation_updateUser fromShalomValue(shalom_core.ShalomJsonValue data) {
        final shalom_core.ShalomJsonValue? id$raw = data.field('id');
            final 
        String
     id$value = 
    
        
            id$raw!.stringValue
        
    
;
        final shalom_core.ShalomJsonValue? name$raw = data.field('name');
            final 
        String
     name$value = 
    
        
            name$raw!.stringValue
        
    
;
        return UpdateUserMutation_updateUser(
            id: id$value,
            name: name$value,
            );
    }

    }


// ------------ END OBJECT DEFINITIONS -------------

// ------------ UNION DEFINITIONS -------------


// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------


// ------------ MUTATION DATA + VARIABLES -------------

final class UpdateUserMutationData implements shalom_core.MutationInterface {
    final UpdateUserMutation_updateUser? updateUser;
    

    const UpdateUserMutationData({
        required this.updateUser,
        
    });

    @override
    String operation$Name() => 'UpdateUserMutation';
    
    static UpdateUserMutationData fromCache(shalom_core.JsonObject data) {
        final UpdateUserMutation_updateUser? updateUser$value = 
    
        
            data['updateUser'] == null ? null :
        UpdateUserMutation_updateUser.fromJson(data['updateUser'] as shalom_core.JsonObject)
    
;
        return UpdateUserMutationData(
            
                    updateUser: updateUser$value,
                
            );
    }

    static UpdateUserMutationData fromShalomValue(shalom_core.ShalomJsonValue data) {
        final shalom_core.ShalomJsonValue? updateUser$raw = data.field('updateUser');
            final UpdateUserMutation_updateUser? updateUser$value = 
    updateUser$raw == null || updateUser$raw!.isNull ? null :
        
        UpdateUserMutation_updateUser.fromShalomValue(updateUser$raw!)
    
;
        return UpdateUserMutationData(
            updateUser: updateUser$value,
            );
    }

    shalom_core.JsonObject toJson() {
        return {
            
                
                
                    'updateUser':
                        
                            
    
        
            this.updateUser?.toJson()
        
    

                        
                    ,
                
            
        };
    }

    @override
    shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
        
            'updateUser': 
    this.updateUser == null ? shalom_core.shalomJsonValue(null) :
    
        this.updateUser!.toShalomValue()
    
,
        
    });
}


final class UpdateUserMutationVariables {
    
    
    
        final String id;
    
        final String name;
    

    const UpdateUserMutationVariables(
        {
        
    
        required this.id
            
    
,
            
    
        required this.name
            
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
data["id"] = 
    
        this.id
    
;
    data["name"] = 
    
        this.name
    
;
    
        return data;
    }

    shalom_core.ShalomJsonValue toShalomValue() {
        final $data = <String, shalom_core.ShalomJsonValue>{};
$data["id"] = 
        shalom_core.shalomJsonValue(this.id!)
    
;
    $data["name"] = 
        shalom_core.shalomJsonValue(this.name!)
    
;
    return shalom_core.shalomJsonObject($data);

    }

    @override
    bool operator ==(Object other) {
        return identical(this, other) || (other is UpdateUserMutationVariables
            
                && 
                    this.id == other.id
                
            
                && 
                    this.name == other.name
                
            
        );
    }

    @override
    int get hashCode => Object.hashAll([
        
            id,
        
            name,
        
    ]);
}


// ------------ END MUTATION DATA + VARIABLES -------------