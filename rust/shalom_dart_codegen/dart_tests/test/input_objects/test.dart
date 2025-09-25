import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/OptOrderRequest.shalom.dart";
import "__graphql__/OrderOptRequest.shalom.dart";
import "__graphql__/OrderOptWithNullDefaultsRequest.shalom.dart";
import "__graphql__/OrderOptWithSomeDefaultsRequest.shalom.dart";
import "__graphql__/OrderRequest.shalom.dart";
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetOrder.shalom.dart";

void main() {
  group("required input objects", () {
    test("RequiredArguments", () {
      final req = RequestOrderRequest(
        variables: OrderRequestVariables(
          order: Order(name: "shalom", price: 300.0, quantity: 2),
        ),
      ).toRequest();
      expect(req.variables, {
        "order": {"name": "shalom", "price": 300.0, "quantity": 2},
      });
    });
    group("OptionalArguments", () {
      test("some(T)", () {
        final req = RequestOrderOptRequest(
          variables: OrderOptRequestVariables(
            order: OrderOpt(name: Some("shalom")),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": "shalom"},
        });
      });
      test("some(null)", () {
        final req = RequestOrderOptRequest(
          variables: OrderOptRequestVariables(
            order: OrderOpt(name: Some(null)),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": null},
        });
      });

      test("None", () {
        final req = RequestOrderOptRequest(
          variables: OrderOptRequestVariables(order: OrderOpt()),
        ).toRequest();
        expect(req.variables, {"order": {}});
      });
    });
    group("OptionalArgumentsWithNullDefault", () {
      test("None", () {
        final req = RequestOrderOptWithNullDefaultsRequest(
          variables: OrderOptWithNullDefaultsRequestVariables(
            order: OrderOptWithNullDefaults(),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": null, "price": null, "quantity": null},
        });
      });
      test("Some", () {
        final req = RequestOrderOptWithNullDefaultsRequest(
          variables: OrderOptWithNullDefaultsRequestVariables(
            order: OrderOptWithNullDefaults(name: "shalom"),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": "shalom", "price": null, "quantity": null},
        });
      });
    });
    group("OptionalArgumentWithSomeDefault", () {
      test("None", () {
        final req = RequestOrderOptWithSomeDefaultsRequest(
          variables: OrderOptWithSomeDefaultsRequestVariables(
            order: OrderOptWithSomeDefaults(),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": "burgers", "price": 10.0, "quantity": 2},
        });
      });
      test("Some", () {
        final req = RequestOrderOptWithSomeDefaultsRequest(
          variables: OrderOptWithSomeDefaultsRequestVariables(
            order: OrderOptWithSomeDefaults(name: "shalom"),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": "shalom", "price": 10.0, "quantity": 2},
        });
      });
      test("Some(null)", () {
        final req = RequestOrderOptWithSomeDefaultsRequest(
          variables: OrderOptWithSomeDefaultsRequestVariables(
            order: OrderOptWithSomeDefaults(name: null),
          ),
        ).toRequest();
        expect(req.variables, {
          "order": {"name": null, "price": 10.0, "quantity": 2},
        });
      });
    });
  });
  group("optional input objects", () {
    test("None", () {
      final req = RequestOptOrderRequest(
        variables: OptOrderRequestVariables(),
      ).toRequest();
      expect(req.variables, {});
    });
    test("Some", () {
      final req = RequestOptOrderRequest(
        variables: OptOrderRequestVariables(
          order: Some(Order(name: "shalom", price: 300, quantity: 1)),
        ),
      ).toRequest();
      expect(req.variables, {
        "order": {"name": "shalom", "price": 300.0, "quantity": 1},
      });
    });
    test("Some(null)", () {
      final req = RequestOptOrderRequest(
        variables: OptOrderRequestVariables(order: Some(null)),
      ).toRequest();
      expect(req.variables, {"order": null});
    });
  });
  test("multiple inputs", () {
    final req = RequestGetOrder(
      variables: GetOrderVariables(
        id: "foo",
        order: Some(Order(name: "shalom", price: 300, quantity: 1)),
      ),
    ).toRequest();
    expect(req.variables, {
      "id": "foo",
      "order": {"name": "shalom", "price": 300.0, "quantity": 1},
    });
  });
}
