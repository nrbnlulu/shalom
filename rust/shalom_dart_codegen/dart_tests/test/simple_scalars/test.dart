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

  group('Scalars Equality', () {
    test('String ==', () {
      final a = GetStringResponse.fromJson({'string': 'test'});
      final b = GetStringResponse.fromJson({'string': 'test'});
      expect(a == b, true);
      final c = GetStringResponse.fromJson({'string': 'other'});
      expect(a == c, false);
    });

    test('StringOptional ==', () {
      final a = GetStringOptionalResponse.fromJson({'stringOptional': 'test'});
      final b = GetStringOptionalResponse.fromJson({'stringOptional': 'test'});
      expect(a == b, true);
      final c = GetStringOptionalResponse.fromJson({'stringOptional': null});
      expect(a == c, false);
    });

    test('ID ==', () {
      final a = GetIDResponse.fromJson({'id': 'test'});
      final b = GetIDResponse.fromJson({'id': 'test'});
      expect(a == b, true);
      final c = GetIDResponse.fromJson({'id': 'other'});
      expect(a == c, false);
    });

    test('IDOptional ==', () {
      final a = GetIDOptionalResponse.fromJson({'idOptional': 'test'});
      final b = GetIDOptionalResponse.fromJson({'idOptional': 'test'});
      expect(a == b, true);
      final c = GetIDOptionalResponse.fromJson({'idOptional': null});
      expect(a == c, false);
    });

    test('Float ==', () {
      final a = GetFloatResponse.fromJson({'float': 1.23});
      final b = GetFloatResponse.fromJson({'float': 1.23});
      expect(a == b, true);
      final c = GetFloatResponse.fromJson({'float': 4.56});
      expect(a == c, false);
    });

    test('FloatOptional ==', () {
      final a = GetFloatOptionalResponse.fromJson({'floatOptional': 1.23});
      final b = GetFloatOptionalResponse.fromJson({'floatOptional': 1.23});
      expect(a == b, true);
      final c = GetFloatOptionalResponse.fromJson({'floatOptional': null});
      expect(a == c, false);
    });

    test('Boolean ==', () {
      final a = GetBooleanResponse.fromJson({'boolean': true});
      final b = GetBooleanResponse.fromJson({'boolean': true});
      expect(a == b, true);
      final c = GetBooleanResponse.fromJson({'boolean': false});
      expect(a == c, false);
    });

    test('BooleanOptional ==', () {
      final a = GetBooleanOptionalResponse.fromJson({'booleanOptional': true});
      final b = GetBooleanOptionalResponse.fromJson({'booleanOptional': true});
      expect(a == b, true);
      final c = GetBooleanOptionalResponse.fromJson({'booleanOptional': null});
      expect(a == c, false);
    });

    test('Int ==', () {
      final a = GetIntResponse.fromJson({'intField': 123});
      final b = GetIntResponse.fromJson({'intField': 123});
      expect(a == b, true);
      final c = GetIntResponse.fromJson({'intField': 456});
      expect(a == c, false);
    });

    test('IntOptional ==', () {
      final a = GetIntOptionalResponse.fromJson({'intOptional': 123});
      final b = GetIntOptionalResponse.fromJson({'intOptional': 123});
      expect(a == b, true);
      final c = GetIntOptionalResponse.fromJson({'intOptional': null});
      expect(a == c, false);
    });

    test('Multiple fields ==', () {
      final a = GetMultipleFieldsResponse.fromJson({
        'id': 'test',
        'intField': 123,
      });
      final b = GetMultipleFieldsResponse.fromJson({
        'id': 'test',
        'intField': 123,
      });
      expect(a == b, true);
      final c = GetMultipleFieldsResponse.fromJson({
        'id': 'other',
        'intField': 123,
      });
      expect(a == c, false);
    });
  });
}
