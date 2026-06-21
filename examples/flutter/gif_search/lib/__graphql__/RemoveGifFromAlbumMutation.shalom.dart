























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../graphql/__graphql__/schema.shalom.dart";




import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Fragment imports









































// ------------ OBJECT DEFINITIONS -------------

    class RemoveGifFromAlbumMutation_removeGifFromAlbum   {
        
    static String G__typename = "Album";
    
    
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
     RemoveGifFromAlbumMutation_removeGifFromAlbum(
        {
                required this.id,
        
        
                required this.name,
        }
        
    );

    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is RemoveGifFromAlbumMutation_removeGifFromAlbum &&
                    
    
        
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
        
        RemoveGifFromAlbumMutation_removeGifFromAlbum.G__typename
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

    static RemoveGifFromAlbumMutation_removeGifFromAlbum fromJson(shalom_core.JsonObject data) {
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
        return RemoveGifFromAlbumMutation_removeGifFromAlbum(
            
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

final class RemoveGifFromAlbumMutationData implements shalom_core.OperationInterface {
    final RemoveGifFromAlbumMutation_removeGifFromAlbum removeGifFromAlbum;
    

    const RemoveGifFromAlbumMutationData({
        required this.removeGifFromAlbum,
        
    });

    @override
    String operation$Name() => 'RemoveGifFromAlbumMutation';
    
    static RemoveGifFromAlbumMutationData fromCache(shalom_core.JsonObject data) {
        final RemoveGifFromAlbumMutation_removeGifFromAlbum removeGifFromAlbum$value = 
    
        RemoveGifFromAlbumMutation_removeGifFromAlbum.fromJson(data['removeGifFromAlbum'] as shalom_core.JsonObject)
    
;
        return RemoveGifFromAlbumMutationData(
            
                    removeGifFromAlbum: removeGifFromAlbum$value,
                
            );
    }

    shalom_core.JsonObject toJson() {
        return {
            
                
                
                    'removeGifFromAlbum':
                        
                            
    
        
            this.removeGifFromAlbum.toJson()
        
    

                        
                    ,
                
            
        };
    }
}


final class RemoveGifFromAlbumMutationVariables {
    
    
    
        final String albumId;
    
        final String gifId;
    

    const RemoveGifFromAlbumMutationVariables(
        {
        
    
        required this.albumId
            
    
,
            
    
        required this.gifId
            
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
data["albumId"] = 
    
        this.albumId
    
;
    data["gifId"] = 
    
        this.gifId
    
;
    
        return data;
    }

    @override
    bool operator ==(Object other) {
        return identical(this, other) || (other is RemoveGifFromAlbumMutationVariables
            
                && 
                    this.albumId == other.albumId
                
            
                && 
                    this.gifId == other.gifId
                
            
        );
    }

    @override
    int get hashCode => Object.hashAll([
        
            albumId,
        
            gifId,
        
    ]);
}


// ------------ END MUTATION DATA + VARIABLES -------------