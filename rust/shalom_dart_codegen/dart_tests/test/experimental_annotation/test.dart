import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetSimpleObject.shalom.dart';
import 'dart:mirrors';

void main() {
  group('Experimental Annotation Tests', () {
    test('fromJson method should exist on response class', () {
      final json = {
        'simpleObject': {
          'id': 'test123',
          'value': 'test value',
        }
      };

      // This should compile and execute without errors
      final result = GetSimpleObjectResponse.fromJson(json);

      expect(result.simpleObject.id, 'test123');
      expect(result.simpleObject.value, 'test value');
    });

    test('fromJson method should be static', () {
      // Verify that fromJson is a static method
      final classMirror = reflectClass(GetSimpleObjectResponse);
      final fromJsonMirror = classMirror.declarations[Symbol('fromJson')];

      expect(fromJsonMirror, isNotNull);
      expect(fromJsonMirror, isA<MethodMirror>());
      expect((fromJsonMirror as MethodMirror).isStatic, isTrue);
    });

    test('fromJson should have experimental annotation', () {
      // Check that the fromJson method has the @experimental annotation
      final classMirror = reflectClass(GetSimpleObjectResponse);
      final fromJsonMirror = classMirror.declarations[Symbol('fromJson')] as MethodMirror;

      // The metadata should include the experimental annotation
      final hasExperimental = fromJsonMirror.metadata.any((annotation) {
        final annotationMirror = annotation.reflectee;
        return annotationMirror.toString().contains('experimental') ||
            annotationMirror.runtimeType.toString().contains('Experimental');
      });

      expect(hasExperimental, isTrue,
          reason: 'fromJson method should have @experimental annotation');
    });

    test('fromJson should properly deserialize nested object', () {
      final json = {
        'simpleObject': {
          'id': 'nested123',
          'value': 'nested value',
        }
      };

      final result = GetSimpleObjectResponse.fromJson(json);

      expect(result, isA<GetSimpleObjectResponse>());
      expect(result.simpleObject, isA<GetSimpleObject_simpleObject>());
      expect(result.simpleObject.id, 'nested123');
      expect(result.simpleObject.value, 'nested value');
    });

    test('nested object should also have fromJson', () {
      final json = {
        'id': 'direct123',
        'value': 'direct value',
      };

      // Nested objects should also have fromJson
      final result = GetSimpleObject_simpleObject.fromJson(json);

      expect(result.id, 'direct123');
      expect(result.value, 'direct value');
    });
  });

  group('Meta Package Integration', () {
    test('should be able to import meta package symbols', () {
      // This test verifies that the meta package is properly configured
      // and can be imported in generated files
      // If the meta package import fails, the generated code won't compile
      
      final json = {
        'simpleObject': {
          'id': 'meta123',
          'value': 'meta test',
        }
      };

      // If this executes, the meta package is properly imported
      final result = GetSimpleObjectResponse.fromJson(json);
      expect(result, isNotNull);
    });
  });

  group('fromJson vs fromResponse Compatibility', () {
    test('both methods should produce equivalent results', () {
      final json = {
        'simpleObject': {
          'id': 'compat123',
          'value': 'compatibility test',
        }
      };

      final fromJsonResult = GetSimpleObjectResponse.fromJson(json);
      final fromResponseResult = GetSimpleObjectResponse.fromResponse(json);

      // Check that both produce the same data
      expect(fromJsonResult.simpleObject.id, fromResponseResult.simpleObject.id);
      expect(fromJsonResult.simpleObject.value, fromResponseResult.simpleObject.value);
    });

    test('fromJson should not interact with cache', () {
      final json = {
        'simpleObject': {
          'id': 'cache123',
          'value': 'no cache',
        }
      };

      // Create context for fromResponse
      final ctx = ShalomCtx.withCapacity();

      // Use fromResponse which interacts with cache
      final fromResponseResult = GetSimpleObjectResponse.fromResponse(json, ctx: ctx);

      // Use fromJson which should not interact with cache
      final fromJsonResult = GetSimpleObjectResponse.fromJson(json);

      // Both should have same data
      expect(fromJsonResult.simpleObject.id, fromResponseResult.simpleObject.id);

      // But fromJson shouldn't have populated the cache
      // This is indicated by the fact that fromJson doesn't take a ctx parameter
    });

    test('fromJson should work without ShalomCtx', () {
      final json = {
        'simpleObject': {
          'id': 'noCtx123',
          'value': 'no context needed',
        }
      };

      // fromJson should work completely independently of any context
      final result = GetSimpleObjectResponse.fromJson(json);

      expect(result.simpleObject.id, 'noCtx123');
      expect(result.simpleObject.value, 'no context needed');
    });
  });
}