import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';

import "dart:convert";

import "__graphql__/OptionalArguments.shalom.dart";
import "__graphql__/RequiredArguments.shalom.dart";

void main() {
  group("scalar arguments", () {
    test("RequiredArguments", () {
      final req =
          RequestRequiredArguments(
            variables: RequiredArgumentsVariables(id: "123"),
          ).toRequest();
      expect(req.variables, {"id": "123"});
      expect(req.StringopName, "RequiredArguments");
      expect(req.query, isNotEmpty);
      expect(req.opType, OperationType.Query);
    });

    group("OptionalArguments", () {
      test("some(T)", () {
        final req =
            RequestOptionalArguments(
              variables: OptionalArgumentsVariables(id: Some("123")),
            ).toRequest();
        expect(req.variables, {"id": "123"});
        expect(req.StringopName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
      test("some(null)", () {
        final req =
            RequestOptionalArguments(
              variables: OptionalArgumentsVariables(id: Some(null)),
            ).toRequest();
        expect(req.variables, {"id": null});
        expect(req.StringopName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
  test("None", () {
        final req =
            RequestOptionalArguments(
              variables: OptionalArgumentsVariables(id: None()),
            ).toRequest();
        expect(req.variables, {});
        expect(req.StringopName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });

    });


  });
}
