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

    test('idField', () {
      final result = GetIDResponse.fromResponse({'idField': 'testID'});
      expect(result.idField, 'testID');
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
      final result = GetFloatOptionalResponse.fromResponse({
        'floatOptional': 4.56,
      });
      expect(result.floatOptional, 4.56);
    });

    test('FloatOptional with null', () {
      final result = GetFloatOptionalResponse.fromResponse({
        'floatOptional': null,
      });
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
      final data = {"idField": "fooID"};
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
      final a = GetStringOptionalResponse.fromResponse({
        'stringOptional': 'test',
      });
      final b = GetStringOptionalResponse.fromResponse({
        'stringOptional': 'test',
      });
      expect(a == b, true);
      final c = GetStringOptionalResponse.fromResponse({
        'stringOptional': null,
      });
      expect(a == c, false);
    });

    test('ID ==', () {
      final a = GetIDResponse.fromResponse({'idField': 'test'});
      final b = GetIDResponse.fromResponse({'idField': 'test'});
      expect(a == b, true);
      final c = GetIDResponse.fromResponse({'idField': 'other'});
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
      final a = GetBooleanOptionalResponse.fromResponse({
        'booleanOptional': true,
      });
      final b = GetBooleanOptionalResponse.fromResponse({
        'booleanOptional': true,
      });
      expect(a == b, true);
      final c = GetBooleanOptionalResponse.fromResponse({
        'booleanOptional': null,
      });
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
  });

  // Rust runtime handles normalization; these tests verify the generated
  // FromCache implementation correctly reads back what the runtime provides.
  group('Scalars Cache Normalization', () {
    // collectRuntimeRefs parses the __used_refs the Rust runtime injects into responses.
    test('collectRuntimeRefs extracts scalar refs', () {
      final data = {
        'string': 'hello',
        '__used_refs': ['ROOT_QUERY_string'],
      };
      final refs = shalom_core.collectRuntimeRefs(data);
      expect(refs, contains('ROOT_QUERY_string'));
    });

    // subscriberGlobalID is how the Rust runtime routes cache-update payloads
    // to the correct FromCache handler — must match the operation name exactly.
    test('String cacheBuilder subscriberGlobalID', () {
      expect(GetStringResponse.cacheBuilder.subscriberGlobalID, 'GetString');
    });
    test('StringOptional cacheBuilder subscriberGlobalID', () {
      expect(GetStringOptionalResponse.cacheBuilder.subscriberGlobalID,
          'GetStringOptional');
    });
    test('ID cacheBuilder subscriberGlobalID', () {
      expect(GetIDResponse.cacheBuilder.subscriberGlobalID, 'GetID');
    });
    test('IDOptional cacheBuilder subscriberGlobalID', () {
      expect(GetIDOptionalResponse.cacheBuilder.subscriberGlobalID,
          'GetIDOptional');
    });
    test('Float cacheBuilder subscriberGlobalID', () {
      expect(GetFloatResponse.cacheBuilder.subscriberGlobalID, 'GetFloat');
    });
    test('FloatOptional cacheBuilder subscriberGlobalID', () {
      expect(GetFloatOptionalResponse.cacheBuilder.subscriberGlobalID,
          'GetFloatOptional');
    });
    test('Boolean cacheBuilder subscriberGlobalID', () {
      expect(GetBooleanResponse.cacheBuilder.subscriberGlobalID, 'GetBoolean');
    });
    test('BooleanOptional cacheBuilder subscriberGlobalID', () {
      expect(GetBooleanOptionalResponse.cacheBuilder.subscriberGlobalID,
          'GetBooleanOptional');
    });
    test('Int cacheBuilder subscriberGlobalID', () {
      expect(GetIntResponse.cacheBuilder.subscriberGlobalID, 'GetInt');
    });
    test('IntOptional cacheBuilder subscriberGlobalID', () {
      expect(GetIntOptionalResponse.cacheBuilder.subscriberGlobalID,
          'GetIntOptional');
    });

    // fromCache deserializes the payload the Rust runtime emits on a cache update.
    test('String fromCache', () {
      final result =
          GetStringResponse.cacheBuilder.fromCache({'string': 'updated'});
      expect(result.string, 'updated');
    });

    test('StringOptional fromCache (non-null)', () {
      final result = GetStringOptionalResponse.cacheBuilder
          .fromCache({'stringOptional': 'updated'});
      expect(result.stringOptional, 'updated');
    });

    test('StringOptional fromCache (null)', () {
      final result = GetStringOptionalResponse.cacheBuilder
          .fromCache({'stringOptional': null});
      expect(result.stringOptional, isNull);
    });

    test('ID fromCache', () {
      final result =
          GetIDResponse.cacheBuilder.fromCache({'idField': 'id-updated'});
      expect(result.idField, 'id-updated');
    });

    test('IDOptional fromCache (non-null)', () {
      final result = GetIDOptionalResponse.cacheBuilder
          .fromCache({'idOptional': 'id-opt-updated'});
      expect(result.idOptional, 'id-opt-updated');
    });

    test('IDOptional fromCache (null)', () {
      final result =
          GetIDOptionalResponse.cacheBuilder.fromCache({'idOptional': null});
      expect(result.idOptional, isNull);
    });

    test('Float fromCache', () {
      final result = GetFloatResponse.cacheBuilder.fromCache({'float': 9.99});
      expect(result.float, 9.99);
    });

    test('FloatOptional fromCache (non-null)', () {
      final result = GetFloatOptionalResponse.cacheBuilder
          .fromCache({'floatOptional': 7.77});
      expect(result.floatOptional, 7.77);
    });

    test('FloatOptional fromCache (null)', () {
      final result = GetFloatOptionalResponse.cacheBuilder
          .fromCache({'floatOptional': null});
      expect(result.floatOptional, isNull);
    });

    test('Boolean fromCache', () {
      final result =
          GetBooleanResponse.cacheBuilder.fromCache({'boolean': false});
      expect(result.boolean, false);
    });

    test('BooleanOptional fromCache (non-null)', () {
      final result = GetBooleanOptionalResponse.cacheBuilder
          .fromCache({'booleanOptional': true});
      expect(result.booleanOptional, true);
    });

    test('BooleanOptional fromCache (null)', () {
      final result = GetBooleanOptionalResponse.cacheBuilder
          .fromCache({'booleanOptional': null});
      expect(result.booleanOptional, isNull);
    });

    test('Int fromCache', () {
      final result = GetIntResponse.cacheBuilder.fromCache({'intField': 999});
      expect(result.intField, 999);
    });

    test('IntOptional fromCache (non-null)', () {
      final result =
          GetIntOptionalResponse.cacheBuilder.fromCache({'intOptional': 42});
      expect(result.intOptional, 42);
    });

    test('IntOptional fromCache (null)', () {
      final result =
          GetIntOptionalResponse.cacheBuilder.fromCache({'intOptional': null});
      expect(result.intOptional, isNull);
    });
  });
}
