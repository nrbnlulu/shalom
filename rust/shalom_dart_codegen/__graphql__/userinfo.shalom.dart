

















// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: UserInfo

import 'package:shalom_core/shalom_core.dart';







class UserInfo {
    
    final String id;
    
    final String name;
    
    final String email;
    
    final int?? age;
    

    const UserInfo({
        
        required this.id,
        
        required this.name,
        
        required this.email,
        
        this.age,
        
    });

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is UserInfo &&
        runtimeType == other.runtimeType &&
        
        id == other.id &&
        
        name == other.name &&
        
        email == other.email &&
        
        age == other.age
        ;

    @override
    int get hashCode =>
        
        id.hashCode ^
        
        name.hashCode ^
        
        email.hashCode ^
        
        age.hashCode
        ;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {};
        
        
        
            
                
                data["id"] = id;
                
            
        
        
        
        
            
                
                data["name"] = name;
                
            
        
        
        
        
            
                
                data["email"] = email;
                
            
        
        
        
        
            
            if (age != null) {
                
                data["age"] = age;
                
            }
            
        
        
        return data;
    }
}














UserInfo UserInfoFromCache(Map<String, dynamic> cacheData) {
    
    return UserInfo(
        
        
        
            
            id:
                
                cacheData["id"] as String,
                
            
        
        
        
        
            
            name:
                
                cacheData["name"] as String,
                
            
        
        
        
        
            
            email:
                
                cacheData["email"] as String,
                
            
        
        
        
        
            
            age: cacheData["age"] == null ? null :
                
                cacheData["age"] as int?,
                
            
        
        
    );
    
}















void UserInfoNormalize$InCache(UserInfo data, ShalomDataNormalizer normalizer) {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}













