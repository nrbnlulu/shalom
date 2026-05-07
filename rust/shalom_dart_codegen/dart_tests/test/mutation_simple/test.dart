import 'package:test/test.dart';
import '__graphql__/UpdateUserName.shalom.dart';

void main() {
  group('mutation_simple — Data', () {
    test('fromCache with non-null user', () {
      final data = UpdateUserNameData.fromCache({
        'updateUserName': {'id': '1', 'name': 'Alice'},
      });
      expect(data.updateUserName?.id, '1');
      expect(data.updateUserName?.name, 'Alice');
    });

    test('fromCache with null user', () {
      final data = UpdateUserNameData.fromCache({'updateUserName': null});
      expect(data.updateUserName, isNull);
    });

    test('toJson roundtrip', () {
      final data = UpdateUserNameData(
        updateUserName: UpdateUserName_updateUserName(
          id: '42',
          name: 'Bob',
        ),
      );
      final json = data.toJson();
      expect(json['updateUserName'], isA<Map>());
      final nested = json['updateUserName'] as Map;
      expect(nested['id'], '42');
      expect(nested['name'], 'Bob');
    });

    test('toJson with null user', () {
      final data = UpdateUserNameData(updateUserName: null);
      expect(data.toJson()['updateUserName'], isNull);
    });
  });

  group('mutation_simple — Variables', () {
    test('toJson serializes all fields', () {
      final vars = UpdateUserNameVariables(id: '7', name: 'Carol');
      final json = vars.toJson();
      expect(json['id'], '7');
      expect(json['name'], 'Carol');
    });

    test('equality', () {
      final a = UpdateUserNameVariables(id: '1', name: 'Alice');
      final b = UpdateUserNameVariables(id: '1', name: 'Alice');
      final c = UpdateUserNameVariables(id: '2', name: 'Alice');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('hashCode matches for equal instances', () {
      final a = UpdateUserNameVariables(id: '1', name: 'Alice');
      final b = UpdateUserNameVariables(id: '1', name: 'Alice');
      expect(a.hashCode, b.hashCode);
    });
  });
}
