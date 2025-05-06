
import 'package:shalom_core/shalom_core.dart';



typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types




class GetProductDetailsResponse{

    /// class members
    
        
            final GetProductDetails_product? product;
        
    
    // keywordargs constructor
    GetProductDetailsResponse({
    
        this.product,
    
    });
    static GetProductDetailsResponse fromJson(JsonObject data) {
    
        
            final GetProductDetails_product? product_value;
            
                final JsonObject? product$raw = data['product']; 
                if (product$raw != null) {
                    product_value = GetProductDetails_product.fromJson(product$raw);
                } else {
                    product_value = null;
                }
            
        
    
    return GetProductDetailsResponse(
    
        
        product: product_value,
    
    );
    }
    GetProductDetailsResponse updateWithJson(JsonObject data) {
    
        
        final GetProductDetails_product? product_value;
        if (data.containsKey('product')) {
            
                final JsonObject? product$raw = data['product']; 
                if (product$raw != null) {
                    product_value = GetProductDetails_product.fromJson(product$raw);
                } else {
                    product_value = null;
                }
            
        } else {
            product_value = product;
        }
        
    
    return GetProductDetailsResponse(
    
        
        product: product_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetProductDetailsResponse &&
    
        other.product == product 
    
    );
    }
    @override
    int get hashCode =>
    
        product.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'product':
            
                product?.toJson()
            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetProductDetails_product  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final double price;
        
    
        
            final double? discountedPrice;
        
    
    // keywordargs constructor
    GetProductDetails_product({
    required
        this.id,
    required
        this.name,
    required
        this.price,
    
        this.discountedPrice,
    
    });
    static GetProductDetails_product fromJson(JsonObject data) {
    
        
            final String id_value = data['id'];
        
    
        
            final String name_value = data['name'];
        
    
        
            final double price_value = data['price'];
        
    
        
            final double? discountedPrice_value = data['discountedPrice'];
        
    
    return GetProductDetails_product(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        discountedPrice: discountedPrice_value,
    
    );
    }
    GetProductDetails_product updateWithJson(JsonObject data) {
    
        
            final String id_value;
            if (data.containsKey('id')) {
            id_value = data['id'];
            } else {
            id_value = id;
            }
        
    
        
            final String name_value;
            if (data.containsKey('name')) {
            name_value = data['name'];
            } else {
            name_value = name;
            }
        
    
        
            final double price_value;
            if (data.containsKey('price')) {
            price_value = data['price'];
            } else {
            price_value = price;
            }
        
    
        
            final double? discountedPrice_value;
            if (data.containsKey('discountedPrice')) {
            discountedPrice_value = data['discountedPrice'];
            } else {
            discountedPrice_value = discountedPrice;
            }
        
    
    return GetProductDetails_product(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
        
        discountedPrice: discountedPrice_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetProductDetails_product &&
    
        other.id == id &&
    
        other.name == name &&
    
        other.price == price &&
    
        other.discountedPrice == discountedPrice 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
            
            discountedPrice,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                id
            
        ,
    
        
        'name':
            
                name
            
        ,
    
        
        'price':
            
                price
            
        ,
    
        
        'discountedPrice':
            
                discountedPrice
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------

class RequestGetProductDetails extends Requestable {
    final GetProductDetailsVariables variables;

    RequestGetProductDetails({
        required this.variables,
    });

    @override
    Request toRequest() {
        return Request(
            query: "query GetProductDetails(\$productId: ID!, \$userDiscount: Float, \$calculateDiscount: Boolean) {
  product(id: \$productId, discount: \$userDiscount) {
    id
    name
    price
    discountedPrice(applyDiscount: \$calculateDiscount)
  }
}", 
            variables: variables.toJson(), 
            opType: OperationType.Query, 
            StringopName: 'GetProductDetails'
        );
    }
}


class GetProductDetailsVariables {
    
    final bool? calculateDiscount;
    
    final String productId;
    
    final double? userDiscount;
    

    GetProductDetailsVariables(
        
            {
            
                required this.calculateDiscount,
            
                required this.productId,
            
                required this.userDiscount,
            
            }
        
    );

    JsonObject toJson() {
        return {
            
            'calculateDiscount': calculateDiscount,
            
            'productId': productId,
            
            'userDiscount': userDiscount,
              
        };
    } 
}
