// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion

import 'package:shalom_core/shalom_core.dart';

import '../../custom_scalar/point.dart' as rmhlxei;

// ------------ Enum DEFINITIONS -------------

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

class PointDataInput {
  final rmhlxei.Point coords;

  final String name;

  PointDataInput({required this.coords, required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] = rmhlxei.pointScalarImpl.serialize(this.coords);

    data["name"] = this.name;

    return data;
  }

  PointDataInput updateWith({rmhlxei.Point? coords, String? name}) {
    final rmhlxei.Point coords$next;

    if (coords != null) {
      coords$next = coords;
    } else {
      coords$next = this.coords;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    return PointDataInput(coords: coords$next, name: name$next);
  }
}

class PointDataOptCoordsInput {
  final rmhlxei.Point? coords;

  final String name;

  PointDataOptCoordsInput({this.coords, required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] =
        this.coords == null
            ? null
            : rmhlxei.pointScalarImpl.serialize(this.coords!);

    data["name"] = this.name;

    return data;
  }

  PointDataOptCoordsInput updateWith({
    Option<rmhlxei.Point?> coords = const None(),

    String? name,
  }) {
    final rmhlxei.Point? coords$next;

    switch (coords) {
      case Some(value: final updateData):
        coords$next = updateData;
      case None():
        coords$next = this.coords;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    return PointDataOptCoordsInput(coords: coords$next, name: name$next);
  }
}

class PointUpdateCoordsMaybe {
  final Option<rmhlxei.Point?> coords;

  final String name;

  PointUpdateCoordsMaybe({this.coords = const None(), required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    if (coords.isSome()) {
      final value = this.coords.some();
      data["coords"] =
          value == null ? null : rmhlxei.pointScalarImpl.serialize(value!);
    }

    data["name"] = this.name;

    return data;
  }

  PointUpdateCoordsMaybe updateWith({
    Option<Option<rmhlxei.Point?>> coords = const None(),

    String? name,
  }) {
    final Option<rmhlxei.Point?> coords$next;

    switch (coords) {
      case Some(value: final updateData):
        coords$next = updateData;
      case None():
        coords$next = this.coords;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    return PointUpdateCoordsMaybe(coords: coords$next, name: name$next);
  }
}

// ------------ END Input DEFINITIONS -------------
