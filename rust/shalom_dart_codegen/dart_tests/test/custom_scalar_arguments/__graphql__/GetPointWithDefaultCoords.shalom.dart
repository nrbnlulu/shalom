// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class GetPointWithDefaultCoordsResponse {
  /// class members

  final GetPointWithDefaultCoords_getPointById? getPointById;

  // keywordargs constructor
  GetPointWithDefaultCoordsResponse({this.getPointById});
  static GetPointWithDefaultCoordsResponse fromJson(JsonObject data) {
    final GetPointWithDefaultCoords_getPointById? getPointById_value;

    final JsonObject? getPointById$raw = data['getPointById'];
    if (getPointById$raw != null) {
      getPointById_value = GetPointWithDefaultCoords_getPointById.fromJson(
        getPointById$raw,
      );
    } else {
      getPointById_value = null;
    }

    return GetPointWithDefaultCoordsResponse(getPointById: getPointById_value);
  }

  GetPointWithDefaultCoordsResponse updateWithJson(JsonObject data) {
    final GetPointWithDefaultCoords_getPointById? getPointById_value;
    if (data.containsKey('getPointById')) {
      final JsonObject? getPointById$raw = data['getPointById'];
      if (getPointById$raw != null) {
        getPointById_value = GetPointWithDefaultCoords_getPointById.fromJson(
          getPointById$raw,
        );
      } else {
        getPointById_value = null;
      }
    } else {
      getPointById_value = getPointById;
    }

    return GetPointWithDefaultCoordsResponse(getPointById: getPointById_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetPointWithDefaultCoordsResponse &&
            other.getPointById == getPointById);
  }

  @override
  int get hashCode => getPointById.hashCode;

  JsonObject toJson() {
    return {'getPointById': getPointById?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetPointWithDefaultCoords_getPointById {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  GetPointWithDefaultCoords_getPointById({
    this.coords,
    required this.name,
    required this.id,
  });
  static GetPointWithDefaultCoords_getPointById fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return GetPointWithDefaultCoords_getPointById(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  GetPointWithDefaultCoords_getPointById updateWithJson(JsonObject data) {
    final rmhlxei.Point? coords_value;
    if (data.containsKey('coords')) {
      coords_value =
          data['coords'] == null
              ? null
              : rmhlxei.pointScalarImpl.deserialize(data['coords']);
    } else {
      coords_value = coords;
    }

    final String name_value;
    if (data.containsKey('name')) {
      name_value = data['name'];
    } else {
      name_value = name;
    }

    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    return GetPointWithDefaultCoords_getPointById(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetPointWithDefaultCoords_getPointById &&
            other.coords == coords &&
            other.name == name &&
            other.id == id);
  }

  @override
  int get hashCode => Object.hashAll([coords, name, id]);

  JsonObject toJson() {
    return {
      'coords':
          coords == null ? null : rmhlxei.pointScalarImpl.serialize(coords!),

      'name': name,

      'id': id,
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetPointWithDefaultCoords extends Requestable {
  final GetPointWithDefaultCoordsVariables variables;

  RequestGetPointWithDefaultCoords({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""query GetPointWithDefaultCoords($id: ID!, $coords: Point = "POINT (0,0)") {
  getPointById(id: $id, coords: $coords) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetPointWithDefaultCoords',
    );
  }
}

class GetPointWithDefaultCoordsVariables {
  final rmhlxei.Point? coords;

  final String id;

  GetPointWithDefaultCoordsVariables({this.coords, required this.id});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] =
        coords == null ? null : rmhlxei.pointScalarImpl.serialize(coords!);

    data["id"] = id;

    return data;
  }

  GetPointWithDefaultCoordsVariables updateWith({
    Option<rmhlxei.Point?> coords = const None(),

    String? id,
  }) {
    final rmhlxei.Point? coords$next;

    switch (coords) {
      case Some(value: final data):
        coords$next = data;
      case None():
        coords$next = this.coords;
    }

    final String id$next;

    if (id != null) {
      id$next = id;
    } else {
      id$next = this.id;
    }

    return GetPointWithDefaultCoordsVariables(coords: coords$next, id: id$next);
  }
}
