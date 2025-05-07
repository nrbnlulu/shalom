import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetProductDetails.shalom.dart";
import "__graphql__/UpdateUser.shalom.dart";
import "dart:convert";

void main() {
  group("test query", () {
    test("test request json", () {
      final productDetailsVariables = GetProductDetailsVariables(
        calculateDiscount: Some(false),
        productId: "foo",
        userDiscount: Some(20.0),
      );
      final productDetailsRequest = RequestGetProductDetails(
        variables: productDetailsVariables,
      );
      final request = productDetailsRequest.toRequest();
      expect(request.opType, OperationType.Query);
      final requestJson = JsonEncoder().convert(request.toJson());
      final expectedJson =
          r"""{"query":"query GetProductDetails($productId: ID!, $userDiscount: Float, $calculateDiscount: Boolean) {\n  product(id: $productId, discount: $userDiscount) {\n    id\n    name\n    price\n    discountedPrice(applyDiscount: $calculateDiscount)\n  }\n}","variables":{"calculateDiscount":false,"productId":"foo","userDiscount":20.0},"operationName":"GetProductDetails"}""";
      expect(requestJson, expectedJson);
    });
  });
  group("test mutation", () {
    test("test request json", () {
      final updateUserVariables = UpdateUserVariables(phone: Some("911"));
      final updateUserRequest = RequestUpdateUser(
        variables: updateUserVariables,
      );
      final request = updateUserRequest.toRequest();
      expect(request.opType, OperationType.Mutation);
      final requestJson = JsonEncoder().convert(request.toJson());
      final expectedJson =
          r"""{"query":"mutation UpdateUser($phone: String) {\n  updateUser(phone: $phone) {\n    email\n    name\n    phone\n  }\n}","variables":{"phone":"911"},"operationName":"UpdateUser"}""";
      expect(requestJson, expectedJson);
    });
    test("test optional variable not selected", () {
      final updateUserVariables = UpdateUserVariables();
      final updateUserRequest = RequestUpdateUser(
        variables: updateUserVariables,
      );
      final request = updateUserRequest.toRequest();
      final requestJson = request.toJson();
      final requestVariables = requestJson["variables"];
      expect(requestVariables, {});
    });
    test("test optional variable as null", () {
      final updateUserVariables = UpdateUserVariables(phone: Some(null));
      final updateUserRequest = RequestUpdateUser(
        variables: updateUserVariables,
      );
      final request = updateUserRequest.toRequest();
      final requestJson = request.toJson();
      final requestVariables = requestJson["variables"];
      expect(requestVariables, {"phone": null});
    });
    test("test optional variable as some", () {
      final updateUserVariables = UpdateUserVariables(phone: Some("911"));
      final updateUserRequest = RequestUpdateUser(
        variables: updateUserVariables,
      );
      final request = updateUserRequest.toRequest();
      final requestJson = request.toJson();
      final requestVariables = requestJson["variables"];
      expect(requestVariables, {"phone": "911"});
    });
  });
}
