import 'package:test/test.dart';
import "__graphql__/GetData.shalom.dart";
import "__graphql__/schema.shalom.dart";

void main() {
  group("required inputs with defaults", () {
    test("requiredInputWithDefaultsRequired", () {
      final req = RequestGetData(
        variables: GetDataVariables(
          input: RequiredInputWithDefaults(),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {"id": "default_id", "name": "default_name", "count": 42},
      });
    });

    test("requiredInputWithDefaultsOverride", () {
      final req = RequestGetData(
        variables: GetDataVariables(
          input:
              RequiredInputWithDefaults(id: "custom_id", name: "custom_name"),
        ),
      ).toRequest();
      expect(req.variables, {
        "input": {"id": "custom_id", "name": "custom_name", "count": 42},
      });
    });

    test("toJson", () {
      final input = RequiredInputWithDefaults();
      expect(input.toJson(),
          {"id": "default_id", "name": "default_name", "count": 42});
    });

    test("equals", () {
      final input1 = RequiredInputWithDefaults();
      final input2 = RequiredInputWithDefaults();
      expect(input1.toJson(), equals(input2.toJson()));
    });

    test("cacheNormalization", () {
      // Assuming cache normalization test
      final _ = RequiredInputWithDefaults();
      // Add cache related test if applicable
    });
  });
}
