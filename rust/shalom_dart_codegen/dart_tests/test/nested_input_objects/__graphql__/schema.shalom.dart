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
}
     


class OrderDetails {
    
    
        final Option<Review?> first_review; 
    
    OrderDetails(
        {
        

    
         
            this.first_review = const None() 
        ,
    
      
 
        }
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
      
        if (first_review.isSome()) {
             
                data["first_review"] = first_review.some()?.toJson();   
            
        } 
    

    
        return data;
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
}
     

// ------------ END Input DEFINITIONS -------------