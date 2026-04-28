import 'package:test/test.dart';
import '__graphql__/GetUser.shalom.dart';

void main() {
  group('GetUser_user', () {
    test('fromJson deserializes fields', () {
      final user = GetUser_user.fromJson({'id': '1', 'name': 'Alice'});
      expect(user.id, '1');
      expect(user.name, 'Alice');
    });

    test('toJson round-trips', () {
      final user = GetUser_user(id: '1', name: 'Alice');
      expect(user.toJson(), {'id': '1', 'name': 'Alice'});
    });

    test('== true for same values', () {
      final a = GetUser_user(id: '1', name: 'Alice');
      final b = GetUser_user(id: '1', name: 'Alice');
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('== false when id differs', () {
      final a = GetUser_user(id: '1', name: 'Alice');
      final b = GetUser_user(id: '2', name: 'Alice');
      expect(a == b, isFalse);
    });

    test('== false when name differs', () {
      final a = GetUser_user(id: '1', name: 'Alice');
      final b = GetUser_user(id: '1', name: 'Bob');
      expect(a == b, isFalse);
    });
  });

  group('GetUserResponse', () {
    test('fromJson with user present', () {
      final resp = GetUserResponse.fromJson({
        'user': {'id': '1', 'name': 'Alice'},
      });
      expect(resp.user?.id, '1');
      expect(resp.user?.name, 'Alice');
    });

    test('fromJson with null user', () {
      final resp = GetUserResponse.fromJson({'user': null});
      expect(resp.user, isNull);
    });

    test('== true for same values', () {
      final a = GetUserResponse(user: GetUser_user(id: '1', name: 'Alice'));
      final b = GetUserResponse(user: GetUser_user(id: '1', name: 'Alice'));
      expect(a == b, isTrue);
    });

    test('== true for both null user', () {
      expect(
          GetUserResponse(user: null) == GetUserResponse(user: null), isTrue);
    });
  });

  group('GetUserData.fromCache', () {
    test('deserializes user', () {
      final data = GetUserData.fromCache({
        'user': {'id': '42', 'name': 'Bob'},
      });
      expect(data.user?.id, '42');
      expect(data.user?.name, 'Bob');
    });

    test('null user when key is null', () {
      final data = GetUserData.fromCache({'user': null});
      expect(data.user, isNull);
    });

    test('toJson round-trips', () {
      final data = GetUserData.fromCache({
        'user': {'id': '1', 'name': 'Alice'},
      });
      expect(data.toJson(), {
        'user': {'id': '1', 'name': 'Alice'},
      });
    });
  });
}
