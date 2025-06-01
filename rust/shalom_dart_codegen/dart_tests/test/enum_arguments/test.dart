import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/GetOrderByStatus.shalom.dart";
import "__graphql__/UpdateOrder.shalom.dart";
import "__graphql__/UpdateOrderStatus.shalom.dart";
import "__graphql__/UpdateOrderStatusOpt.shalom.dart";
import "__graphql__/UpdateOrderWithStatusOpt.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  test("required enum argument", () {
    final req =
        RequestUpdateOrderStatus(
          variables: UpdateOrderStatusVariables(status: Status.COMPLETED),
        ).toRequest();
    expect(req.variables, {"status": "COMPLETED"});
  });
  test("optional enum argument", () {
    final req =
        RequestUpdateOrderStatusOpt(
          variables: UpdateOrderStatusOptVariables(status: Some(null)),
        ).toRequest();
    expect(req.variables, {"status": null});
  });
  test("required enum argument in InputObject", () {
    final req =
        RequestUpdateOrder(
          variables: UpdateOrderVariables(
            order: OrderUpdate(status: Status.PROCESSING, timeLeft: 2),
          ),
        ).toRequest();
    expect(req.variables, {
      "order": {"status": "PROCESSING", "timeLeft": 2},
    });
  });
  test("optional enum argument in InputObject", () {
    final req =
        RequestUpdateOrderWithStatusOpt(
          variables: UpdateOrderWithStatusOptVariables(
            order: OrderUpdateStatusOpt(timeLeft: 2, status: Some(null)),
          ),
        ).toRequest();
    expect(req.variables, {
      "order": {"status": null, "timeLeft": 2},
    });
  });
  test("optional enum argument with default value", () {
    final req =
        RequestGetOrderByStatus(
          variables: GetOrderByStatusVariables(),
        ).toRequest();
    expect(req.variables, {"status": "SENT"});
  });
}
