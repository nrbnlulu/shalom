import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/GetProductDetails.shalom.dart";

void main() {
  group("test scalar arguments", () {
      test("test_scalar_arguments", () {
            final json = {
                "product": {
                  "id": "foo", 
                  "name": "laptop",    
                  "price": 50.0,
                  "discountedPrice": 30.0 
                } 
            };
            final productDetails = GetProductDetailsResponse.fromJson(json); 
            final productDetailsVariables = GetProductDetailsVariables(calculateDiscount: false, productId: "foo", userDiscount: 20.0); 
            final productDetailsRequest = RequestGetProductDetails(operation: productDetails, variables: productDetailsVariables); 
            final request = productDetailsRequest.toRequest();
            final requestJson = request.toJson(); 
            print(requestJson);
      });
  }); 
}