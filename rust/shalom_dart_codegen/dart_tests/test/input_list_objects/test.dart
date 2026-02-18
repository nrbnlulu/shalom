import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/schema.shalom.dart';
import '__graphql__/InputListOfRequiredObjectsMutation.shalom.dart';
import '__graphql__/InputListObjectsMaybeMutation.shalom.dart';
import '__graphql__/InputListOfOptionalObjectsWithNullDefaultMutation.shalom.dart';
import '__graphql__/InputObjectContainingListOfObjectsMutation.shalom.dart';

void main() {
  group('Input equality (==)', () {
    test('MyInputObject equality', () {
      final obj1 = MyInputObject(id: "1", name: "Test", value: 42);
      final obj2 = MyInputObject(id: "1", name: "Test", value: 42);
      expect(obj1 == obj2, isTrue);
      expect(obj1.hashCode == obj2.hashCode, isTrue);

      final obj3 = MyInputObject(id: "1", name: "Different", value: 42);
      expect(obj1 == obj3, isFalse);
    });

    test('ContainerInput with list equality', () {
      final a = ContainerInput(
        title: "Test",
        nestedItems: [MyInputObject(id: "1", name: "A", value: 1)],
      );
      final b = ContainerInput(
        title: "Test",
        nestedItems: [MyInputObject(id: "1", name: "A", value: 1)],
      );
      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('ContainerInput with different lists', () {
      final a = ContainerInput(
        title: "Test",
        nestedItems: [MyInputObject(id: "1", name: "A", value: 1)],
      );
      final b = ContainerInput(
        title: "Test",
        nestedItems: [MyInputObject(id: "2", name: "B", value: 2)],
      );
      expect(a == b, isFalse);
    });
  });

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
        final variables = InputListOfRequiredObjectsMutationVariables(
          items: [sampleObject1, sampleObject2],
        );

        final request = RequestInputListOfRequiredObjectsMutation(
          variables: variables,
        ).toRequest();

        expect(request.variables, {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
            {'id': '2', 'name': 'Object Two', 'value': 200},
          ],
        });

        // Test fromJson
        final variablesFromJson = InputListOfRequiredObjectsMutationVariables(
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
        final variables2 = InputListOfRequiredObjectsMutationVariables(
          items: [sampleObject1, sampleObject2],
        );
        expect(variables.toJson(), variables2.toJson());
      });

      test('listOfRequiredObjectsRequired - empty list', () {
        final variables = InputListOfRequiredObjectsMutationVariables(
          items: [],
        );

        final request = RequestInputListOfRequiredObjectsMutation(
          variables: variables,
        ).toRequest();

        expect(request.variables, {'items': []});
      });
    });

    group('InputListObjectsMAybe - [MyInputObject!]', () {
      test('listOfRequiredObjectsOptional - None', () {
        final variables = InputListObjectsMaybeMutationVariables();

        final request = RequestInputListObjectsMaybeMutation(
          variables: variables,
        ).toRequest();

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
        final variables = InputListObjectsMaybeMutationVariables(
          items: Some([sampleObject1, sampleObject2]),
        );

        final request = RequestInputListObjectsMaybeMutation(
          variables: variables,
        ).toRequest();

        expect(request.variables, {
          'items': [
            {'id': '1', 'name': 'Object One', 'value': 100},
            {'id': '2', 'name': 'Object Two', 'value': 200},
          ],
        });
      });

      test('listOfRequiredObjectsOptional - Some(null)', () {
        final variables = InputListObjectsMaybeMutationVariables(
          items: Some(null),
        );

        final request = RequestInputListObjectsMaybeMutation(
          variables: variables,
        ).toRequest();

        expect(request.variables, {'items': null});
      });
    });

    group(
      'InputListOfOptionalObjectsWithNullDefault - [MyInputObject!] = null',
      () {
        test('listOfRequiredObjectsOptionalWithNullDefault - null default', () {
          final variables =
              InputListOfOptionalObjectsWithNullDefaultMutationVariables();

          final request =
              RequestInputListOfOptionalObjectsWithNullDefaultMutation(
            variables: variables,
          ).toRequest();

          expect(request.variables, {'items': null});
        });

        test('listOfRequiredObjectsOptionalWithNullDefault - with objects', () {
          final variables =
              InputListOfOptionalObjectsWithNullDefaultMutationVariables(
            items: [sampleObject1],
          );

          final request =
              RequestInputListOfOptionalObjectsWithNullDefaultMutation(
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
                InputListOfOptionalObjectsWithNullDefaultMutationVariables(
              items: null,
            );

            final request =
                RequestInputListOfOptionalObjectsWithNullDefaultMutation(
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

        final variables = InputObjectContainingListOfObjectsMutationVariables(
          data: containerInput,
        );

        final request = RequestInputObjectContainingListOfObjectsMutation(
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

        final variables = InputObjectContainingListOfObjectsMutationVariables(
          data: containerInput,
        );

        final request = RequestInputObjectContainingListOfObjectsMutation(
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

        final variables = InputObjectContainingListOfObjectsMutationVariables(
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
