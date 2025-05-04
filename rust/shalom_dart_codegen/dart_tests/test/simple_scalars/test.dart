import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
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
      final result = GetString.fromJson({'string': 'testString'});
      expect(result.string, 'testString');
    });

    test('StringOptional', () {
      final result = GetStringOptional.fromJson({
        'stringOptional': 'testStringOptional',
      });
      expect(result.stringOptional, 'testStringOptional');
    });

    test('StringOptional with null', () {
      final result = GetStringOptional.fromJson({
        'stringOptional': null,
      });
      expect(result.stringOptional, isNull);
    });

    test('ID', () {
      final result = GetID.fromJson({'id': 'testID'});
      expect(result.id, 'testID');
    });

    test('IDOptional', () {
      final result = GetIDOptional.fromJson({
        'idOptional': 'testIDOptional',
      });
      expect(result.idOptional, 'testIDOptional');
    });

    test('IDOptional with null', () {
      final result = GetIDOptional.fromJson({'idOptional': null});
      expect(result.idOptional, isNull);
    });

    test('Float', () {
      final result = GetFloat.fromJson({'float': 1.23});
      expect(result.float, 1.23);
    });

    test('FloatOptional', () {
      final result = GetFloatOptional.fromJson({'floatOptional': 4.56});
      expect(result.floatOptional, 4.56);
    });

    test('FloatOptional with null', () {
      final result = GetFloatOptional.fromJson({'floatOptional': null});
      expect(result.floatOptional, isNull);
    });

    test('Boolean', () {
      final result = GetBoolean.fromJson({'boolean': true});
      expect(result.boolean, true);
    });

    test('BooleanOptional', () {
      final result = GetBooleanOptional.fromJson({
        'booleanOptional': false,
      });
      expect(result.booleanOptional, false);
    });

    test('BooleanOptional with null', () {
      final result = GetBooleanOptional.fromJson({
        'booleanOptional': null,
      });
      expect(result.booleanOptional, isNull);
    });

    test('Int', () {
      final result = GetInt.fromJson({'intField': 123});
      expect(result.intField, 123);
    });

    test('IntOptional', () {
      final result = GetIntOptional.fromJson({'intOptional': 456});
      expect(result.intOptional, 456);
    });

    test('IntOptional with null', () {
      final result = GetIntOptional.fromJson({'intOptional': null});
      expect(result.intOptional, isNull);
    });
  });

  group("Scalars updateWithJson", () {
    test("String", () {
      final initial = GetString(string: "hello");
      final updated = initial.updateWithJson({'string': 'world'});
      expect(updated.string, 'world');
      expect(initial, isNot(updated));
    });

    test("StringOptional", () {
      final initial = GetStringOptional(stringOptional: "helloOptional");
      final updated = initial.updateWithJson({
        'stringOptional': 'worldOptional',
      });
      expect(updated.stringOptional, 'worldOptional');
      expect(initial, isNot(updated));
    });

    test("StringOptional with null", () {
      final initial = GetStringOptional(stringOptional: "helloOptional");
      final updated = initial.updateWithJson({'stringOptional': null});
      expect(updated.stringOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("ID", () {
      final initial = GetID(id: "initialID");
      final updated = initial.updateWithJson({'id': 'updatedID'});
      expect(updated.id, 'updatedID');
      expect(initial, isNot(updated));
    });

    test("IDOptional", () {
      final initial = GetIDOptional(idOptional: "initialIDOptional");
      final updated = initial.updateWithJson({
        'idOptional': 'updatedIDOptional',
      });
      expect(updated.idOptional, 'updatedIDOptional');
      expect(initial, isNot(updated));
    });

    test("IDOptional with null", () {
      final initial = GetIDOptional(idOptional: "initialIDOptional");
      final updated = initial.updateWithJson({'idOptional': null});
      expect(updated.idOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Float", () {
      final initial = GetFloat(float: 1.23);
      final updated = initial.updateWithJson({'float': 4.56});
      expect(updated.float, 4.56);
      expect(initial, isNot(updated));
    });

    test("FloatOptional", () {
      final initial = GetFloatOptional(floatOptional: 1.23);
      final updated = initial.updateWithJson({'floatOptional': 4.56});
      expect(updated.floatOptional, 4.56);
      expect(initial, isNot(updated));
    });

    test("FloatOptional with null", () {
      final initial = GetFloatOptional(floatOptional: 1.23);
      final updated = initial.updateWithJson({'floatOptional': null});
      expect(updated.floatOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Boolean", () {
      final initial = GetBoolean(boolean: true);
      final updated = initial.updateWithJson({'boolean': false});
      expect(updated.boolean, false);
      expect(initial, isNot(updated));
    });

    test("BooleanOptional", () {
      final initial = GetBooleanOptional(booleanOptional: true);
      final updated = initial.updateWithJson({'booleanOptional': false});
      expect(updated.booleanOptional, false);
      expect(initial, isNot(updated));
    });

    test("BooleanOptional with null", () {
      final initial = GetBooleanOptional(booleanOptional: true);
      final updated = initial.updateWithJson({'booleanOptional': null});
      expect(updated.booleanOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("Int", () {
      final initial = GetInt(intField: 123);
      final updated = initial.updateWithJson({'intField': 456});
      expect(updated.intField, 456);
      expect(initial, isNot(updated));
    });

    test("IntOptional", () {
      final initial = GetIntOptional(intOptional: 123);
      final updated = initial.updateWithJson({'intOptional': 456});
      expect(updated.intOptional, 456);
      expect(initial, isNot(updated));
    });

    test("IntOptional with null", () {
      final initial = GetIntOptional(intOptional: 123);
      final updated = initial.updateWithJson({'intOptional': null});
      expect(updated.intOptional, isNull);
      expect(initial, isNot(updated));
    });
  });

  group("Scalars toJson", () {
    test("String", () {
      final data = {"string": "foo"};
      final initial = GetString.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional", () {
      final data = {"stringOptional": "fooOptional"};
      final initial = GetStringOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional with null", () {
      final data = {"stringOptional": null};
      final initial = GetStringOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ID", () {
      final data = {"id": "fooID"};
      final initial = GetID.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional", () {
      final data = {"idOptional": "fooIDOptional"};
      final initial = GetIDOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional with null", () {
      final data = {"idOptional": null};
      final initial = GetIDOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Float", () {
      final data = {"float": 1.23};
      final initial = GetFloat.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional", () {
      final data = {"floatOptional": 4.56};
      final initial = GetFloatOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional with null", () {
      final data = {"floatOptional": null};
      final initial = GetFloatOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Boolean", () {
      final data = {"boolean": true};
      final initial = GetBoolean.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional", () {
      final data = {"booleanOptional": false};
      final initial = GetBooleanOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional with null", () {
      final data = {"booleanOptional": null};
      final initial = GetBooleanOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Int", () {
      final data = {"intField": 123};
      final initial = GetInt.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional", () {
      final data = {"intOptional": 456};
      final initial = GetIntOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional with null", () {
      final data = {"intOptional": null};
      final initial = GetIntOptional.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Multiple fields", () {
      final data = {"id": "fooID", "intField": 123};
      final initial = GetMultipleFields.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });
}