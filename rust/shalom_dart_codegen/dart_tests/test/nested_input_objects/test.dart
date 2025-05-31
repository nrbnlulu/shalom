import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetSpecificOrder.shalom.dart';
import '__graphql__/OrderRecursive.shalom.dart';
import '__graphql__/schema.shalom.dart';

void main() {
  test("nested input object selection", () {
    final req =
        RequestGetSpecificOrder(
          variables: GetSpecificOrderVariables(
            id: "foo",
            specificOrder: SpecificOrder(
              order: Order(name: "shalom", price: 300, quantity: 1),
              notes: "quality first",
            ),
          ),
        ).toRequest();
    expect(req.variables, {
      "id": "foo",
      "specificOrder": {
        "order": {"name": "shalom", "price": 300, "quantity": 1},
        "notes": "quality first",
      },
    });
  });
  group("recursive input object selection", () {
    test("Some(null)", () {
      final req =
          RequestOrderRecursive(
            variables: OrderRecursiveVariables(
              order: Some(
                OrderRecursive(order: Some(OrderRecursive(order: Some(null)))),
              ),
            ),
          ).toRequest();
      expect(req.variables, {
        "order": {
          "order": {"order": null},
        },
      });
    });
    test("None", () {
      final req =
          RequestOrderRecursive(
            variables: OrderRecursiveVariables(
              order: Some(OrderRecursive(order: Some(OrderRecursive()))),
            ),
          ).toRequest();
      expect(req.variables, {
        "order": {"order": {}},
      });
    });
  });
}
