import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/EnumRequired.shalom.dart";
import "__graphql__/EnumOptional.shalom.dart";
import "__graphql__/EnumInputObjectOptional.shalom.dart";
import "__graphql__/EnumInputObjectRequired.shalom.dart";
import "__graphql__/EnumWithDefaultValue.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  test("required enum argument", () {
    var variables = EnumRequiredVariables(status: Status.SENT);
    var variablesUpdated = variables.updateWith(status: Status.COMPLETED);
    expect(variablesUpdated.status, Status.COMPLETED);
    expect(variables.toJson(), {"status": "SENT"});
    final req = RequestEnumRequired(
      variables: EnumRequiredVariables(status: Status.COMPLETED),
    ).toRequest();
    expect(req.variables, {"status": "COMPLETED"});
  });

  test("optional enum argument", () {
    var variables = EnumOptionalVariables(status: Some(Status.SENT));
    var variablesUpdated = variables.updateWith(
      status: Some(Some(Status.COMPLETED)),
    );
    expect(variablesUpdated.status.some(), Status.COMPLETED);
    expect(
      RequestEnumOptional(
        variables: EnumOptionalVariables(status: Some(null)),
      ).toRequest().variables,
      {"status": null},
    );

    expect(
      RequestEnumOptional(
        variables: EnumOptionalVariables(status: Some(Status.SENT)),
      ).toRequest().variables,
      {"status": "SENT"},
    );
    expect(
      RequestEnumOptional(
        variables: EnumOptionalVariables(status: None()),
      ).toRequest().variables,
      {},
    );
  });

  test("required enum argument in InputObject", () {
    final variables = EnumInputObjectRequiredVariables(
      order: OrderUpdate(status: Status.SENT, timeLeft: 2),
    );
    final variablesUpdated = variables.updateWith(
      order: OrderUpdate(status: Status.COMPLETED, timeLeft: 3),
    );
    expect(variablesUpdated.order.status, Status.COMPLETED);

    final req = RequestEnumInputObjectRequired(
      variables: EnumInputObjectRequiredVariables(
        order: OrderUpdate(status: Status.PROCESSING, timeLeft: 2),
      ),
    ).toRequest();
    expect(req.variables, {
      "order": {"status": "PROCESSING", "timeLeft": 2},
    });
  });

  test("optional enum argument in InputObject", () {
    final variables = EnumInputObjectOptionalVariables(
      order: OrderUpdateStatusMaybe(status: Some(null), timeLeft: 2),
    );
    final variablesUpdated = variables.updateWith(
      order:
          OrderUpdateStatusMaybe(status: Some(Status.COMPLETED), timeLeft: 3),
    );
    expect(variablesUpdated.order.status, Some<Status?>(Status.COMPLETED));
    final req =
        RequestEnumInputObjectOptional(variables: variables).toRequest();
    expect(req.variables, {
      "order": {"status": null, "timeLeft": 2},
    });
  });

  test("optional enum argument with default value", () {
    final req = RequestEnumWithDefaultValue(
      variables: EnumWithDefaultValueVariables(),
    ).toRequest();
    expect(req.variables, {"status": "SENT"});
  });
}
