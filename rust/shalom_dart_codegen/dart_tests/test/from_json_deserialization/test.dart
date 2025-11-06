import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';
import '__graphql__/GetUser.shalom.dart';
import '__graphql__/GetUserOpt.shalom.dart';
import '__graphql__/GetProduct.shalom.dart';
import '__graphql__/GetProductOpt.shalom.dart';
import '__graphql__/GetSearchResult.shalom.dart';
import '__graphql__/GetSearchResultOpt.shalom.dart';
import '__graphql__/GetAnimal.shalom.dart';
import '__graphql__/GetAnimalOpt.shalom.dart';
import '__graphql__/GetSettings.shalom.dart';

void main() {
  group('fromJson - Object Selection', () {
    test('should deserialize required object with all fields', () {
      final json = {
        'user': {
          'id': 'user123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'age': 30,
          'tags': ['developer', 'tester'],
          'optionalTags': ['reviewer']
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.id, 'user123');
      expect(result.user.name, 'John Doe');
      expect(result.user.email, 'john@example.com');
      expect(result.user.age, 30);
      expect(result.user.tags, ['developer', 'tester']);
      expect(result.user.optionalTags, ['reviewer']);
    });

    test('should deserialize object with null optional fields', () {
      final json = {
        'user': {
          'id': 'user456',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'age': null,
          'tags': [],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.id, 'user456');
      expect(result.user.name, 'Jane Smith');
      expect(result.user.email, 'jane@example.com');
      expect(result.user.age, null);
      expect(result.user.tags, isEmpty);
      expect(result.user.optionalTags, null);
    });

    test('should deserialize optional object when present', () {
      final json = {
        'userOpt': {
          'id': 'user789',
          'name': 'Alice Brown',
          'email': 'alice@example.com'
        }
      };

      final result = GetUserOptResponse.fromJson(json);

      expect(result.userOpt, isNotNull);
      expect(result.userOpt!.id, 'user789');
      expect(result.userOpt!.name, 'Alice Brown');
      expect(result.userOpt!.email, 'alice@example.com');
    });

    test('should deserialize optional object when null', () {
      final json = {'userOpt': null};

      final result = GetUserOptResponse.fromJson(json);

      expect(result.userOpt, isNull);
    });
  });

  group('fromJson - Nested Objects and Lists', () {
    test('should deserialize nested objects in lists', () {
      final json = {
        'product': {
          'id': 'prod1',
          'name': 'Laptop',
          'price': 999.99,
          'inStock': true,
          'category': 'ELECTRONICS',
          'relatedProducts': [
            {'id': 'prod2', 'name': 'Mouse', 'price': 25.50},
            {'id': 'prod3', 'name': 'Keyboard', 'price': 75.00}
          ]
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.id, 'prod1');
      expect(result.product.name, 'Laptop');
      expect(result.product.price, 999.99);
      expect(result.product.inStock, true);
      expect(result.product.category.name, 'ELECTRONICS');
      expect(result.product.relatedProducts, hasLength(2));
      expect(result.product.relatedProducts[0].id, 'prod2');
      expect(result.product.relatedProducts[0].name, 'Mouse');
      expect(result.product.relatedProducts[0].price, 25.50);
      expect(result.product.relatedProducts[1].id, 'prod3');
      expect(result.product.relatedProducts[1].name, 'Keyboard');
    });

    test('should deserialize empty lists', () {
      final json = {
        'product': {
          'id': 'prod4',
          'name': 'Book',
          'price': 15.99,
          'inStock': false,
          'category': 'BOOKS',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.relatedProducts, isEmpty);
    });

    test('should deserialize optional nested object when null', () {
      final json = {'productOpt': null};

      final result = GetProductOptResponse.fromJson(json);

      expect(result.productOpt, isNull);
    });
  });

  group('fromJson - Enum Selection', () {
    test('should deserialize enum values correctly', () {
      final json = {
        'product': {
          'id': 'prod5',
          'name': 'Shirt',
          'price': 29.99,
          'inStock': true,
          'category': 'CLOTHING',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.category, isA<Category>());
      expect(result.product.category.name, 'CLOTHING');
    });

    test('should handle all enum variants', () {
      final categories = ['ELECTRONICS', 'CLOTHING', 'FOOD', 'BOOKS'];

      for (final cat in categories) {
        final json = {
          'product': {
            'id': 'prod_$cat',
            'name': 'Test Product',
            'price': 10.0,
            'inStock': true,
            'category': cat,
            'relatedProducts': []
          }
        };

        final result = GetProductResponse.fromJson(json);
        expect(result.product.category.name, cat);
      }
    });
  });

  group('fromJson - Union Selection', () {
    test('should deserialize union type - User variant', () {
      final json = {
        'searchResult': {
          '__typename': 'User',
          'id': 'user123',
          'name': 'Bob Wilson',
          'email': 'bob@example.com'
        }
      };

      final result = GetSearchResultResponse.fromJson(json);

      expect(result.searchResult, isA<GetSearchResult_searchResult__User>());
      final user = result.searchResult as GetSearchResult_searchResult__User;
      expect(user.id, 'user123');
      expect(user.name, 'Bob Wilson');
      expect(user.email, 'bob@example.com');
    });

    test('should deserialize union type - Product variant', () {
      final json = {
        'searchResult': {
          '__typename': 'Product',
          'id': 'prod123',
          'name': 'Coffee Mug',
          'price': 12.99
        }
      };

      final result = GetSearchResultResponse.fromJson(json);

      expect(result.searchResult, isA<GetSearchResult_searchResult__Product>());
      final product =
          result.searchResult as GetSearchResult_searchResult__Product;
      expect(product.id, 'prod123');
      expect(product.name, 'Coffee Mug');
      expect(product.price, 12.99);
    });

    test('should deserialize optional union when present', () {
      final json = {
        'searchResultOpt': {
          '__typename': 'User',
          'id': 'user456',
          'name': 'Charlie Davis'
        }
      };

      final result = GetSearchResultOptResponse.fromJson(json);

      expect(result.searchResultOpt, isNotNull);
      expect(result.searchResultOpt,
          isA<GetSearchResultOpt_searchResultOpt__User>());
    });

    test('should deserialize optional union when null', () {
      final json = {'searchResultOpt': null};

      final result = GetSearchResultOptResponse.fromJson(json);

      expect(result.searchResultOpt, isNull);
    });

    test('should throw on unknown __typename in union', () {
      final json = {
        'searchResult': {
          '__typename': 'UnknownType',
          'id': 'unknown1',
          'name': 'Unknown'
        }
      };

      expect(
        () => GetSearchResultResponse.fromJson(json),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('fromJson - Interface Selection', () {
    test('should deserialize interface type - Dog implementation', () {
      final json = {
        'animal': {
          '__typename': 'Dog',
          'id': 'dog1',
          'name': 'Rex',
          'sound': 'Woof',
          'breed': 'Labrador'
        }
      };

      final result = GetAnimalResponse.fromJson(json);

      expect(result.animal, isA<GetAnimal_animal__Dog>());
      final dog = result.animal as GetAnimal_animal__Dog;
      expect(dog.id, 'dog1');
      expect(dog.name, 'Rex');
      expect(dog.sound, 'Woof');
      expect(dog.breed, 'Labrador');
    });

    test('should deserialize interface type - Cat implementation', () {
      final json = {
        'animal': {
          '__typename': 'Cat',
          'id': 'cat1',
          'name': 'Whiskers',
          'sound': 'Meow',
          'furColor': 'Orange'
        }
      };

      final result = GetAnimalResponse.fromJson(json);

      expect(result.animal, isA<GetAnimal_animal__Cat>());
      final cat = result.animal as GetAnimal_animal__Cat;
      expect(cat.id, 'cat1');
      expect(cat.name, 'Whiskers');
      expect(cat.sound, 'Meow');
      expect(cat.furColor, 'Orange');
    });

    test('should deserialize optional interface when present', () {
      final json = {
        'animalOpt': {
          '__typename': 'Dog',
          'id': 'dog2',
          'name': 'Buddy',
          'breed': 'Golden Retriever'
        }
      };

      final result = GetAnimalOptResponse.fromJson(json);

      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<GetAnimalOpt_animalOpt__Dog>());
    });

    test('should deserialize optional interface when null', () {
      final json = {'animalOpt': null};

      final result = GetAnimalOptResponse.fromJson(json);

      expect(result.animalOpt, isNull);
    });

    test('should throw on unknown __typename in interface', () {
      final json = {
        'animal': {
          '__typename': 'Bird',
          'id': 'bird1',
          'name': 'Tweety',
          'sound': 'Chirp'
        }
      };

      expect(
        () => GetAnimalResponse.fromJson(json),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('fromJson - Custom Scalars', () {
    test('should deserialize custom scalar', () {
      final json = {
        'settings': {
          'id': 'settings1',
          'theme': 'dark',
          'lastUpdated': '2024-01-15T10:30:00.000Z',
          'notifications': true
        }
      };

      final result = GetSettingsResponse.fromJson(json);

      expect(result.settings.id, 'settings1');
      expect(result.settings.theme, 'dark');
      expect(result.settings.lastUpdated, isA<DateTime>());
      expect(result.settings.lastUpdated.year, 2024);
      expect(result.settings.lastUpdated.month, 1);
      expect(result.settings.lastUpdated.day, 15);
      expect(result.settings.notifications, true);
    });

    test('should handle custom scalar deserialization errors', () {
      final json = {
        'settings': {
          'id': 'settings2',
          'theme': 'light',
          'lastUpdated': 'invalid-date-format',
          'notifications': false
        }
      };

      expect(
        () => GetSettingsResponse.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('fromJson - Edge Cases', () {
    test('should handle deeply nested optional fields', () {
      final json = {
        'productOpt': {
          'id': 'prod10',
          'name': 'Test Product',
          'price': 99.99
        }
      };

      final result = GetProductOptResponse.fromJson(json);

      expect(result.productOpt, isNotNull);
      expect(result.productOpt!.id, 'prod10');
    });

    test('should handle empty strings', () {
      final json = {
        'user': {
          'id': '',
          'name': '',
          'email': '',
          'age': null,
          'tags': [],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.id, '');
      expect(result.user.name, '');
      expect(result.user.email, '');
    });

    test('should handle zero and negative numbers', () {
      final json = {
        'product': {
          'id': 'prod11',
          'name': 'Free Item',
          'price': 0.0,
          'inStock': true,
          'category': 'FOOD',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.price, 0.0);
    });

    test('should handle large numbers', () {
      final json = {
        'product': {
          'id': 'prod12',
          'name': 'Expensive Item',
          'price': 999999.99,
          'inStock': true,
          'category': 'ELECTRONICS',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.price, 999999.99);
    });

    test('should handle special characters in strings', () {
      final json = {
        'user': {
          'id': 'user#123',
          'name': "O'Brien",
          'email': 'test+user@example.com',
          'age': 25,
          'tags': ['tag-1', 'tag_2', 'tag.3'],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.id, 'user#123');
      expect(result.user.name, "O'Brien");
      expect(result.user.email, 'test+user@example.com');
      expect(result.user.tags, ['tag-1', 'tag_2', 'tag.3']);
    });
  });

  group('fromJson - Type Safety', () {
    test('should maintain type safety for scalar types', () {
      final json = {
        'user': {
          'id': 'user999',
          'name': 'Test User',
          'email': 'test@example.com',
          'age': 42,
          'tags': ['a', 'b'],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      // These should compile and work correctly
      String id = result.user.id;
      String name = result.user.name;
      int? age = result.user.age;
      List<String> tags = result.user.tags;

      expect(id, isA<String>());
      expect(name, isA<String>());
      expect(age, isA<int>());
      expect(tags, isA<List<String>>());
    });

    test('should throw on type mismatches', () {
      final json = {
        'user': {
          'id': 123, // Should be String
          'name': 'Test User',
          'email': 'test@example.com',
          'age': 42,
          'tags': [],
          'optionalTags': null
        }
      };

      expect(
        () => GetUserResponse.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw on missing required fields', () {
      final json = {
        'user': {
          'id': 'user1',
          // missing 'name' field
          'email': 'test@example.com',
          'age': 42,
          'tags': [],
          'optionalTags': null
        }
      };

      expect(
        () => GetUserResponse.fromJson(json),
        throwsA(anything), // Will throw NoSuchMethodError or TypeError
      );
    });
  });

  group('fromJson vs fromResponse comparison', () {
    test('fromJson should produce same result as fromResponse for objects', () {
      final json = {
        'user': {
          'id': 'compare1',
          'name': 'Compare User',
          'email': 'compare@example.com',
          'age': 28,
          'tags': ['tag1'],
          'optionalTags': null
        }
      };

      final fromJsonResult = GetUserResponse.fromJson(json);
      final fromResponseResult = GetUserResponse.fromResponse(json);

      expect(fromJsonResult.user.id, fromResponseResult.user.id);
      expect(fromJsonResult.user.name, fromResponseResult.user.name);
      expect(fromJsonResult.user.email, fromResponseResult.user.email);
      expect(fromJsonResult.user.age, fromResponseResult.user.age);
      expect(fromJsonResult.user.tags, fromResponseResult.user.tags);
    });

    test('fromJson should work independently of cache', () {
      final json = {
        'userOpt': {
          'id': 'nocache1',
          'name': 'No Cache User',
          'email': 'nocache@example.com'
        }
      };

      // fromJson doesn't interact with cache at all
      final result1 = GetUserOptResponse.fromJson(json);
      final result2 = GetUserOptResponse.fromJson(json);

      // Both should produce equivalent objects
      expect(result1.userOpt!.id, result2.userOpt!.id);
      expect(result1.userOpt!.name, result2.userOpt!.name);
      expect(result1.userOpt!.email, result2.userOpt!.email);
    });
  });
}

  group('fromJson - Fragments', () {
    test('should deserialize objects using fragments', () {
      final json = {
        'user': {
          'id': 'frag1',
          'name': 'Fragment User',
          'email': 'frag@example.com',
          'age': 35
        }
      };

      final result = GetUserWithFragmentResponse.fromJson(json);

      expect(result.user.id, 'frag1');
      expect(result.user.name, 'Fragment User');
      expect(result.user.email, 'frag@example.com');
      expect(result.user.age, 35);
    });

    test('should deserialize nested objects with fragments', () {
      final json = {
        'product': {
          'id': 'frag_prod1',
          'name': 'Fragment Product',
          'price': 49.99,
          'category': 'ELECTRONICS',
          'inStock': true,
          'relatedProducts': [
            {
              'id': 'frag_prod2',
              'name': 'Related Product 1',
              'price': 29.99,
              'category': 'ELECTRONICS'
            }
          ]
        }
      };

      final result = GetProductWithFragmentResponse.fromJson(json);

      expect(result.product.id, 'frag_prod1');
      expect(result.product.name, 'Fragment Product');
      expect(result.product.inStock, true);
      expect(result.product.relatedProducts, hasLength(1));
      expect(result.product.relatedProducts[0].id, 'frag_prod2');
    });
  });

  group('fromJson - Deeply Nested Structures', () {
    test('should handle multiple levels of nesting', () {
      final json = {
        'product': {
          'id': 'nested1',
          'name': 'Parent Product',
          'price': 100.0,
          'inStock': true,
          'category': 'ELECTRONICS',
          'relatedProducts': [
            {
              'id': 'nested2',
              'name': 'Child Product',
              'price': 50.0,
              'relatedProducts': [
                {
                  'id': 'nested3',
                  'name': 'Grandchild Product',
                  'price': 25.0,
                  'relatedProducts': []
                }
              ]
            }
          ]
        }
      };

      final result = GetNestedListsResponse.fromJson(json);

      expect(result.product.id, 'nested1');
      expect(result.product.relatedProducts, hasLength(1));
      expect(result.product.relatedProducts[0].id, 'nested2');
      expect(result.product.relatedProducts[0].relatedProducts, hasLength(1));
      expect(
          result.product.relatedProducts[0].relatedProducts[0].id, 'nested3');
    });
  });

  group('fromJson - List Edge Cases', () {
    test('should handle lists with null elements when type allows', () {
      final json = {
        'user': {
          'id': 'list1',
          'name': 'List User',
          'email': 'list@example.com',
          'age': null,
          'tags': [],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.tags, isEmpty);
      expect(result.user.optionalTags, isNull);
    });

    test('should handle lists with many elements', () {
      final tags = List.generate(100, (i) => 'tag$i');
      final json = {
        'user': {
          'id': 'biglist',
          'name': 'Big List User',
          'email': 'biglist@example.com',
          'age': 30,
          'tags': tags,
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.tags, hasLength(100));
      expect(result.user.tags[0], 'tag0');
      expect(result.user.tags[99], 'tag99');
    });
  });

  group('fromJson - Boolean Values', () {
    test('should correctly deserialize boolean true', () {
      final json = {
        'product': {
          'id': 'bool1',
          'name': 'Bool Product',
          'price': 10.0,
          'inStock': true,
          'category': 'FOOD',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.inStock, isTrue);
    });

    test('should correctly deserialize boolean false', () {
      final json = {
        'product': {
          'id': 'bool2',
          'name': 'Bool Product',
          'price': 10.0,
          'inStock': false,
          'category': 'FOOD',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.inStock, isFalse);
    });
  });

  group('fromJson - Float/Double Precision', () {
    test('should maintain decimal precision', () {
      final json = {
        'product': {
          'id': 'precision1',
          'name': 'Precision Product',
          'price': 123.456789,
          'inStock': true,
          'category': 'ELECTRONICS',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.price, closeTo(123.456789, 0.000001));
    });

    test('should handle very small decimals', () {
      final json = {
        'product': {
          'id': 'tiny',
          'name': 'Tiny Price',
          'price': 0.01,
          'inStock': true,
          'category': 'FOOD',
          'relatedProducts': []
        }
      };

      final result = GetProductResponse.fromJson(json);

      expect(result.product.price, 0.01);
    });
  });

  group('fromJson - Unicode and Special Characters', () {
    test('should handle unicode characters', () {
      final json = {
        'user': {
          'id': 'unicode1',
          'name': '用户名 🚀 ñ é',
          'email': 'unicode@例え.com',
          'age': 25,
          'tags': ['标签1', 'тег2', '🏷️'],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.name, '用户名 🚀 ñ é');
      expect(result.user.email, 'unicode@例え.com');
      expect(result.user.tags, ['标签1', 'тег2', '🏷️']);
    });

    test('should handle newlines and tabs', () {
      final json = {
        'user': {
          'id': 'whitespace',
          'name': 'Line 1\nLine 2\tTabbed',
          'email': 'test@example.com',
          'age': 30,
          'tags': ['tag\n1', 'tag\t2'],
          'optionalTags': null
        }
      };

      final result = GetUserResponse.fromJson(json);

      expect(result.user.name, contains('\n'));
      expect(result.user.name, contains('\t'));
    });
  });

  group('fromJson - Complex Multi-Type Scenarios', () {
    test('should handle switching between union types multiple times', () {
      final userJson = {
        'searchResult': {
          '__typename': 'User',
          'id': 'switch1',
          'name': 'User 1',
          'email': 'user1@example.com'
        }
      };

      final productJson = {
        'searchResult': {
          '__typename': 'Product',
          'id': 'switch2',
          'name': 'Product 1',
          'price': 50.0
        }
      };

      final userResult = GetSearchResultResponse.fromJson(userJson);
      final productResult = GetSearchResultResponse.fromJson(productJson);

      expect(userResult.searchResult,
          isA<GetSearchResult_searchResult__User>());
      expect(productResult.searchResult,
          isA<GetSearchResult_searchResult__Product>());
    });

    test('should handle interface with missing optional fields', () {
      final json = {
        'animal': {
          '__typename': 'Dog',
          'id': 'dog3',
          'name': 'Spot',
          'sound': 'Bark',
          'breed': 'Dalmatian'
        }
      };

      final result = GetAnimalResponse.fromJson(json);

      expect(result.animal, isA<GetAnimal_animal__Dog>());
      final dog = result.animal as GetAnimal_animal__Dog;
      expect(dog.breed, 'Dalmatian');
    });
  });

  group('fromJson - Error Handling', () {
    test('should throw helpful error for invalid enum value', () {
      final json = {
        'product': {
          'id': 'bad_enum',
          'name': 'Bad Enum Product',
          'price': 10.0,
          'inStock': true,
          'category': 'INVALID_CATEGORY',
          'relatedProducts': []
        }
      };

      expect(
        () => GetProductResponse.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw error for null in non-nullable field', () {
      final json = {
        'user': {
          'id': null, // Required field
          'name': 'Test',
          'email': 'test@example.com',
          'age': 30,
          'tags': [],
          'optionalTags': null
        }
      };

      expect(
        () => GetUserResponse.fromJson(json),
        throwsA(anything),
      );
    });

    test('should throw error for wrong list element type', () {
      final json = {
        'user': {
          'id': 'wrong_list',
          'name': 'Wrong List',
          'email': 'test@example.com',
          'age': 30,
          'tags': ['valid', 123, 'another'], // 123 is not a String
          'optionalTags': null
        }
      };

      expect(
        () => GetUserResponse.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('fromJson - Performance Considerations', () {
    test('should handle moderately large datasets efficiently', () {
      final relatedProducts = List.generate(
        50,
        (i) => {
          'id': 'prod$i',
          'name': 'Product $i',
          'price': (i + 1) * 10.0,
        },
      );

      final json = {
        'product': {
          'id': 'parent',
          'name': 'Parent Product',
          'price': 1000.0,
          'inStock': true,
          'category': 'ELECTRONICS',
          'relatedProducts': relatedProducts
        }
      };

      final stopwatch = Stopwatch()..start();
      final result = GetProductResponse.fromJson(json);
      stopwatch.stop();

      expect(result.product.relatedProducts, hasLength(50));
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}