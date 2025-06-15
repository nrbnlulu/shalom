// ignore_for_file: constant_identifier_names











import 'package:shalom_core/shalom_core.dart';


// ------------ Enum DEFINITIONS -------------

     
     
     enum Status  {
          
                COMPLETED ,
          
                PROCESSING ,
          
                SENT ;
          
          
          static Status fromString(String name) {
              switch (name) {
                  
                  case 'COMPLETED':
                    return Status.COMPLETED;                   
                  case 'PROCESSING':
                    return Status.PROCESSING;                   
                  case 'SENT':
                    return Status.SENT;                   
                  default:  
                      throw ArgumentError.value(name, 'name', 'No Status enum member with this name');  
              }
          }

      }

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------


class OrderUpdate {
    
    
        final Status status; 
    
        final int timeLeft; 
    
    OrderUpdate(
        {
        

    
        
            required this.status  
        ,
    
    
    
        
            required this.timeLeft  
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        
            
                data["status"] = status.name;
            
        
    

    
    
        
            data["timeLeft"] = timeLeft; 
        
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
    
        final Status status_value;
        
                status_value = Status.fromString(data['status']);
        
    

    
    
    
        final int timeLeft_value;
         
                timeLeft_value = data['timeLeft'];
        
    

    return OrderUpdate (
        
           status: status_value,
        
           timeLeft: timeLeft_value,
        
    );

    }
}
     


class OrderUpdateStatusOpt {
    
    
        final Option<Status?> status; 
    
        final int timeLeft; 
    
    OrderUpdateStatusOpt(
        {
        

    
         
            this.status = const None() 
        ,
    
    
    
        
            required this.timeLeft  
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (status.isSome()) {
            
                data["status"] = status.some()?.name;
            
        } 
    

    
    
        
            data["timeLeft"] = timeLeft; 
        
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
    
        final Option<Status?> status_value;
          
            final String? status$raw = data['status'];
            if (status$raw != null) {
                
                    status_value = Some(Status.fromString(status$raw));
                
            } else {
                
                    status_value = None();
                
            }
        
    

    
    
    
        final int timeLeft_value;
         
                timeLeft_value = data['timeLeft'];
        
    

    return OrderUpdateStatusOpt (
        
           status: status_value,
        
           timeLeft: timeLeft_value,
        
    );

    }
}
     

// ------------ END Input DEFINITIONS -------------