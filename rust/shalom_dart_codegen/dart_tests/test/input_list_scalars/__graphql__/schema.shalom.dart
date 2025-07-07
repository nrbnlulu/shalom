// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion














import 'package:shalom_core/shalom_core.dart';








// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------


class UserInput {
    
    
        final Option<List<String>?> ids; 
    
        final Option<List<int?>?> scores; 
    
        final List<String> tags; 
    
    UserInput(
        {
        

    
        
            this.ids = const None()
        ,
    
    
    
        
            this.scores = const None()
        ,
    
    
    
        
            required this.tags
        ,
    
    
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        if (ids.isSome()) {
            final value = this.ids.some();
            data["ids"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    

    
    
        if (scores.isSome()) {
            final value = this.scores.some();
            data["scores"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    

    
    
        data["tags"] = 
    
        
        
            this.tags.map((e) => 
    
        e
    
).toList()
        
    
;
    

    
        return data;
    } 
  
UserInput updateWith(
    {
        
            
                Option<Option<List<String>?>> ids = const None()
            
            ,
        
            
                Option<Option<List<int?>?>> scores = const None()
            
            ,
        
            
                List<String>? tags
            
            
        
    }
) {
    
        final Option<List<String>?> ids$next;
        
            switch (ids) {

                case Some(value: final updateData):
                    ids$next = updateData;
                case None():
                    ids$next = this.ids;
            }

        
    
        final Option<List<int?>?> scores$next;
        
            switch (scores) {

                case Some(value: final updateData):
                    scores$next = updateData;
                case None():
                    scores$next = this.scores;
            }

        
    
        final List<String> tags$next;
        
            if (tags != null) {
                tags$next = tags;
            } else {
                tags$next = this.tags;
            }
        
    
    return UserInput(
        
            ids: ids$next
            ,
        
            scores: scores$next
            ,
        
            tags: tags$next
            
        
    );
}

}
     

// ------------ END Input DEFINITIONS -------------