import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/OptOrderRequest.shalom.dart";
import "__graphql__/OrderOptRequest.shalom.dart";
import "__graphql__/OrderOptWithNullDefaultsRequest.shalom.dart";
import "__graphql__/OrderOptWithSomeDefaultsRequest.shalom.dart";
import "__graphql__/CreateOrderRequest.shalom.dart";
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetOrder.shalom.dart";

void main() {
  group("equals (==)", () {
    group("Order (required fields)", () {
      test("same values are equal", () {
        final a = Order(name: "shalom", price: 300.0, quantity: 2);
        final b = Order(name: "shalom", price: 300.0, quantity: 2);
        expect(a == b, isTrue);
        expect(a.hashCode == b.hashCode, isTrue);
      });
      test("different values are not equal", () {
        final a = Order(name: "shalom", price: 300.0, quantity: 2);
        final b = Order(name: "other", price: 300.0, quantity: 2);
        expect(a == b, isFalse);
      });
    });

    group("OrderOpt (optional no default / Maybe)", () {
      test("both None are equal", () {
        final a = OrderOpt();
        final b = OrderOpt();
        expect(a == b, isTrue);
      });
      test("same Some values are equal", () {
        final a = OrderOpt(name: Some("shalom"), price: Some(10.0));
        final b = OrderOpt(name: Some("shalom"), price: Some(10.0));
        expect(a == b, isTrue);
      });
      test("different values are not equal", () {
        final a = OrderOpt(name: Some("shalom"));
        final b = OrderOpt(name: Some("other"));
        expect(a == b, isFalse);
      });
      test("Some vs None are not equal", () {
        final a = OrderOpt(name: Some("shalom"));
        final b = OrderOpt();
        expect(a == b, isFalse);
      });
    });

    group("OrderOptWithNullDefaults", () {
      test("defaults are equal", () {
        final a = OrderOptWithNullDefaults();
        final b = OrderOptWithNullDefaults();
        expect(a == b, isTrue);
      });
      test("same values are equal", () {
        final a = OrderOptWithNullDefaults(name: "shalom");
        final b = OrderOptWithNullDefaults(name: "shalom");
        expect(a == b, isTrue);
      });
      test("different values are not equal", () {
        final a = OrderOptWithNullDefaults(name: "shalom");
        final b = OrderOptWithNullDefaults(name: "other");
        expect(a == b, isFalse);
      });
    });

    group("OrderOptWithSomeDefaults", () {
      test("defaults are equal", () {
        final a = OrderOptWithSomeDefaults();
        final b = OrderOptWithSomeDefaults();
        expect(a == b, isTrue);
      });
      test("overridden values are equal", () {
        final a = OrderOptWithSomeDefaults(name: "custom");
        final b = OrderOptWithSomeDefaults(name: "custom");
        expect(a == b, isTrue);
      });
      test("different values are not equal", () {
        final a = OrderOptWithSomeDefaults(name: "custom");
        final b = OrderOptWithSomeDefaults();
        expect(a == b, isFalse);
      });
    });
  });

  group("required input objects", () {
    test("RequiredArguments", () {
      final req = RequestCreateOrderRequest(
        variables: CreateOrderRequestVariables(
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
