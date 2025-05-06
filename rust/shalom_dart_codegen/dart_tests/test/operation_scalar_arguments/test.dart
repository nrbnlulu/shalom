import 'package:test/test.dart';
import "__graphql__/GetProductDetails.shalom.dart";
import "dart:convert";

void main() {
  group("test scalar arguments", () {
    test("test_scalar_arguments", () {
      final productDetailsVariables = GetProductDetailsVariables(
        calculateDiscount: false,
        productId: "foo",
        userDiscount: 20.0,
      );
      final productDetailsRequest = RequestGetProductDetails(
        variables: productDetailsVariables,
      );
      final request = productDetailsRequest.toRequest();
      final requestJson = JsonEncoder().convert(request.toJson());
      final expectedJson = r"""{"query":"query GetProductDetails($productId: ID!, $userDiscount: Float, $calculateDiscount: Boolean) {\n  product(id: $productId, discount: $userDiscount) {\n    id\n    name\n    price\n    discountedPrice(applyDiscount: $calculateDiscount)\n  }\n}","variables":{"calculateDiscount":false,"productId":"foo","userDiscount":20.0},"operationName":"GetProductDetails"}""";
      expect(requestJson, expectedJson);
    });
  });
}
