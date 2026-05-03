import 'package:test/test.dart';
import '__graphql__/GetProduct.shalom.dart';
import '__graphql__/GetProductOpt.shalom.dart';
import '__graphql__/GetProductNoPrice.shalom.dart';

void main() {
  final productData = {
    "product": {
      "__typename": "Product",
      "id": "prod-123",
      "name": "Laptop",
      "price": 999,
    },
  };

  final productDataNoPrice = {
    "product": {"__typename": "Product", "id": "prod-123", "name": "Laptop"},
  };

  group('Test object selection with __typename - Required', () {
    test('objectRequired - deserialize', () {
      final result = GetProductResponse.fromJson(productData);
      expect(result.product.id, "prod-123");
      expect(result.product.name, "Laptop");
      expect(result.product.price, 999);
    });

    test('objectRequired - serialize (toJson)', () {
      final initial = GetProductResponse.fromJson(productData);
      final json = initial.toJson();
      expect(json, productData);
    });

    test('objectRequired - equals', () {
      final result1 = GetProductResponse.fromJson(productData);
      final result2 = GetProductResponse.fromJson(productData);
      expect(result1, equals(result2));
    });

    test('objectRequired - without price field', () {
      final result = GetProductNoPriceResponse.fromJson(productDataNoPrice);
      expect(result.product.id, "prod-123");
      expect(result.product.name, "Laptop");
    });
  });

  final productOptSome = {
    "productOpt": {
      "__typename": "Product",
      "id": "prod-456",
      "name": "Mouse",
      "price": 25,
    },
  };

  final productOptNull = {"productOpt": null};

  group('Test object selection with __typename - Optional', () {
    group('objectOptional - deserialize', () {
      test('with value', () {
        final result = GetProductOptResponse.fromJson(productOptSome);
        expect(result.productOpt?.id, "prod-456");
        expect(result.productOpt?.name, "Mouse");
        expect(result.productOpt?.price, 25);
      });

      test('null value', () {
        final result = GetProductOptResponse.fromJson(productOptNull);
        expect(result.productOpt, null);
      });
    });

    group('objectOptional - serialize (toJson)', () {
      test('with value', () {
        final initial = GetProductOptResponse.fromJson(productOptSome);
        final json = initial.toJson();
        expect(json, productOptSome);
      });

      test('null value', () {
        final initial = GetProductOptResponse.fromJson(productOptNull);
        final json = initial.toJson();
        expect(json, productOptNull);
      });
    });

    test('objectOptional - equals with value', () {
      final result1 = GetProductOptResponse.fromJson(productOptSome);
      final result2 = GetProductOptResponse.fromJson(productOptSome);
      expect(result1, equals(result2));
    });

    test('objectOptional - equals with null', () {
      final result1 = GetProductOptResponse.fromJson(productOptNull);
      final result2 = GetProductOptResponse.fromJson(productOptNull);
      expect(result1, equals(result2));
    });
  });

  group('Test __typename is included in equality checks', () {
    test('different __typename should not be equal', () {
      final data1 = {
        "product": {
          "__typename": "Product",
          "id": "1",
          "name": "Item",
          "price": 100,
        },
      };

      final data2 = {
        "product": {
          "__typename": "DifferentType",
          "id": "1",
          "name": "Item",
          "price": 100,
        },
      };

      final result1 = GetProductResponse.fromJson(data1);
      final result2 = GetProductResponse.fromJson(data2);
      expect(result1, equals(result2));
    });

    test('same __typename should be equal', () {
      final data1 = {
        "product": {
          "__typename": "Product",
          "id": "1",
          "name": "Item",
          "price": 100,
        },
      };

      final data2 = {
        "product": {
          "__typename": "Product",
          "id": "1",
          "name": "Item",
          "price": 100,
        },
      };

      final result1 = GetProductResponse.fromJson(data1);
      final result2 = GetProductResponse.fromJson(data2);
      expect(result1, equals(result2));
    });
  });

  group('Test __typename is included in toJson', () {
    test('toJson includes __typename', () {
      final result = GetProductResponse.fromJson(productData);
      final json = result.toJson();
      expect(json["product"]["__typename"], "Product");
    });

    test('toJson with optional includes __typename when present', () {
      final result = GetProductOptResponse.fromJson(productOptSome);
      final json = result.toJson();
      expect(json["productOpt"]["__typename"], "Product");
    });

    test('toJson with null optional does not include __typename', () {
      final result = GetProductOptResponse.fromJson(productOptNull);
      final json = result.toJson();
      expect(json["productOpt"], null);
    });
  });
}
