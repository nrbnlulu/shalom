import 'Objects.shalom.dart';
// ignore_for_file: non_constant_identifier_names



class 
RequestGetUser
{



/// class memberes

final User user;



// keywordargs constructor

RequestGetUser
({
    
        required this.user,
    
});


static 
RequestGetUser
 fromJson(Map<String, dynamic> data) {
    
        
    

  return 
RequestGetUser
(
    
        user: user_value,
    
    );
}



RequestGetUser
 updateWithJson(Map<String, dynamic> data) {
    
    
    

  return 
RequestGetUser
(
    
    user: user_value,
    
    );
}

@override
bool operator==(Object other){
    if (other is! 
RequestGetUser
) return false;
    
    
    
    return true;
}

@override
int get hashCode => 
    
        user.hashCode;
    

Map<String, dynamic> toJson() {
    return {
        
        'user': user,
        
    };
}


}