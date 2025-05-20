import 'package:test/test.dart';
import '__graphql__/GetSpecificOrder.shalom.dart';
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
}
