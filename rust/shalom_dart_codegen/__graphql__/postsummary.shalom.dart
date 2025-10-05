

















// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PostSummary

import 'package:shalom_core/shalom_core.dart';







class PostSummary {
    
    final String id;
    
    final String title;
    
    final String?? publishedAt;
    

    const PostSummary({
        
        required this.id,
        
        required this.title,
        
        this.publishedAt,
        
    });

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is PostSummary &&
        runtimeType == other.runtimeType &&
        
        id == other.id &&
        
        title == other.title &&
        
        publishedAt == other.publishedAt
        ;

    @override
    int get hashCode =>
        
        id.hashCode ^
        
        title.hashCode ^
        
        publishedAt.hashCode
        ;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {};
        
        
        
            
                
                data["id"] = id;
                
            
        
        
        
        
            
                
                data["title"] = title;
                
            
        
        
        
        
            
            if (publishedAt != null) {
                
                data["publishedAt"] = publishedAt;
                
            }
            
        
        
        return data;
    }
}












PostSummary PostSummaryFromCache(Map<String, dynamic> cacheData) {
    
    return PostSummary(
        
        
        
            
            id:
                
                cacheData["id"] as String,
                
            
        
        
        
        
            
            title:
                
                cacheData["title"] as String,
                
            
        
        
        
        
            
            publishedAt: cacheData["publishedAt"] == null ? null :
                
                cacheData["publishedAt"] as String?,
                
            
        
        
    );
    
}













void PostSummaryNormalize$InCache(PostSummary data, ShalomDataNormalizer normalizer) {
    
    
    
    
    
    
    
    
    
    
    
    
}











