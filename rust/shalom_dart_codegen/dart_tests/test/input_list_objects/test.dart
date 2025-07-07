import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/InputListOfRequiredObjects.shalom.dart';
import '__graphql__/InputListObjectsMAybe.shalom.dart';
import '__graphql__/InputListOfOptionalObjectsWithNullDefault.shalom.dart';
import '__graphql__/InputObjectContainingListOfObjects.shalom.dart';

void main() {
  group('Input List of Objects Tests', () {
    final sampleObject1 = MyInputObject(
      id: "1",
      name: "Object One",
      value: 100,
    );

    final sampleObject2 = MyInputObject(
      id: "2",
      name: "Object Two",
      value: 200,
    );

    group('InputListOfRequiredObjects - [MyInputObject!]!', () {
      test('listOfRequiredObjectsRequired - with objects', () {
        final variables = InputListOfRequiredObjectsVariables(
          items: [sampleObject1, sampleObject2],
        );

        final request =
            RequestInputListOfRequiredObjects(variables: variables).toRequest();

        expect(request.variables, {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
            {'id': '2', 'name': 'Object Two', 'value': 200},
          ],
        });

        // Test fromJson
        final variablesFromJson = InputListOfRequiredObjectsVariables(
          items: [
            MyInputObject(id: "1", name: "Object One", value: 100),
            MyInputObject(id: "2", name: "Object Two", value: 200),
          ],
        );
        expect(variablesFromJson.toJson(), variables.toJson());

        // Test updateWith
        final updatedVariables = variables.updateWith(items: [sampleObject1]);
        expect(updatedVariables.toJson(), {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
          ],
        });

        // Test equality
        final variables2 = InputListOfRequiredObjectsVariables(
          items: [sampleObject1, sampleObject2],
        );
        expect(variables.toJson(), variables2.toJson());
      });

      test('listOfRequiredObjectsRequired - empty list', () {
        final variables = InputListOfRequiredObjectsVariables(items: []);

        final request =
            RequestInputListOfRequiredObjects(variables: variables).toRequest();

        expect(request.variables, {'items': []});
      });
    });

    group('InputListObjectsMAybe - [MyInputObject!]', () {
      test('listOfRequiredObjectsOptional - None', () {
        final variables = InputListObjectsMAybeVariables();

        final request =
            RequestInputListObjectsMAybe(variables: variables).toRequest();

        expect(request.variables, {});

        // Test updateWith
        final updatedVariables = variables.updateWith(
          items: Some(Some([sampleObject1])),
        );
        expect(updatedVariables.toJson(), {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
          ],
        });
      });

      test('listOfRequiredObjectsOptional - Some(list)', () {
        final variables = InputListObjectsMAybeVariables(
          items: Some([sampleObject1, sampleObject2]),
        );

        final request =
            RequestInputListObjectsMAybe(variables: variables).toRequest();

        expect(request.variables, {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
            {'id': '2', 'name': 'Object Two', 'value': 200},
          ],
        });
      });

      test('listOfRequiredObjectsOptional - Some(null)', () {
        final variables = InputListObjectsMAybeVariables(items: Some(null));

        final request =
            RequestInputListObjectsMAybe(variables: variables).toRequest();

        expect(request.variables, {'items': null});
      });
    });

    group(
      'InputListOfOptionalObjectsWithNullDefault - [MyInputObject!] = null',
      () {
        test('listOfRequiredObjectsOptionalWithNullDefault - null default', () {
          final variables =
              InputListOfOptionalObjectsWithNullDefaultVariables();

          final request =
              RequestInputListOfOptionalObjectsWithNullDefault(
                variables: variables,
              ).toRequest();

          expect(request.variables, {'items': null});
        });

        test('listOfRequiredObjectsOptionalWithNullDefault - with objects', () {
          final variables = InputListOfOptionalObjectsWithNullDefaultVariables(
            items: [sampleObject1],
          );

          final request =
              RequestInputListOfOptionalObjectsWithNullDefault(
                variables: variables,
              ).toRequest();

          expect(request.variables, {
            'items': [
              {'id': '1', 'name': 'Object One', 'value': 100},
            ],
          });

          // Test updateWith
          final updatedVariables = variables.updateWith(
            items: Some([sampleObject1, sampleObject2]),
          );
          expect(updatedVariables.toJson(), {
            'items': [
              {'id': '1', 'name': 'Object One', 'value': 100},
              {'id': '2', 'name': 'Object Two', 'value': 200},
            ],
          });
        });

        test(
          'listOfRequiredObjectsOptionalWithNullDefault - explicit null',
          () {
            final variables =
                InputListOfOptionalObjectsWithNullDefaultVariables(items: null);

            final request =
                RequestInputListOfOptionalObjectsWithNullDefault(
                  variables: variables,
                ).toRequest();

            expect(request.variables, {'items': null});
          },
        );
      },
    );

    group('InputObjectContainingListOfObjects - ContainerInput!', () {
      test('containerInputRequired - with required nested items', () {
        final containerInput = ContainerInput(
          title: "Container Title",
          nestedItems: [sampleObject1, sampleObject2],
        );

        final variables = InputObjectContainingListOfObjectsVariables(
          data: containerInput,
        );

        final request =
            RequestInputObjectContainingListOfObjects(
              variables: variables,
            ).toRequest();

        expect(request.variables, {
          'data': {
            'title': 'Container Title',
            'nestedItems': [
              {'id': '1', 'name': 'Object One', 'value': 100},
              {'id': '2', 'name': 'Object Two', 'value': 200},
            ],
          },
        });
      });

      test('containerInputRequired - basic test', () {
        final containerInput = ContainerInput(
          title: "Container Title",
          nestedItems: [sampleObject1],
        );

        final variables = InputObjectContainingListOfObjectsVariables(
          data: containerInput,
        );

        final request =
            RequestInputObjectContainingListOfObjects(
              variables: variables,
            ).toRequest();

        expect(request.variables, {
          'data': {
            'title': 'Container Title',
            'nestedItems': [
              {'id': '1', 'name': 'Object One', 'value': 100},
            ],
          },
        });
      });

      test('containerInputRequired - updateWith', () {
        final containerInput = ContainerInput(
          title: "Original Title",
          nestedItems: [sampleObject1],
        );

        final variables = InputObjectContainingListOfObjectsVariables(
          data: containerInput,
        );

        final updatedContainer = containerInput.updateWith(
          title: "Updated Title",
        );

        final updatedVariables = variables.updateWith(data: updatedContainer);

        expect(updatedVariables.toJson(), {
          'data': {
            'title': 'Updated Title',
            'nestedItems': [
              {'id': '1', 'name': 'Object One', 'value': 100},
            ],
          },
        });
      });
    });

    group('Input Object Tests', () {
      test('MyInputObject - required fields', () {
        final obj = MyInputObject(
          id: "test-id",
          name: "Test Object",
          value: 42,
        );

        expect(obj.toJson(), {
          'id': 'test-id',
          'name': 'Test Object',
          'value': 42,
        });

        // Test updateWith
        final updatedObj = obj.updateWith(name: "Updated Name", value: 100);

        expect(updatedObj.toJson(), {
          'id': 'test-id',
          'name': 'Updated Name',
          'value': 100,
        });

        // Test equality
        final obj2 = MyInputObject(
          id: "test-id",
          name: "Test Object",
          value: 42,
        );
        expect(obj.toJson(), obj2.toJson());
      });
    });
  });
}
