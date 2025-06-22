// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import

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

    data["coords"] = rmhlxei.pointScalarImpl.serialize(coords);

    data["name"] = name;

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

class PointDataInputWithDefault {
  final rmhlxei.Point? coords;

  final String name;

  PointDataInputWithDefault({this.coords, required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] =
        coords == null ? null : rmhlxei.pointScalarImpl.serialize(coords!);

    data["name"] = name;

    return data;
  }

  PointDataInputWithDefault updateWith({
    Option<rmhlxei.Point?> coords = const None(),

    String? name,
  }) {
    final rmhlxei.Point? coords$next;

    switch (coords) {
      case Some(value: final data):
        coords$next = data;
      case None():
        coords$next = this.coords;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    return PointDataInputWithDefault(coords: coords$next, name: name$next);
  }
}

class PointUpdateCoordsMaybe {
  final Option<rmhlxei.Point?> coords;

  final String name;

  PointUpdateCoordsMaybe({this.coords = const None(), required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    if (coords.isSome()) {
      if (coords.some() == null) {
        data["coords"] = null;
      } else {
        data["coords"] = rmhlxei.pointScalarImpl.serialize(coords.some()!);
      }
    }

    data["name"] = name;

    return data;
  }

  PointUpdateCoordsMaybe updateWith({
    Option<Option<rmhlxei.Point?>> coords = const None(),

    String? name,
  }) {
    final Option<rmhlxei.Point?> coords$next;

    switch (coords) {
      case Some(value: final data):
        coords$next = data;
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

class PointUpdateCoordsOpt {
  final Option<rmhlxei.Point?> coords;

  final String name;

  PointUpdateCoordsOpt({this.coords = const None(), required this.name});

  JsonObject toJson() {
    JsonObject data = {};

    if (coords.isSome()) {
      if (coords.some() == null) {
        data["coords"] = null;
      } else {
        data["coords"] = rmhlxei.pointScalarImpl.serialize(coords.some()!);
      }
    }

    data["name"] = name;

    return data;
  }

  PointUpdateCoordsOpt updateWith({
    Option<Option<rmhlxei.Point?>> coords = const None(),

    String? name,
  }) {
    final Option<rmhlxei.Point?> coords$next;

    switch (coords) {
      case Some(value: final data):
        coords$next = data;
      case None():
        coords$next = this.coords;
    }

    final String name$next;

    if (name != null) {
      name$next = name;
    } else {
      name$next = this.name;
    }

    return PointUpdateCoordsOpt(coords: coords$next, name: name$next);
  }
}

// ------------ END Input DEFINITIONS -------------
