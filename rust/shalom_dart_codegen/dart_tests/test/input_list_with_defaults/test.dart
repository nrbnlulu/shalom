import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/ProcessList.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  group("input list with defaults", () {
    test("inputListWithDefaultsRequired", () {
      final req = RequestProcessList(
        variables: ProcessListVariables(
          input: ListInput(),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {"items": []},
      });
    });

    test("inputListWithDefaultsOverride", () {
      final req = RequestProcessList(
        variables: ProcessListVariables(
          input: ListInput(items: ["a", "b"]),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {
          "items": ["a", "b"]
        },
      });
    });

    test("toJson", () {
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
