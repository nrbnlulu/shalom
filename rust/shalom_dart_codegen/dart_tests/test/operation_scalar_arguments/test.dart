import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/OptionalArguments.shalom.dart";
import "__graphql__/RequiredArguments.shalom.dart";
import "__graphql__/OptionalWithSomeDefault.shalom.dart";
import "__graphql__/OptionalWithNullDefault.shalom.dart";

void main() {
  group("scalar arguments", () {
    test("RequiredArguments", () {
      final req = RequestRequiredArguments(
        variables: RequiredArgumentsVariables(id: "123"),
      ).toRequest();
      expect(req.variables, {"id": "123"});
      expect(req.opName, "RequiredArguments");
      expect(req.query, isNotEmpty);
      expect(req.opType, OperationType.Query);
    });

    group("OptionalArguments", () {
      test("some(T)", () {
        final req = RequestOptionalArguments(
          variables: OptionalArgumentsVariables(id: Some("123")),
        ).toRequest();
        expect(req.variables, {"id": "123"});
        expect(req.opName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
      test("some(null)", () {
        final req = RequestOptionalArguments(
          variables: OptionalArgumentsVariables(id: Some(null)),
        ).toRequest();
        expect(req.variables, {"id": null});
        expect(req.opName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
      test("None", () {
        final req = RequestOptionalArguments(
          variables: OptionalArgumentsVariables(id: None()),
        ).toRequest();
        expect(req.variables, {});
        expect(req.opName, "OptionalArguments");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
    });

    group("OptionalWithNullDefault", () {
      test("None", () {
        final req = RequestOptionalWithNullDefault(
          variables: OptionalWithNullDefaultVariables(),
        ).toRequest();
        expect(req.variables, {"phone": null});
        expect(req.opName, "OptionalWithNullDefault");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
      test("Some", () {
        final req = RequestOptionalWithNullDefault(
          variables: OptionalWithNullDefaultVariables(phone: "911"),
        ).toRequest();
        expect(req.variables, {"phone": "911"});
        expect(req.opName, "OptionalWithNullDefault");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Mutation);
      });
    });

    group("OptionalWithSomeDefault", () {
      test("None", () {
        final req = RequestOptionalWithSomeDefault(
          variables: OptionalWithSomeDefaultVariables(),
        ).toRequest();
        expect(req.variables, {
          "duration": 2,
          "is_easy": false,
          "name": "shalom",
        });
        expect(req.opName, "OptionalWithSomeDefault");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Query);
      });
      test("Some", () {
        final req = RequestOptionalWithSomeDefault(
          variables: OptionalWithSomeDefaultVariables(
            duration: 10,
            is_easy: false,
            name: "shalom",
          ),
        ).toRequest();
        expect(req.variables, {
          "duration": 10,
          "is_easy": false,
          "name": "shalom",
        });
        expect(req.opName, "OptionalWithSomeDefault");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Query);
      });
      test("Some(null)", () {
        final req = RequestOptionalWithSomeDefault(
          variables: OptionalWithSomeDefaultVariables(
            duration: null,
            is_easy: null,
            name: null,
          ),
        ).toRequest();
        expect(req.variables, {
          "duration": null,
          "is_easy": null,
          "name": null,
        });
        expect(req.opName, "OptionalWithSomeDefault");
        expect(req.query, isNotEmpty);
        expect(req.opType, OperationType.Query);
      });
    });
  });
}
