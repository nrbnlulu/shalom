// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointCoordsOptResponse {
  /// class members

  final UpdatePointCoordsOpt_getPointById? getPointById;

  // keywordargs constructor
  UpdatePointCoordsOptResponse({this.getPointById});
  static UpdatePointCoordsOptResponse fromJson(JsonObject data) {
    final UpdatePointCoordsOpt_getPointById? getPointById_value;

    final JsonObject? getPointById$raw = data['getPointById'];
    if (getPointById$raw != null) {
      getPointById_value = UpdatePointCoordsOpt_getPointById.fromJson(
        getPointById$raw,
      );
    } else {
      getPointById_value = null;
    }

    return UpdatePointCoordsOptResponse(getPointById: getPointById_value);
  }

  UpdatePointCoordsOptResponse updateWithJson(JsonObject data) {
    final UpdatePointCoordsOpt_getPointById? getPointById_value;
    if (data.containsKey('getPointById')) {
      final JsonObject? getPointById$raw = data['getPointById'];
      if (getPointById$raw != null) {
        getPointById_value = UpdatePointCoordsOpt_getPointById.fromJson(
          getPointById$raw,
        );
      } else {
        getPointById_value = null;
      }
    } else {
      getPointById_value = getPointById;
    }

    return UpdatePointCoordsOptResponse(getPointById: getPointById_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsOptResponse &&
            other.getPointById == getPointById);
  }

  @override
  int get hashCode => getPointById.hashCode;

  JsonObject toJson() {
    return {'getPointById': getPointById?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointCoordsOpt_getPointById {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointCoordsOpt_getPointById({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointCoordsOpt_getPointById fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return UpdatePointCoordsOpt_getPointById(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointCoordsOpt_getPointById updateWithJson(JsonObject data) {
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

    return UpdatePointCoordsOpt_getPointById(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsOpt_getPointById &&
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

class RequestUpdatePointCoordsOpt extends Requestable {
  final UpdatePointCoordsOptVariables variables;

  RequestUpdatePointCoordsOpt({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""query UpdatePointCoordsOpt($id: ID!, $coords: Point = "POINT (0,0)") {
  getPointById(id: $id, coords: $coords) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'UpdatePointCoordsOpt',
    );
  }
}

class UpdatePointCoordsOptVariables {
  final rmhlxei.Point? coords;

  final String id;

  UpdatePointCoordsOptVariables({this.coords, required this.id});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] =
        this.coords == null
            ? null
            : rmhlxei.pointScalarImpl.serialize(this.coords!);

    data["id"] = this.id;

    return data;
  }

  UpdatePointCoordsOptVariables updateWith({
    Option<rmhlxei.Point?> coords = const None(),

    String? id,
  }) {
    final rmhlxei.Point? coords$next;

    switch (coords) {
      case Some(value: final updateData):
        coords$next = updateData;
      case None():
        coords$next = this.coords;
    }

    final String id$next;

    if (id != null) {
      id$next = id;
    } else {
      id$next = this.id;
    }

    return UpdatePointCoordsOptVariables(coords: coords$next, id: id$next);
  }
}
