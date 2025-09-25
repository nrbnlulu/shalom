import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '../input_list_custom_scalars/__graphql__/schema.shalom.dart';
import '__graphql__/InputCustomScalarListRequiredMutation.shalom.dart';
import '__graphql__/InputCustomScalarListMaybeMutation.shalom.dart';
import '__graphql__/InputCustomScalarListNullableMaybeMutation.shalom.dart';
import '__graphql__/InputCustomScalarListOptionalWithDefaultMutation.shalom.dart';
import '__graphql__/InputCustomScalarListInsideInputObjectMutation.shalom.dart';
import '../custom_scalar/point.dart';

void main() {
  final Point point1 = Point(x: 10, y: 20);
  final Point point2 = Point(x: 30, y: 40);
  final Point point3 = Point(x: 50, y: 60);
  final List<Point> samplePoints = [point1, point2, point3];

  group('Input List Custom Scalars', () {
    test('customScalarListRequired', () {
      final variables = InputCustomScalarListRequiredMutationVariables(
        requiredItems: samplePoints,
      );
      expect(variables.toJson(), {
        'requiredItems': ['POINT (10, 20)', 'POINT (30, 40)', 'POINT (50, 60)'],
      });

      final newVariables = variables.updateWith(
        requiredItems: [point1, point2],
      );
      expect(newVariables.toJson(), {
        'requiredItems': ['POINT (10, 20)', 'POINT (30, 40)'],
      });

      expect(newVariables.requiredItems, [point1, point2]);
      expect(newVariables == variables, false);
    });

    test('customScalarListMaybe', () {
      final variables = InputCustomScalarListMaybeMutationVariables(
        optionalItems: None(),
      );
      expect(variables.toJson(), {});

      final someVariables = variables.updateWith(
        optionalItems: Some(Some(samplePoints)),
      );
      expect(someVariables.toJson(), {
        'optionalItems': ['POINT (10, 20)', 'POINT (30, 40)', 'POINT (50, 60)'],
      });

      final someWithNullValue = someVariables.updateWith(
        optionalItems: Some(Some(null)),
      );
      expect(someWithNullValue.toJson(), {'optionalItems': null});

      expect(someVariables.optionalItems.some(), samplePoints);
      expect(someWithNullValue.optionalItems.some(), null);
    });

    test('customScalarListNullableMaybe', () {
      final variables = InputCustomScalarListNullableMaybeMutationVariables(
        sparseData: None(),
      );
      expect(variables.toJson(), {});

      final someVariables = variables.updateWith(
        sparseData: Some(Some([point1, null, point3])),
      );
      expect(someVariables.toJson(), {
        'sparseData': ['POINT (10, 20)', null, 'POINT (50, 60)'],
      });

      final someWithNullValue = someVariables.updateWith(
        sparseData: Some(Some(null)),
      );
      expect(someWithNullValue.toJson(), {'sparseData': null});

      expect(someVariables.sparseData.some(), [point1, null, point3]);
      expect(someWithNullValue.sparseData.some(), null);
    });

    test('customScalarListOptionalWithDefault', () {
      final variables =
          InputCustomScalarListOptionalWithDefaultMutationVariables();
      expect(variables.toJson(), {'defaultItems': null});

      final variablesWithValues = variables.updateWith(
        defaultItems: Some(samplePoints),
      );
      expect(variablesWithValues.toJson(), {
        'defaultItems': ['POINT (10, 20)', 'POINT (30, 40)', 'POINT (50, 60)'],
      });

      expect(variablesWithValues.defaultItems, samplePoints);
    });

    test('customScalarListInsideInputObject', () {
      final variables = InputCustomScalarListInsideInputObjectMutationVariables(
        newContainer: ItemContainerInput(
          name: 'Test Container',
          requiredItems: [point1, point2],
          optionalItems: None(),
          flexibleItems: [point3, null],
        ),
      );
      expect(variables.toJson(), {
        'newContainer': {
          'name': 'Test Container',
          'requiredItems': ['POINT (10, 20)', 'POINT (30, 40)'],
          'flexibleItems': ['POINT (50, 60)', null],
        },
      });

      final updatedVariables = variables.updateWith(
        newContainer: variables.newContainer.updateWith(
          name: 'Updated Container',
          requiredItems: [point1],
          optionalItems: Some(Some([point2, null, point3])),
          flexibleItems: [point1, point2, point3],
        ),
      );
      expect(updatedVariables.toJson(), {
        'newContainer': {
          'name': 'Updated Container',
          'requiredItems': ['POINT (10, 20)'],
          'optionalItems': ['POINT (30, 40)', null, 'POINT (50, 60)'],
          'flexibleItems': [
            'POINT (10, 20)',
            'POINT (30, 40)',
            'POINT (50, 60)',
          ],
        },
      });

      expect(updatedVariables.newContainer.requiredItems, [point1]);
      expect(updatedVariables.newContainer.optionalItems.some(), [
        point2,
        null,
        point3,
      ]);
      expect(updatedVariables.newContainer.flexibleItems, [
        point1,
        point2,
        point3,
      ]);
    });
  });
}
