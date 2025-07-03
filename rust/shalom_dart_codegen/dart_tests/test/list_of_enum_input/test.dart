import 'package:shalom_core/shalom_core.dart';
import 'package:test/test.dart';
import '__graphql__/schema.shalom.dart';

void main() {
  group('ListOfEnumInput', () {
    test('colorsRequired', () {
      final input = ListOfEnumInput(
        colorsRequired: [Color.RED, Color.GREEN],
        colorsOptional: const None(),
        colorsMaybe: const None(),
      );
      final json = input.toJson();
      expect(json['colorsRequired'], equals([Color.RED.name, Color.GREEN.name]));
      // No fromJson for input types, so just check toJson and equality
      final input2 = ListOfEnumInput(
        colorsRequired: [Color.RED, Color.GREEN],
        colorsOptional: const None(),
        colorsMaybe: const None(),
      );
      expect(input, equals(input2));
    });

    test('colorsOptional', () {
      final input = ListOfEnumInput(
        colorsRequired: [Color.BLUE],
        colorsOptional: Some([Color.GREEN]),
        colorsMaybe: const None(),
      );
      final json = input.toJson();
      expect(json['colorsOptional'], equals([Color.GREEN.name]));
      final input2 = ListOfEnumInput(
        colorsRequired: [Color.BLUE],
        colorsOptional: Some([Color.GREEN]),
        colorsMaybe: const None(),
      );
      expect(input, equals(input2));
    });

    test('colorsMaybe updateWith', () {
      final input = ListOfEnumInput(
        colorsRequired: [Color.RED],
        colorsOptional: const None(),
        colorsMaybe: const None(),
      );
      final updated = input.updateWith(colorsMaybe: Some(Some([Color.BLUE])));
      expect(updated.colorsMaybe.isSome(), isTrue);
      expect(updated.colorsMaybe.some(), equals([Color.BLUE])); // This is fine, as it's comparing enums
    });

    test('Maybe wrapping', () {
      // Optional but no default value should be wrapped in Maybe
      final input = ListOfEnumInput(
        colorsRequired: [Color.RED],
        colorsOptional: const None(),
        colorsMaybe: const None(),
      );
      expect(input.colorsMaybe, const None());
    });
  });
}
