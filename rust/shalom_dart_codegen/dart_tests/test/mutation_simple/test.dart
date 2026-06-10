import 'package:test/test.dart';
import '__graphql__/ProfileCard.shalom.dart';
import '__graphql__/UpdateUserName.shalom.dart';
import '__graphql__/UpdateUserProfile.mutation.shalom.dart';
import '__graphql__/UpdateUserProfile.shalom.dart';
import '__graphql__/schema.shalom.dart';

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

  group('mutation_simple — Fragments in @Mutation SDL', () {
    test('mutationFragmentRequired deserializes spread fragment fields', () {
      final data = UpdateUserProfileData.fromCache({
        'updateUserProfile': {
          'id': '1',
          'email': 'alice@example.com',
          'profileImage': 'https://example.com/alice.png',
        },
      });

      expect(data.updateUserProfile.id, '1');
      expect(data.updateUserProfile.email, 'alice@example.com');
      expect(
        data.updateUserProfile.profileImage,
        'https://example.com/alice.png',
      );
    });

    test('mutationFragmentRequired implements fragment interface', () {
      final data = UpdateUserProfileData.fromCache({
        'updateUserProfile': {
          'id': '1',
          'email': 'alice@example.com',
          'profileImage': 'https://example.com/alice.png',
        },
      });

      final ProfileCard profile = data.updateUserProfile;
      expect(profile.id, '1');
      expect(profile.email, 'alice@example.com');
      expect(profile.profileImage, 'https://example.com/alice.png');
    });

    test('mutationFragmentToJson serializes spread fragment fields', () {
      final data = UpdateUserProfileData(
        updateUserProfile: UpdateUserProfile_updateUserProfile(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );

      expect(data.toJson(), {
        'updateUserProfile': {
          'id': '1',
          'email': 'alice@example.com',
          'profileImage': 'https://example.com/alice.png',
        },
      });
    });

    test('mutationFragmentEquals compares fragment fields', () {
      final a = UpdateUserProfileData(
        updateUserProfile: UpdateUserProfile_updateUserProfile(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );
      final b = UpdateUserProfileData(
        updateUserProfile: UpdateUserProfile_updateUserProfile(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );
      final c = UpdateUserProfileData(
        updateUserProfile: UpdateUserProfile_updateUserProfile(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/other.png',
        ),
      );

      expect(a.updateUserProfile, equals(b.updateUserProfile));
      expect(a.updateUserProfile, isNot(equals(c.updateUserProfile)));
    });

    test('mutationFragmentCacheNormalization uses fragment fields', () {
      final first = UpdateUserProfileData.fromCache({
        'updateUserProfile': {
          'id': '1',
          'email': 'first@example.com',
          'profileImage': 'https://example.com/first.png',
        },
      });
      final second = UpdateUserProfileData.fromCache({
        'updateUserProfile': {
          'id': '1',
          'email': 'second@example.com',
          'profileImage': 'https://example.com/second.png',
        },
      });

      expect(first.updateUserProfile.id, second.updateUserProfile.id);
      expect(second.updateUserProfile.email, 'second@example.com');
      expect(
        second.updateUserProfile.profileImage,
        'https://example.com/second.png',
      );
    });

    test('mutationFragmentVariables toJson and equality', () {
      final a = UpdateUserProfileVariables(
        input: UpdateProfileInput(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );
      final b = UpdateUserProfileVariables(
        input: UpdateProfileInput(
          id: '1',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );
      final c = UpdateUserProfileVariables(
        input: UpdateProfileInput(
          id: '2',
          email: 'alice@example.com',
          profileImage: 'https://example.com/alice.png',
        ),
      );

      expect(a.toJson(), {
        'input': {
          'id': '1',
          'email': 'alice@example.com',
          'profileImage': 'https://example.com/alice.png',
        },
      });
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
