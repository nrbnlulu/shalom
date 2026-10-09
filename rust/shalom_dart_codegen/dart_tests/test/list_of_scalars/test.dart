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
      final result = ListofScalarsRequiredData.fromJson(
        listOfScalarsRequiredData,
      );
      expect(result.listOfScalarsRequired, ['hello', 'world', 'test']);
    });

    test('listOfScalarsRequired deserialize with empty list', () {
      final result = ListofScalarsRequiredData.fromJson(
        listOfScalarsRequiredEmptyData,
      );
      expect(result.listOfScalarsRequired, []);
    });

    test('listOfScalarsRequired toJson', () {
      final initial = ListofScalarsRequiredData.fromJson(
        listOfScalarsRequiredData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsRequiredData);
    });

    test('listOfScalarsRequired toJson with empty list', () {
      final initial = ListofScalarsRequiredData.fromJson(
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
      final result = ListOfScalarsOptionalData.fromJson(
        listOfScalarsOptionalData,
      );
      expect(result.listOfScalarsOptional, ['hello', 'world', 'test']);
    });

    test('listOfScalarsOptional deserialize with null', () {
      final result = ListOfScalarsOptionalData.fromJson(
        listOfScalarsOptionalNullData,
      );
      expect(result.listOfScalarsOptional, isNull);
    });

    test('listOfScalarsOptional deserialize with empty list', () {
      final result = ListOfScalarsOptionalData.fromJson(
        listOfScalarsOptionalEmptyData,
      );
      expect(result.listOfScalarsOptional, []);
    });

    test('listOfScalarsOptional toJson', () {
      final initial = ListOfScalarsOptionalData.fromJson(
        listOfScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalData);
    });

    test('listOfScalarsOptional toJson with null', () {
      final initial = ListOfScalarsOptionalData.fromJson(
        listOfScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfScalarsOptionalNullData);
    });

    test('listOfScalarsOptional toJson with empty list', () {
      final initial = ListOfScalarsOptionalData.fromJson(
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
      final result = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      expect(result.listOfOptionalScalarsOptional, [1, 2, 3]);
    });

    test('listOfOptionalScalarsOptional deserialize with null', () {
      final result = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      expect(result.listOfOptionalScalarsOptional, isNull);
    });

    test('listOfOptionalScalarsOptional deserialize with empty list', () {
      final result = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      expect(result.listOfOptionalScalarsOptional, []);
    });

    test('listOfOptionalScalarsOptional toJson', () {
      final initial = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalData);
    });

    test('listOfOptionalScalarsOptional toJson with null', () {
      final initial = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalNullData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalNullData);
    });

    test('listOfOptionalScalarsOptional toJson with empty list', () {
      final initial = ListOfOptionalScalarsOptionalData.fromJson(
        listOfOptionalScalarsOptionalEmptyData,
      );
      final json = initial.toJson();
      expect(json, listOfOptionalScalarsOptionalEmptyData);
    });
  });
}
