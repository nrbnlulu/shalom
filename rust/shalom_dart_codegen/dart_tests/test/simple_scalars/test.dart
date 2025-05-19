import 'package:test/test.dart';
import "__graphql__/GetBoolean.shalom.dart";
import "__graphql__/GetBooleanOptional.shalom.dart";
import "__graphql__/GetFloat.shalom.dart";
import "__graphql__/GetFloatOptional.shalom.dart";
import "__graphql__/GetInt.shalom.dart";
import "__graphql__/GetIntOptional.shalom.dart";
import "__graphql__/GetString.shalom.dart";
import "__graphql__/GetStringOptional.shalom.dart";
import "__graphql__/GetID.shalom.dart";
import "__graphql__/GetIDOptional.shalom.dart";
import "__graphql__/GetMultipleFields.shalom.dart";

void main() {
  group('Simple Scalars Deserialize', () {
    test('String', () {
      final result = GetStringResponse.fromJson({'string': 'testString'});
      expect(result.string, 'testString');
    });

    test('StringOptional', () {
      final result = GetStringOptionalResponse.fromJson({
        'stringOptional': 'testStringOptional',
      });
      expect(result.stringOptional, 'testStringOptional');
    });

    test('StringOptional with null', () {
      final result = GetStringOptionalResponse.fromJson({
        'stringOptional': null,
      });
      expect(result.stringOptional, isNull);
    });

    test('ID', () {
      final result = GetIDResponse.fromJson({'id': 'testID'});
      expect(result.id, 'testID');
    });

    test('IDOptional', () {
      final result = GetIDOptionalResponse.fromJson({
        'idOptional': 'testIDOptional',
      });
      expect(result.idOptional, 'testIDOptional');
    });

    test('IDOptional with null', () {
      final result = GetIDOptionalResponse.fromJson({'idOptional': null});
      expect(result.idOptional, isNull);
    });

    test('Float', () {
      final result = GetFloatResponse.fromJson({'float': 1.23});
      expect(result.float, 1.23);
    });

    test('FloatOptional', () {
      final result = GetFloatOptionalResponse.fromJson({'floatOptional': 4.56});
      expect(result.floatOptional, 4.56);
    });

    test('FloatOptional with null', () {
      final result = GetFloatOptionalResponse.fromJson({'floatOptional': null});
      expect(result.floatOptional, isNull);
    });

    test('Boolean', () {
      final result = GetBooleanResponse.fromJson({'boolean': true});
      expect(result.boolean, true);
    });

    test('BooleanOptional', () {
      final result = GetBooleanOptionalResponse.fromJson({
        'booleanOptional': false,
      });
      expect(result.booleanOptional, false);
    });

    test('BooleanOptional with null', () {
      final result = GetBooleanOptionalResponse.fromJson({
        'booleanOptional': null,
      });
      expect(result.booleanOptional, isNull);
    });

    test('Int', () {
      final result = GetIntResponse.fromJson({'intField': 123});
      expect(result.intField, 123);
    });

    test('IntOptional', () {
      final result = GetIntOptionalResponse.fromJson({'intOptional': 456});
      expect(result.intOptional, 456);
    });

    test('IntOptional with null', () {
      final result = GetIntOptionalResponse.fromJson({'intOptional': null});
      expect(result.intOptional, isNull);
    });
  });

  group("Scalars updateWithJson", () {
    test("String", () {
      final initial = GetStringResponse(string: "hello");
      final updated = initial.updateWithJson({'string': 'world'});
      expect(updated.string, 'world');
      expect(initial, isNot(updated));
    });

    test("StringOptional", () {
      final initial = GetStringOptionalResponse(
        stringOptional: "helloOptional",
      );
      final updated = initial.updateWithJson({
        'stringOptional': 'worldOptional',
      });
      expect(updated.stringOptional, 'worldOptional');
      expect(initial, isNot(updated));
    });

    test("StringOptional with null", () {
      final initial = GetStringOptionalResponse(
        stringOptional: "helloOptional",
      );
      final updated = initial.updateWithJson({'stringOptional': null});
      expect(updated.stringOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("ID", () {
      final initial = GetIDResponse(id: "initialID");
      final updated = initial.updateWithJson({'id': 'updatedID'});
      expect(updated.id, 'updatedID');
      expect(initial, isNot(updated));
    });

    test("IDOptional", () {
      final initial = GetIDOptionalResponse(idOptional: "initialIDOptional");
      final updated = initial.updateWithJson({
        'idOptional': 'updatedIDOptional',
      });
      expect(updated.idOptional, 'updatedIDOptional');
      expect(initial, isNot(updated));
    });

    test("IDOptional with null", () {
      final initial = GetIDOptionalResponse(idOptional: "initialIDOptional");
      final updated = initial.updateWithJson({'idOptional': null});
      expect(updated.idOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Float", () {
      final initial = GetFloatResponse(float: 1.23);
      final updated = initial.updateWithJson({'float': 4.56});
      expect(updated.float, 4.56);
      expect(initial, isNot(updated));
    });

    test("FloatOptional", () {
      final initial = GetFloatOptionalResponse(floatOptional: 1.23);
      final updated = initial.updateWithJson({'floatOptional': 4.56});
      expect(updated.floatOptional, 4.56);
      expect(initial, isNot(updated));
    });

    test("FloatOptional with null", () {
      final initial = GetFloatOptionalResponse(floatOptional: 1.23);
      final updated = initial.updateWithJson({'floatOptional': null});
      expect(updated.floatOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Boolean", () {
      final initial = GetBooleanResponse(boolean: true);
      final updated = initial.updateWithJson({'boolean': false});
      expect(updated.boolean, false);
      expect(initial, isNot(updated));
    });

    test("BooleanOptional", () {
      final initial = GetBooleanOptionalResponse(booleanOptional: true);
      final updated = initial.updateWithJson({'booleanOptional': false});
      expect(updated.booleanOptional, false);
      expect(initial, isNot(updated));
    });

    test("BooleanOptional with null", () {
      final initial = GetBooleanOptionalResponse(booleanOptional: true);
      final updated = initial.updateWithJson({'booleanOptional': null});
      expect(updated.booleanOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Int", () {
      final initial = GetIntResponse(intField: 123);
      final updated = initial.updateWithJson({'intField': 456});
      expect(updated.intField, 456);
      expect(initial, isNot(updated));
    });

    test("IntOptional", () {
      final initial = GetIntOptionalResponse(intOptional: 123);
      final updated = initial.updateWithJson({'intOptional': 456});
      expect(updated.intOptional, 456);
      expect(initial, isNot(updated));
    });

    test("IntOptional with null", () {
      final initial = GetIntOptionalResponse(intOptional: 123);
      final updated = initial.updateWithJson({'intOptional': null});
      expect(updated.intOptional, isNull);
      expect(initial, isNot(updated));
    });
  });

  group("Scalars toJson", () {
    test("String", () {
      final data = {"string": "foo"};
      final initial = GetStringResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional", () {
      final data = {"stringOptional": "fooOptional"};
      final initial = GetStringOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional with null", () {
      final data = {"stringOptional": null};
      final initial = GetStringOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ID", () {
      final data = {"id": "fooID"};
      final initial = GetIDResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional", () {
      final data = {"idOptional": "fooIDOptional"};
      final initial = GetIDOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional with null", () {
      final data = {"idOptional": null};
      final initial = GetIDOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Float", () {
      final data = {"float": 1.23};
      final initial = GetFloatResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional", () {
      final data = {"floatOptional": 4.56};
      final initial = GetFloatOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional with null", () {
      final data = {"floatOptional": null};
      final initial = GetFloatOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Boolean", () {
      final data = {"boolean": true};
      final initial = GetBooleanResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional", () {
      final data = {"booleanOptional": false};
      final initial = GetBooleanOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional with null", () {
      final data = {"booleanOptional": null};
      final initial = GetBooleanOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Int", () {
      final data = {"intField": 123};
      final initial = GetIntResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional", () {
      final data = {"intOptional": 456};
      final initial = GetIntOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional with null", () {
      final data = {"intOptional": null};
      final initial = GetIntOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Multiple fields", () {
      final data = {"id": "fooID", "intField": 123};
      final initial = GetMultipleFieldsResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });
}
