import 'package:shalom/shalom.dart' as shalom_core;
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

void main() {
  group('Simple Scalars Deserialize', () {
    test('String', () {
      final result = GetStringData.fromJson({'string': 'testString'});
      expect(result.string, 'testString');
    });

    test('StringOptional', () {
      final result = GetStringOptionalData.fromJson({
        'stringOptional': 'testStringOptional',
      });
      expect(result.stringOptional, 'testStringOptional');
    });

    test('StringOptional with null', () {
      final result = GetStringOptionalData.fromJson({'stringOptional': null});
      expect(result.stringOptional, isNull);
    });

    test('idField', () {
      final result = GetIDData.fromJson({'idField': 'testID'});
      expect(result.idField, 'testID');
    });

    test('IDOptional', () {
      final result = GetIDOptionalData.fromJson({
        'idOptional': 'testIDOptional',
      });
      expect(result.idOptional, 'testIDOptional');
    });

    test('IDOptional with null', () {
      final result = GetIDOptionalData.fromJson({'idOptional': null});
      expect(result.idOptional, isNull);
    });

    test('Float', () {
      final result = GetFloatData.fromJson({'float': 1.23});
      expect(result.float, 1.23);
    });

    test('FloatOptional', () {
      final result = GetFloatOptionalData.fromJson({'floatOptional': 4.56});
      expect(result.floatOptional, 4.56);
    });

    test('FloatOptional with null', () {
      final result = GetFloatOptionalData.fromJson({'floatOptional': null});
      expect(result.floatOptional, isNull);
    });

    test('Boolean', () {
      final result = GetBooleanData.fromJson({'boolean': true});
      expect(result.boolean, true);
    });

    test('BooleanOptional', () {
      final result = GetBooleanOptionalData.fromJson({
        'booleanOptional': false,
      });
      expect(result.booleanOptional, false);
    });

    test('BooleanOptional with null', () {
      final result = GetBooleanOptionalData.fromJson({'booleanOptional': null});
      expect(result.booleanOptional, isNull);
    });

    test('Int', () {
      final result = GetIntData.fromJson({'intField': 123});
      expect(result.intField, 123);
    });

    test('IntOptional', () {
      final result = GetIntOptionalData.fromJson({'intOptional': 456});
      expect(result.intOptional, 456);
    });

    test('IntOptional with null', () {
      final result = GetIntOptionalData.fromJson({'intOptional': null});
      expect(result.intOptional, isNull);
    });
  });

  group("Scalars toJson", () {
    test("String", () {
      final data = {"string": "foo"};
      final initial = GetStringData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional", () {
      final data = {"stringOptional": "fooOptional"};
      final initial = GetStringOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional with null", () {
      final data = {"stringOptional": null};
      final initial = GetStringOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ID", () {
      final data = {"idField": "fooID"};
      final initial = GetIDData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional", () {
      final data = {"idOptional": "fooIDOptional"};
      final initial = GetIDOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional with null", () {
      final data = {"idOptional": null};
      final initial = GetIDOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Float", () {
      final data = {"float": 1.23};
      final initial = GetFloatData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional", () {
      final data = {"floatOptional": 4.56};
      final initial = GetFloatOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional with null", () {
      final data = {"floatOptional": null};
      final initial = GetFloatOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Boolean", () {
      final data = {"boolean": true};
      final initial = GetBooleanData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional", () {
      final data = {"booleanOptional": false};
      final initial = GetBooleanOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional with null", () {
      final data = {"booleanOptional": null};
      final initial = GetBooleanOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Int", () {
      final data = {"intField": 123};
      final initial = GetIntData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional", () {
      final data = {"intOptional": 456};
      final initial = GetIntOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional with null", () {
      final data = {"intOptional": null};
      final initial = GetIntOptionalData.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });

  group('Scalars Equality', () {
    test('String ==', () {
      final a = GetStringData.fromJson({'string': 'test'});
      final b = GetStringData.fromJson({'string': 'test'});
      expect(a == b, true);
      final c = GetStringData.fromJson({'string': 'other'});
      expect(a == c, false);
    });

    test('StringOptional ==', () {
      final a = GetStringOptionalData.fromJson({'stringOptional': 'test'});
      final b = GetStringOptionalData.fromJson({'stringOptional': 'test'});
      expect(a == b, true);
      final c = GetStringOptionalData.fromJson({'stringOptional': null});
      expect(a == c, false);
    });

    test('ID ==', () {
      final a = GetIDData.fromJson({'idField': 'test'});
      final b = GetIDData.fromJson({'idField': 'test'});
      expect(a == b, true);
      final c = GetIDData.fromJson({'idField': 'other'});
      expect(a == c, false);
    });

    test('IDOptional ==', () {
      final a = GetIDOptionalData.fromJson({'idOptional': 'test'});
      final b = GetIDOptionalData.fromJson({'idOptional': 'test'});
      expect(a == b, true);
      final c = GetIDOptionalData.fromJson({'idOptional': null});
      expect(a == c, false);
    });

    test('Float ==', () {
      final a = GetFloatData.fromJson({'float': 1.23});
      final b = GetFloatData.fromJson({'float': 1.23});
      expect(a == b, true);
      final c = GetFloatData.fromJson({'float': 4.56});
      expect(a == c, false);
    });

    test('FloatOptional ==', () {
      final a = GetFloatOptionalData.fromJson({'floatOptional': 1.23});
      final b = GetFloatOptionalData.fromJson({'floatOptional': 1.23});
      expect(a == b, true);
      final c = GetFloatOptionalData.fromJson({'floatOptional': null});
      expect(a == c, false);
    });

    test('Boolean ==', () {
      final a = GetBooleanData.fromJson({'boolean': true});
      final b = GetBooleanData.fromJson({'boolean': true});
      expect(a == b, true);
      final c = GetBooleanData.fromJson({'boolean': false});
      expect(a == c, false);
    });

    test('BooleanOptional ==', () {
      final a = GetBooleanOptionalData.fromJson({'booleanOptional': true});
      final b = GetBooleanOptionalData.fromJson({'booleanOptional': true});
      expect(a == b, true);
      final c = GetBooleanOptionalData.fromJson({'booleanOptional': null});
      expect(a == c, false);
    });

    test('Int ==', () {
      final a = GetIntData.fromJson({'intField': 123});
      final b = GetIntData.fromJson({'intField': 123});
      expect(a == b, true);
      final c = GetIntData.fromJson({'intField': 456});
      expect(a == c, false);
    });

    test('IntOptional ==', () {
      final a = GetIntOptionalData.fromJson({'intOptional': 123});
      final b = GetIntOptionalData.fromJson({'intOptional': 123});
      expect(a == b, true);
      final c = GetIntOptionalData.fromJson({'intOptional': null});
      expect(a == c, false);
    });
  });
}
