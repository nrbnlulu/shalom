import 'package:test/test.dart';
import "__graphql__/ListofScalarsRequired.shalom.dart";
import "__graphql__/ListOfScalarsOptional.shalom.dart";
import "__graphql__/ListOfOptionalScalarsOptional.shalom.dart";

void main() {
  group('List of Scalars Deserialize', () {
    test('ListofScalarsRequired', () {
      final result = ListofScalarsRequiredResponse.fromJson({
        'listOfScalarsRequired': ['hello', 'world', 'test'],
      }, null);
      expect(result.listOfScalarsRequired, ['hello', 'world', 'test']);
    });

    test('ListofScalarsRequired with empty list', () {
      final result = ListofScalarsRequiredResponse.fromJson({
        'listOfScalarsRequired': [],
      }, null);
      expect(result.listOfScalarsRequired, []);
    });

    test('ListOfScalarsOptional', () {
      final result = ListOfScalarsOptionalResponse.fromJson({
        'listOfScalarsOptional': ['hello', 'world', 'test'],
      }, null);
      expect(result.listOfScalarsOptional, ['hello', 'world', 'test']);
    });

    test('ListOfScalarsOptional with null', () {
      final result = ListOfScalarsOptionalResponse.fromJson({
        'listOfScalarsOptional': null,
      }, null);
      expect(result.listOfScalarsOptional, isNull);
    });

    test('ListOfScalarsOptional with empty list', () {
      final result = ListOfScalarsOptionalResponse.fromJson({
        'listOfScalarsOptional': [],
      }, null);
      expect(result.listOfScalarsOptional, []);
    });

    test('ListOfOptionalScalarsOptional', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson({
        'listOfOptionalScalarsOptional': [1, 2, 3],
      }, null);
      expect(result.listOfOptionalScalarsOptional, [1, 2, 3]);
    });

    test('ListOfOptionalScalarsOptional with null', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson({
        'listOfOptionalScalarsOptional': null,
      }, null);
      expect(result.listOfOptionalScalarsOptional, isNull);
    });

    test('ListOfOptionalScalarsOptional with empty list', () {
      final result = ListOfOptionalScalarsOptionalResponse.fromJson({
        'listOfOptionalScalarsOptional': [],
      }, null);
      expect(result.listOfOptionalScalarsOptional, []);
    });
  });

  group("List of Scalars updateWithJson", () {
    test("ListofScalarsRequired", () {
      final initial = ListofScalarsRequiredResponse(
        listOfScalarsRequired: ["hello", "world"],
      );
      final updated = initial.updateWithJson({
        'listOfScalarsRequired': ['foo', 'bar', 'baz'],
      });
      expect(updated.listOfScalarsRequired, ['foo', 'bar', 'baz']);
      expect(initial, isNot(updated));
    });

    test("ListofScalarsRequired without update", () {
      final initial = ListofScalarsRequiredResponse(
        listOfScalarsRequired: ["hello", "world"],
      );
      final updated = initial.updateWithJson({});
      expect(updated.listOfScalarsRequired, ["hello", "world"]);
      expect(initial, updated);
    });

    test("ListOfScalarsOptional", () {
      final initial = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["hello", "world"],
      );
      final updated = initial.updateWithJson({
        'listOfScalarsOptional': ['foo', 'bar', 'baz'],
      });
      expect(updated.listOfScalarsOptional, ['foo', 'bar', 'baz']);
      expect(initial, isNot(updated));
    });

    test("ListOfScalarsOptional with null", () {
      final initial = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["hello", "world"],
      );
      final updated = initial.updateWithJson({'listOfScalarsOptional': null});
      expect(updated.listOfScalarsOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("ListOfScalarsOptional without update", () {
      final initial = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["hello", "world"],
      );
      final updated = initial.updateWithJson({});
      expect(updated.listOfScalarsOptional, ["hello", "world"]);
      expect(initial, updated);
    });

    test("ListOfOptionalScalarsOptional", () {
      final initial = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [1, 2, 3],
      );
      final updated = initial.updateWithJson({
        'listOfOptionalScalarsOptional': [4, 5, 6],
      });
      expect(updated.listOfOptionalScalarsOptional, [4, 5, 6]);
      expect(initial, isNot(updated));
    });

    test("ListOfOptionalScalarsOptional with null", () {
      final initial = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [1, 2, 3],
      );
      final updated = initial.updateWithJson({
        'listOfOptionalScalarsOptional': null,
      });
      expect(updated.listOfOptionalScalarsOptional, isNull);
      expect(initial, isNot(updated));
    });

    test("ListOfOptionalScalarsOptional without update", () {
      final initial = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [1, 2, 3],
      );
      final updated = initial.updateWithJson({});
      expect(updated.listOfOptionalScalarsOptional, [1, 2, 3]);
      expect(initial, updated);
    });
  });

  group("List of Scalars toJson", () {
    test("ListofScalarsRequired", () {
      final data = {
        "listOfScalarsRequired": ["foo", "bar", "baz"],
      };
      final initial = ListofScalarsRequiredResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListofScalarsRequired with empty list", () {
      final data = {"listOfScalarsRequired": []};
      final initial = ListofScalarsRequiredResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfScalarsOptional", () {
      final data = {
        "listOfScalarsOptional": ["foo", "bar", "baz"],
      };
      final initial = ListOfScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfScalarsOptional with null", () {
      final data = {"listOfScalarsOptional": null};
      final initial = ListOfScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfScalarsOptional with empty list", () {
      final data = {"listOfScalarsOptional": []};
      final initial = ListOfScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfOptionalScalarsOptional", () {
      final data = {
        "listOfOptionalScalarsOptional": [1, 2, 3],
      };
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfOptionalScalarsOptional with null", () {
      final data = {"listOfOptionalScalarsOptional": null};
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("ListOfOptionalScalarsOptional with empty list", () {
      final data = {"listOfOptionalScalarsOptional": []};
      final initial = ListOfOptionalScalarsOptionalResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });
  });

  group("List of Scalars equality", () {
    test("ListofScalarsRequired equality", () {
      final first = ListofScalarsRequiredResponse(
        listOfScalarsRequired: ["hello", "world"],
      );
      final second = ListofScalarsRequiredResponse(
        listOfScalarsRequired: ["hello", "world"],
      );
      final different = ListofScalarsRequiredResponse(
        listOfScalarsRequired: ["foo", "bar"],
      );

      expect(first, second);
      expect(first, isNot(different));
    });

    test("ListOfScalarsOptional equality", () {
      final first = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["hello", "world"],
      );
      final second = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["hello", "world"],
      );
      final different = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: ["foo", "bar"],
      );
      final nullOne = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: null,
      );
      final nullTwo = ListOfScalarsOptionalResponse(
        listOfScalarsOptional: null,
      );

      expect(first, second);
      expect(first, isNot(different));
      expect(first, isNot(nullOne));
      expect(nullOne, nullTwo);
    });

    test("ListOfOptionalScalarsOptional equality", () {
      final first = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [1, 2, 3],
      );
      final second = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [1, 2, 3],
      );
      final different = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: [4, 5, 6],
      );
      final nullOne = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: null,
      );
      final nullTwo = ListOfOptionalScalarsOptionalResponse(
        listOfOptionalScalarsOptional: null,
      );

      expect(first, second);
      expect(first, isNot(different));
      expect(first, isNot(nullOne));
      expect(nullOne, nullTwo);
    });
  });
}
