// ------------ Enum DEFINITIONS -------------

     
     enum Status  {
            
                COMPLETED,
            
                FAILED,
            
                PENDING,
            
                PROCESSING,
          ;
          
          static Status fromString(String name) {
              switch (name) {
                  
                  case 'COMPLETED':
                    return Status.COMPLETED; 
                  
                  case 'FAILED':
                    return Status.FAILED; 
                  
                  case 'PENDING':
                    return Status.PENDING; 
                  
                  case 'PROCESSING':
                    return Status.PROCESSING; 
                  
                  default:  
                      throw ArgumentError.value(name, 'name', 'No Status enum member with this name');  
              }
          }

          @override
          String toString() => name.toUpperCase();
      }

// ------------ END Enum DEFINITIONS -------------