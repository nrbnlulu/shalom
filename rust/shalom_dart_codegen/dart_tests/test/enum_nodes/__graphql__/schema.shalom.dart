// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages





















// ------------ Enum DEFINITIONS -------------

     
     
     enum Status  {
          
                ACTIVE ,
          
                INACTIVE ,
          
                PENDING ;
          
          
          static Status fromString(String name) {
              switch (name) {
                  
                  case 'ACTIVE':
                    return Status.ACTIVE;                   
                  case 'INACTIVE':
                    return Status.INACTIVE;                   
                  case 'PENDING':
                    return Status.PENDING;                   
                  default:  
                      throw ArgumentError.value(name, 'name', 'No Status enum member with this name');  
              }
          }

      }

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

// ------------ END Input DEFINITIONS -------------