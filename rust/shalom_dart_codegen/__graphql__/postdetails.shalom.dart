

















// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PostDetails

import 'package:shalom_core/shalom_core.dart';







class PostDetails {
    
    final String id;
    
    final String title;
    
    final String content;
    
    final String?? publishedAt;
    
    final PostDetails_author author;
    

    const PostDetails({
        
        required this.id,
        
        required this.title,
        
        required this.content,
        
        this.publishedAt,
        
        required this.author,
        
    });

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is PostDetails &&
        runtimeType == other.runtimeType &&
        
        id == other.id &&
        
        title == other.title &&
        
        content == other.content &&
        
        publishedAt == other.publishedAt &&
        
        author == other.author
        ;

    @override
    int get hashCode =>
        
        id.hashCode ^
        
        title.hashCode ^
        
        content.hashCode ^
        
        publishedAt.hashCode ^
        
        author.hashCode
        ;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {};
        
        
        
            
                
                data["id"] = id;
                
            
        
        
        
        
            
                
                data["title"] = title;
                
            
        
        
        
        
            
                
                data["content"] = content;
                
            
        
        
        
        
            
            if (publishedAt != null) {
                
                data["publishedAt"] = publishedAt;
                
            }
            
        
        
        
        
            
            data["author"] = author.toJson();
            
        
        
        return data;
    }
}




class PostDetails_author {
    

    const PostDetails_author({
        
    });

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is PostDetails_author &&
        runtimeType == other.runtimeType &&
        ;

    @override
    int get hashCode =>
        ;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {};
        
        return data;
    }
}














PostDetails PostDetailsFromCache(Map<String, dynamic> cacheData) {
    
    return PostDetails(
        
        
        
            
            id:
                
                cacheData["id"] as String,
                
            
        
        
        
        
            
            title:
                
                cacheData["title"] as String,
                
            
        
        
        
        
            
            content:
                
                cacheData["content"] as String,
                
            
        
        
        
        
            
            publishedAt: cacheData["publishedAt"] == null ? null :
                
                cacheData["publishedAt"] as String?,
                
            
        
        
        
        
            
            author: PostDetails_authorFromCache(cacheData["author"]),
            
        
        
    );
    
}






PostDetails_author PostDetails_authorFromCache(Map<String, dynamic> cacheData) {
    return PostDetails_author(
        
    );
}













void PostDetailsNormalize$InCache(PostDetails data, ShalomDataNormalizer normalizer) {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
        
        
        
        
        PostDetails_authorNormalize$InCache(data.author, normalizer);
        
    
    
    
}






void PostDetails_authorNormalize$InCache(PostDetails_author data, ShalomDataNormalizer normalizer) {
    
}











