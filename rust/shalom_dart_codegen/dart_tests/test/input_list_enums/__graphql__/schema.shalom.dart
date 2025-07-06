// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import

import 'package:shalom_core/shalom_core.dart';

// ------------ Enum DEFINITIONS -------------

enum Gender {
  FEMALE,

  MALE,

  OTHER;

  static Gender fromString(String name) {
    switch (name) {
      case 'FEMALE':
        return Gender.FEMALE;
      case 'MALE':
        return Gender.MALE;
      case 'OTHER':
        return Gender.OTHER;
      default:
        throw ArgumentError.value(
          name,
          'name',
          'No Status enum member with this name',
        );
    }
  }
}

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class ObjectWithListOfInput {
  final List<Gender> genders;

  final Option<List<Gender>?> optionalGenders;

  ObjectWithListOfInput({
    required this.genders,

    this.optionalGenders = const None(),
  });

  JsonObject toJson() {
    JsonObject data = {};

    data["genders"] = genders.map((e) => e.name).toList();

    if (optionalGenders.isSome()) {
      final value = optionalGenders.some();

      data["optionalGenders"] = value?.map((e) => e.name).toList();
    }

    return data;
  }

  ObjectWithListOfInput updateWith({
    List<Gender>? genders,

    Option<Option<List<Gender>?>> optionalGenders = const None(),
  }) {
    final List<Gender> genders$next;

    if (genders != null) {
      genders$next = genders;
    } else {
      genders$next = this.genders;
    }

    final Option<List<Gender>?> optionalGenders$next;

    switch (optionalGenders) {
      case Some(value: final data):
        optionalGenders$next = data;
      case None():
        optionalGenders$next = this.optionalGenders;
    }

    return ObjectWithListOfInput(
      genders: genders$next,

      optionalGenders: optionalGenders$next,
    );
  }
}

// ------------ END Input DEFINITIONS -------------
