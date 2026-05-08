import 'package:test/test.dart';
import "__graphql__/ListofScalarsRequired.shalom.dart";
import "__graphql__/ListOfScalarsOptional.shalom.dart";
import "__graphql__/ListOfOptionalScalarsOptional.shalom.dart";

void main() {
  group('List of Scalars Required', () {
    final listOfScalarsRequiredData = {
      'listOfScalarsRequired': ['hello', 'world', 'test'],
    };
    final listOfScalarsRequiredDataChanged = {
      'listOfScalarsRequired': ['foo', 'bar', 'baz'],
    };
    final listOfScalarsRequiredEmptyData = {'listOfScalarsRequired': []};

    test('listOfScalarsRequired deserialize', () {
      final result = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
      );
      expect(result.listOfScalarsRequired, ['hello', 'world', 'test']);
    });

    test('listOfScalarsRequired deserialize with empty list', () {
      final result = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredEmptyData,
      );
      expect(result.listOfScalarsRequired, []);
    });

    test('listOfScalarsRequired toJson', () {
      final initial = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredData);
    });

    test('listOfScalarsRequired toJson with empty list', () {
      final initial = ListofScalarsRequiredResponse.fromJson(
        listOfScalarsRequiredEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredEmptyData);
    });
  });

  group('List of Scalars Optional', () {
    final listOfScalarsOptionalData = {
      'listOfScalarsOptional': ['hello', 'world', 'test'],
    };
    final listOfScalarsOptionalDataChanged = {
      'listOfScalarsOptional': ['foo', 'bar', 'baz'],
    };
    final listOfScalarsOptionalNullData = {'listOfScalarsOptional': null};
    final listOfScalarsOptionalEmptyData = {'listOfScalarsOptional': []};

    test('listOfScalarsOptional deserialize', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
      );
      expect(result.listOfScalarsOptional, ['hello', 'world', 'test']);
    });

    test('listOfScalarsOptional deserialize with null', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
      );
      expect(result.listOfScalarsOptional, isNull);
    });

    test('listOfScalarsOptional deserialize with empty list', () {
      final result = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalEmptyData,
      );
      expect(result.listOfScalarsOptional, []);
    });

    test('listOfScalarsOptional toJson', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalData);
    });

    test('listOfScalarsOptional toJson with null', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalNullData);
    });

    test('listOfScalarsOptional toJson with empty list', () {
      final initial = ListOfScalarsOptionalResponse.fromJson(
        listOfScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalEmptyData);
    });
  });

  group('List of Optional Scalars Optional', () {
    final listOfOptionalScalarsOptionalData = {
      'listOfOptionalScalarsOptional': [1, 2, 3],
    };
    final listOfOptionalScalarsOptionalDataChanged = {
      'listOfOptionalScalarsOptional': [4, 5, 6],
    };
    final listOfOptionalScalarsOptionalNullData = {
      'listOfOptionalScalarsOptional': null,
    };
    final listOfOptionalScalarsOptionalEmptyData = {
      'listOfOptionalScalarsOptional': [],
    };

    test('listOfOptionalScalarsOptional deserialize', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      expect(result.listOfOptionalScalarsOptional, [1, 2, 3]);
    });

    test('listOfOptionalScalarsOptional deserialize with null', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      expect(result.listOfOptionalScalarsOptional, isNull);
    });

    test('listOfOptionalScalarsOptional deserialize with empty list', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      expect(result.listOfOptionalScalarsOptional, []);
    });

    test('listOfOptionalScalarsOptional toJson', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalData);
    });

    test('listOfOptionalScalarsOptional toJson with null', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalNullData);
    });

    test('listOfOptionalScalarsOptional toJson with empty list', () {
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalEmptyData);
    });
  });
}
