










import "schema.shalom.dart";

import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class SubmitReviewResponse{

    /// class members
    
        
            final String? submitReview;
        
    
    // keywordargs constructor
    SubmitReviewResponse({
    
        this.submitReview,
    
    });
    static SubmitReviewResponse fromJson(JsonObject data) {
    
        
            final String? submitReview_value = data['submitReview'];
        
    
    return SubmitReviewResponse(
    
        
        submitReview: submitReview_value,
    
    );
    }
    SubmitReviewResponse updateWithJson(JsonObject data) {
    
        
            final String? submitReview_value;
            if (data.containsKey('submitReview')) {
            submitReview_value = data['submitReview'];
            } else {
            submitReview_value = submitReview;
            }
        
    
    return SubmitReviewResponse(
    
        
        submitReview: submitReview_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is SubmitReviewResponse &&
    
        other.submitReview == submitReview 
    
    );
    }
    @override
    int get hashCode =>
    
        submitReview.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'submitReview':
            
                submitReview
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------



// ------------ END OBJECT DEFINITIONS -------------


class RequestSubmitReview extends Requestable {
    
    final SubmitReviewVariables variables;
    

    RequestSubmitReview(
        
        {
            required this.variables,
        } 
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""mutation SubmitReview($review: Review) {
  submitReview(review: $review)
}""", 
            variables: variablesJson, 
            opType: OperationType.Mutation, 
            StringopName: 'SubmitReview'
        );
    }
}


class SubmitReviewVariables {
    
        final Option<Review?> review;
    

    SubmitReviewVariables(
        
            {
            

    
         
            this.review = const None() 
        ,
    
      
 
            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (review.isSome()) {
             
                data["review"] = review.some()?.toJson();   
            
        } 
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
     
        final Option<Review?> review_value;
          
            final JsonObject? review$raw = data['review'];
            if (review$raw != null) {   
                
                    review_value = Some(Review.fromJson(review$raw));   
                
            } else {
                
                    review_value = None();
                
            }
        
    

    return SubmitReviewVariables (
        
           review: review_value,
        
    );

    }
}
