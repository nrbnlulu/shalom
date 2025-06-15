// ignore_for_file: constant_identifier_names











import 'package:shalom_core/shalom_core.dart';


// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------


class Order {
    
    
        final String name; 
    
        final double price; 
    
        final int quantity; 
    
    Order(
        {
        

    
        
            required this.name  
        ,
    
    
    
        
            required this.price  
        ,
    
    
    
        
            required this.quantity  
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        
            data["name"] = name; 
        
    

    
    
        
            data["price"] = price; 
        
    

    
    
        
            data["quantity"] = quantity; 
        
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
    
        final String name_value;
         
                name_value = data['name'];
        
    

    
    
    
        final double price_value;
         
                price_value = data['price'];
        
    

    
    
    
        final int quantity_value;
         
                quantity_value = data['quantity'];
        
    

    return Order (
        
           name: name_value,
        
           price: price_value,
        
           quantity: quantity_value,
        
    );

    }
}
     


class OrderDetails {
    
    
        final Option<Review?> firstReview; 
    
    OrderDetails(
        {
        

    
         
            this.firstReview = const None() 
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (firstReview.isSome()) {
             
                data["firstReview"] = firstReview.some()?.toJson();   
            
        } 
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
     
        final Option<Review?> firstReview_value;
          
            final JsonObject? firstReview$raw = data['firstReview'];
            if (firstReview$raw != null) {   
                
                    firstReview_value = Some(Review.fromJson(firstReview$raw));   
                
            } else {
                
                    firstReview_value = None();
                
            }
        
    

    return OrderDetails (
        
           firstReview: firstReview_value,
        
    );

    }
}
     


class OrderRecursive {
    
    
        final Option<OrderRecursive?> order; 
    
    OrderRecursive(
        {
        

    
         
            this.order = const None() 
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (order.isSome()) {
             
                data["order"] = order.some()?.toJson();   
            
        } 
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
     
        final Option<OrderRecursive?> order_value;
          
            final JsonObject? order$raw = data['order'];
            if (order$raw != null) {   
                
                    order_value = Some(OrderRecursive.fromJson(order$raw));   
                
            } else {
                
                    order_value = None();
                
            }
        
    

    return OrderRecursive (
        
           order: order_value,
        
    );

    }
}
     


class Review {
    
    
        final Option<OrderDetails?> order; 
    
    Review(
        {
        

    
         
            this.order = const None() 
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (order.isSome()) {
             
                data["order"] = order.some()?.toJson();   
            
        } 
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
     
        final Option<OrderDetails?> order_value;
          
            final JsonObject? order$raw = data['order'];
            if (order$raw != null) {   
                
                    order_value = Some(OrderDetails.fromJson(order$raw));   
                
            } else {
                
                    order_value = None();
                
            }
        
    

    return Review (
        
           order: order_value,
        
    );

    }
}
     


class SpecificOrder {
    
    
        final String notes; 
    
        final Order order; 
    
    SpecificOrder(
        {
        

    
        
            required this.notes  
        ,
    
    
    
        
            required this.order  
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        
            data["notes"] = notes; 
        
    

    
    
        
            data["order"] = order.toJson();
        
    

    
        return data;
    } 

    static fromJson(JsonObject data) {
        

    
    
    
        final String notes_value;
         
                notes_value = data['notes'];
        
    

    
    
     
        final Order order_value;
        
            order_value = Order.fromJson(data['order']);   
        
    

    return SpecificOrder (
        
           notes: notes_value,
        
           order: order_value,
        
    );

    }
}
     

// ------------ END Input DEFINITIONS -------------