import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/declarative_raw_fragments/__graphql__/UserCardQuery.shalom.dart';

void main() {
  group('declarative operation with raw fragments', () {
    test('registers raw fragment dependencies in shalom init', () {
      final initFile = File('lib/graphql/__graphql__/shalom_init.shalom.dart');

      expect(initFile.existsSync(), isTrue);

      final init = initFile.readAsStringSync();
      final identityIndex = init.indexOf('fragment UserIdentity on User');
      final cardIndex = init.indexOf('fragment UserCard on User');
      final queryIndex = init.indexOf('query UserCardQuery');

      expect(identityIndex, isNonNegative);
      expect(cardIndex, isNonNegative);
      expect(queryIndex, isNonNegative);
      expect(identityIndex, lessThan(cardIndex));
      expect(cardIndex, lessThan(queryIndex));
    });

    test('generates response fields from nested raw fragments', () {
      final response = UserCardQueryResponse.fromJson({
        'user': {'id': '1', 'name': 'Alice', 'email': 'alice@example.com'},
      });

      expect(response.user?.id, '1');
      expect(response.user?.name, 'Alice');
      expect(response.user?.email, 'alice@example.com');
    });
  });
}
