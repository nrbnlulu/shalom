














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class SubmitReviewResponse{

    /// class members
    
        
            final String? submitReview;
        
    
    // keywordargs constructor
    SubmitReviewResponse({
    
        this.submitReview,
    
    });
    static SubmitReviewResponse fromJson(JsonObject data) {
    
        
            final String? submitReview_value;
            
                submitReview_value = data['submitReview'];
            

        
    
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
    

    SubmitReviewVariables (
        
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

    
SubmitReviewVariables updateWith(
    {
        
            
                Option<Option<Review?>> review = const None()
            
            
        
    }
) {
    
        final Option<Review?> review$next;
        
            switch (review) {

                case Some(value: final data):
                    review$next = data;
                case None():
                    review$next = this.review;
            }
        
    
    return SubmitReviewVariables(
        
            review: review$next
            
        
    );
}


}


// ------------ Node DEFINITIONS -------------

class SubmitReviewNode extends Node {
  SubmitReviewResponse? obj = null;
  SubmitReviewNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
     if (obj != null) {
      obj = SubmitReviewResponse.fromJson(raw);
      manager.addOrUpdateNode(this);
     } else {
      throw Exception("must subscribe to node through manager");
     }
  }

  @override
  void updateWithJson(JsonObject newData) {
    final newObj = obj?.updateWithJson(newData);
    if (newObj != null) {
      obj = newObj;
      notifyListeners();
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }

  @override
  void convertToObjAndSet(JsonObject data) {
     obj = SubmitReviewResponse.fromJson(data);
  }
  
  @override
  JsonObject data() {
    final data = obj?.toJson();
    if (data != null) {
        return data;
    } else {
      throw Exception("must subscribe to node through manager");
    }
  }
} 
// ------------ END Node DEFINITIONS -------------