import 'package:test/test.dart';
import "__graphql__/ProcessList.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  group("input list with defaults", () {
    group("required", () {
      test("default", () {
        final req = RequestProcessList(
          variables: ProcessListVariables(input: ListInput()),
        ).toRequest();
        expect(req.variables, {
          "input": {"items": []},
        });
      });

      test("override", () {
        final req = RequestProcessList(
          variables: ProcessListVariables(input: ListInput(items: ["a", "b"])),
        ).toRequest();
        expect(req.variables, {
          "input": {
            "items": ["a", "b"],
          },
        });
      });
    });

    test("to json", () {
      final input = ListInput();
      expect(input.toJson(), {"items": []});
    });

    test("equals", () {
      final input1 = ListInput();
      final input2 = ListInput();
      expect(input1.toJson(), equals(input2.toJson()));
    });
  });
}
