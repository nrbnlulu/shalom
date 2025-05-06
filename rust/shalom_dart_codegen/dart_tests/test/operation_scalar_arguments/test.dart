import 'package:test/test.dart';
import "__graphql__/GetProductDetails.shalom.dart";

void main() {
  group("test scalar arguments", () {
    test("test_scalar_arguments", () {
      // final json = {
      //   "product": {
      //     "id": "foo",
      //     "name": "laptop",
      //     "price": 50.0,
      //     "discountedPrice": 30.0,
      //   },
      // };
      // final productDetails = GetProductDetailsResponse.fromJson(json);
      final productDetailsVariables = GetProductDetailsVariables(
        calculateDiscount: false,
        productId: "foo",
        userDiscount: 20.0,
      );
      final productDetailsRequest = RequestGetProductDetails(
        variables: productDetailsVariables,
      );
      final request = productDetailsRequest.toRequest();
      final requestJson = request.toJson();
      print(requestJson);
      // final expectedJson = {
      //   "query":
      //       "query GetProductDetails(\$calculateDiscount: Boolean, \$productId: ID, \$userDiscount: Float) {product {id name price discountedPrice}}",
      //   "variables": {
      //     "calculateDiscount": false,
      //     "productId": "foo",
      //     "userDiscount": 20.0,
      //   },
      //   "operationName": "GetProductDetails",
      // };
      // expect(requestJson, expectedJson);
    });
  });
}
