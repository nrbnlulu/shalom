




// Generate enums first


// Then generate classes

/// GetProductDetails class with selected fields from query

class RequestGetProductDetails {
  /// Class fields
  
  
  final RequestGetProductDetailsProduct? product;
  
  

  /// Constructor
  RequestGetProductDetails({
    
    this.product,
    
  });

  /// Creates from JSON
  factory RequestGetProductDetails.fromJson(Map<String, dynamic> json) => RequestGetProductDetails(
    
    product: 
      json['product'] != null 
        ? RequestGetProductDetailsProduct.fromJson(json['product'] as Map<String, dynamic>)
        : null
    ,
    
  );

  /// Updates from JSON
  RequestGetProductDetails updateWithJson(Map<String, dynamic> data) {
    return RequestGetProductDetails(
      
      product: 
        data.containsKey('product') 
          ? (data['product'] != null 
              ? RequestGetProductDetailsProduct.fromJson(data['product'] as Map<String, dynamic>)
              : null)
          : this.product
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
    'product': 
      product?.toJson()
    ,
    
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetProductDetails &&
          
          other.product == product &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    product,
    
  ]);
}






    
        
/// GetProductDetailsProduct class with selected fields from query

class RequestGetProductDetailsProduct {
  /// Class fields
  
  
  final String id;
  
  
  
  final String name;
  
  
  
  final double price;
  
  
  
  final double? discountedPrice;
  
  

  /// Constructor
  RequestGetProductDetailsProduct({
    
    required this.id,
    
    required this.name,
    
    required this.price,
    
    this.discountedPrice,
    
  });

  /// Creates from JSON
  factory RequestGetProductDetailsProduct.fromJson(Map<String, dynamic> json) => RequestGetProductDetailsProduct(
    
    id: 
      json['id'] as String
    ,
    
    name: 
      json['name'] as String
    ,
    
    price: 
      json['price'] as double
    ,
    
    discountedPrice: 
      json['discountedPrice'] as double?
    ,
    
  );

  /// Updates from JSON
  RequestGetProductDetailsProduct updateWithJson(Map<String, dynamic> data) {
    return RequestGetProductDetailsProduct(
      
      id: 
        data.containsKey('id') 
          ? data['id'] as String
          : this.id
      ,
      
      name: 
        data.containsKey('name') 
          ? data['name'] as String
          : this.name
      ,
      
      price: 
        data.containsKey('price') 
          ? data['price'] as double
          : this.price
      ,
      
      discountedPrice: 
        data.containsKey('discountedPrice') 
          ? data['discountedPrice'] as double?
          : this.discountedPrice
      ,
      
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
    
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestGetProductDetailsProduct &&
          
          other.id == id &&
          
          other.name == name &&
          
          other.price == price &&
          
          other.discountedPrice == discountedPrice &&
          
          true);

  @override
  int get hashCode => Object.hashAll([
    
    id,
    
    name,
    
    price,
    
    discountedPrice,
    
  ]);
}

        
    

    
