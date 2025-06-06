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
    final req =
        RequestEnumRequired(
          variables: EnumRequiredVariables(status: Status.COMPLETED),
        ).toRequest();
    expect(req.variables, {"status": "COMPLETED"});
  });

  test("optional enum argument", () {
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
    final req =
        RequestEnumInputObjectRequired(
          variables: EnumInputObjectRequiredVariables(
            order: OrderUpdate(status: Status.PROCESSING, timeLeft: 2),
          ),
        ).toRequest();
    expect(req.variables, {
      "order": {"status": "PROCESSING", "timeLeft": 2},
    });
  });
  test("optional enum argument in InputObject", () {
    final req =
        RequestEnumInputObjectOptional(
          variables: EnumInputObjectOptionalVariables(
            order: OrderUpdateStatusOpt(timeLeft: 2, status: Some(null)),
          ),
        ).toRequest();
    expect(req.variables, {
      "order": {"status": null, "timeLeft": 2},
    });
  });

  test("optional enum argument with default value", () {
    final req =
        RequestEnumWithDefaultValue(
          variables: EnumWithDefaultValueVariables(),
        ).toRequest();
    expect(req.variables, {"status": "SENT"});
  });
}
