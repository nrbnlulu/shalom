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
      final result = GetStringResponse.fromResponse({'string': 'testString'});
      expect(result.string, 'testString');
    });

    test('StringOptional', () {
      final result = GetStringOptionalResponse.fromResponse({
        'stringOptional': 'testStringOptional',
      });
      expect(result.stringOptional, 'testStringOptional');
    });

    test('StringOptional with null', () {
      final result = GetStringOptionalResponse.fromResponse({
        'stringOptional': null,
      });
      expect(result.stringOptional, isNull);
    });

    test('ID', () {
      final result = GetIDResponse.fromResponse({'id': 'testID'});
      expect(result.id, 'testID');
    });

    test('IDOptional', () {
      final result = GetIDOptionalResponse.fromResponse({
        'idOptional': 'testIDOptional',
      });
      expect(result.idOptional, 'testIDOptional');
    });

    test('IDOptional with null', () {
      final result = GetIDOptionalResponse.fromResponse({'idOptional': null});
      expect(result.idOptional, isNull);
    });

    test('Float', () {
      final result = GetFloatResponse.fromResponse({'float': 1.23});
      expect(result.float, 1.23);
    });

    test('FloatOptional', () {
      final result = GetFloatOptionalResponse.fromResponse({'floatOptional': 4.56});
      expect(result.floatOptional, 4.56);
    });

    test('FloatOptional with null', () {
      final result = GetFloatOptionalResponse.fromResponse({'floatOptional': null});
      expect(result.floatOptional, isNull);
    });

    test('Boolean', () {
      final result = GetBooleanResponse.fromResponse({'boolean': true});
      expect(result.boolean, true);
    });

    test('BooleanOptional', () {
      final result = GetBooleanOptionalResponse.fromResponse({
        'booleanOptional': false,
      });
      expect(result.booleanOptional, false);
    });

    test('BooleanOptional with null', () {
      final result = GetBooleanOptionalResponse.fromResponse({
        'booleanOptional': null,
      });
      expect(result.booleanOptional, isNull);
    });

    test('Int', () {
      final result = GetIntResponse.fromResponse({'intField': 123});
      expect(result.intField, 123);
    });

    test('IntOptional', () {
      final result = GetIntOptionalResponse.fromResponse({'intOptional': 456});
      expect(result.intOptional, 456);
    });

    test('IntOptional with null', () {
      final result = GetIntOptionalResponse.fromResponse({'intOptional': null});
      expect(result.intOptional, isNull);
    });
  });

  group("Scalars toJson", () {
    test("String", () {
      final data = {"string": "foo"};
      final initial = GetStringResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional", () {
      final data = {"stringOptional": "fooOptional"};
      final initial = GetStringOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("StringOptional with null", () {
      final data = {"stringOptional": null};
      final initial = GetStringOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ID", () {
      final data = {"id": "fooID"};
      final initial = GetIDResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional", () {
      final data = {"idOptional": "fooIDOptional"};
      final initial = GetIDOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IDOptional with null", () {
      final data = {"idOptional": null};
      final initial = GetIDOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Float", () {
      final data = {"float": 1.23};
      final initial = GetFloatResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional", () {
      final data = {"floatOptional": 4.56};
      final initial = GetFloatOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("FloatOptional with null", () {
      final data = {"floatOptional": null};
      final initial = GetFloatOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Boolean", () {
      final data = {"boolean": true};
      final initial = GetBooleanResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional", () {
      final data = {"booleanOptional": false};
      final initial = GetBooleanOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("BooleanOptional with null", () {
      final data = {"booleanOptional": null};
      final initial = GetBooleanOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Int", () {
      final data = {"intField": 123};
      final initial = GetIntResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional", () {
      final data = {"intOptional": 456};
      final initial = GetIntOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("IntOptional with null", () {
      final data = {"intOptional": null};
      final initial = GetIntOptionalResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("Multiple fields", () {
      final data = {"id": "fooID", "intField": 123};
      final initial = GetMultipleFieldsResponse.fromResponse(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });

  group('Scalars Equality', () {
    test('String ==', () {
      final a = GetStringResponse.fromResponse({'string': 'test'});
      final b = GetStringResponse.fromResponse({'string': 'test'});
      expect(a == b, true);
      final c = GetStringResponse.fromResponse({'string': 'other'});
      expect(a == c, false);
    });

    test('StringOptional ==', () {
      final a = GetStringOptionalResponse.fromResponse({'stringOptional': 'test'});
      final b = GetStringOptionalResponse.fromResponse({'stringOptional': 'test'});
      expect(a == b, true);
      final c = GetStringOptionalResponse.fromResponse({'stringOptional': null});
      expect(a == c, false);
    });

    test('ID ==', () {
      final a = GetIDResponse.fromResponse({'id': 'test'});
      final b = GetIDResponse.fromResponse({'id': 'test'});
      expect(a == b, true);
      final c = GetIDResponse.fromResponse({'id': 'other'});
      expect(a == c, false);
    });

    test('IDOptional ==', () {
      final a = GetIDOptionalResponse.fromResponse({'idOptional': 'test'});
      final b = GetIDOptionalResponse.fromResponse({'idOptional': 'test'});
      expect(a == b, true);
      final c = GetIDOptionalResponse.fromResponse({'idOptional': null});
      expect(a == c, false);
    });

    test('Float ==', () {
      final a = GetFloatResponse.fromResponse({'float': 1.23});
      final b = GetFloatResponse.fromResponse({'float': 1.23});
      expect(a == b, true);
      final c = GetFloatResponse.fromResponse({'float': 4.56});
      expect(a == c, false);
    });

    test('FloatOptional ==', () {
      final a = GetFloatOptionalResponse.fromResponse({'floatOptional': 1.23});
      final b = GetFloatOptionalResponse.fromResponse({'floatOptional': 1.23});
      expect(a == b, true);
      final c = GetFloatOptionalResponse.fromResponse({'floatOptional': null});
      expect(a == c, false);
    });

    test('Boolean ==', () {
      final a = GetBooleanResponse.fromResponse({'boolean': true});
      final b = GetBooleanResponse.fromResponse({'boolean': true});
      expect(a == b, true);
      final c = GetBooleanResponse.fromResponse({'boolean': false});
      expect(a == c, false);
    });

    test('BooleanOptional ==', () {
      final a = GetBooleanOptionalResponse.fromResponse({'booleanOptional': true});
      final b = GetBooleanOptionalResponse.fromResponse({'booleanOptional': true});
      expect(a == b, true);
      final c = GetBooleanOptionalResponse.fromResponse({'booleanOptional': null});
      expect(a == c, false);
    });

    test('Int ==', () {
      final a = GetIntResponse.fromResponse({'intField': 123});
      final b = GetIntResponse.fromResponse({'intField': 123});
      expect(a == b, true);
      final c = GetIntResponse.fromResponse({'intField': 456});
      expect(a == c, false);
    });

    test('IntOptional ==', () {
      final a = GetIntOptionalResponse.fromResponse({'intOptional': 123});
      final b = GetIntOptionalResponse.fromResponse({'intOptional': 123});
      expect(a == b, true);
      final c = GetIntOptionalResponse.fromResponse({'intOptional': null});
      expect(a == c, false);
    });

    test('Multiple fields ==', () {
      final a = GetMultipleFieldsResponse.fromResponse({
        'id': 'test',
        'intField': 123,
      });
      final b = GetMultipleFieldsResponse.fromResponse({
        'id': 'test',
        'intField': 123,
      });
      expect(a == b, true);
      final c = GetMultipleFieldsResponse.fromResponse({
        'id': 'other',
        'intField': 123,
      });
      expect(a == c, false);
    });
  });
}
