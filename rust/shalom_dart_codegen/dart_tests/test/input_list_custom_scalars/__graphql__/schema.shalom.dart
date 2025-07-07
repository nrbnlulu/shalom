// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion

import 'package:shalom_core/shalom_core.dart';

import '../../custom_scalar/point.dart' as rmhlxei;

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class ItemContainerInput {
  final List<rmhlxei.Point?> flexibleItems;

  final String name;

  final Option<List<rmhlxei.Point?>?> optionalItems;

  final List<rmhlxei.Point> requiredItems;

  ItemContainerInput({
    required this.flexibleItems,

    required this.name,

    this.optionalItems = const None(),

    required this.requiredItems,
  });

  JsonObject toJson() {
    JsonObject data = {};

    data["flexibleItems"] =
        this.flexibleItems
            .map(
              (e) => e == null ? null : rmhlxei.pointScalarImpl.serialize(e!),
            )
            .toList();

    data["name"] = this.name;

    if (optionalItems.isSome()) {
      final value = this.optionalItems.some();
      data["optionalItems"] =
          value
              ?.map(
                (e) => e == null ? null : rmhlxei.pointScalarImpl.serialize(e!),
              )
              .toList();
    }

    data["requiredItems"] =
        this.requiredItems
            .map((e) => rmhlxei.pointScalarImpl.serialize(e))
            .toList();

    return data;
  }

  ItemContainerInput updateWith({
    List<rmhlxei.Point?>? flexibleItems,

    String? name,

    Option<Option<List<rmhlxei.Point?>?>> optionalItems = const None(),

    List<rmhlxei.Point>? requiredItems,
  }) {
    final List<rmhlxei.Point?> flexibleItems$next;

    if (flexibleItems != null) {
      flexibleItems$next = flexibleItems;
    } else {
      flexibleItems$next = this.flexibleItems;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    final Option<List<rmhlxei.Point?>?> optionalItems$next;

    switch (optionalItems) {
      case Some(value: final updateData):
        optionalItems$next = updateData;
      case None():
        optionalItems$next = this.optionalItems;
    }

    final List<rmhlxei.Point> requiredItems$next;

    if (requiredItems != null) {
      requiredItems$next = requiredItems;
    } else {
      requiredItems$next = this.requiredItems;
    }

    return ItemContainerInput(
      flexibleItems: flexibleItems$next,

      name: name$next,

      optionalItems: optionalItems$next,

      requiredItems: requiredItems$next,
    );
  }
}

// ------------ END Input DEFINITIONS -------------
