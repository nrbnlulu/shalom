// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointCoordsOptResponse {
  /// class members

  final UpdatePointCoordsOpt_getPointById? getPointById;

  // keywordargs constructor
  UpdatePointCoordsOptResponse({this.getPointById});
  static UpdatePointCoordsOptResponse fromJson(JsonObject data) {
    final UpdatePointCoordsOpt_getPointById? getPointById_value;
    final getPointById$raw = data["getPointById"];
    getPointById_value =
        getPointById$raw == null
            ? null
            : UpdatePointCoordsOpt_getPointById.fromJson(getPointById$raw);

    return UpdatePointCoordsOptResponse(getPointById: getPointById_value);
  }

  UpdatePointCoordsOptResponse updateWithJson(JsonObject data) {
    final UpdatePointCoordsOpt_getPointById? getPointById_value;
    if (data.containsKey('getPointById')) {
      final getPointById$raw = data["getPointById"];
      getPointById_value =
          getPointById$raw == null
              ? null
              : UpdatePointCoordsOpt_getPointById.fromJson(getPointById$raw);
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
    return {'getPointById': this.getPointById?.toJson()};
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
    final coords$raw = data["coords"];
    coords_value =
        coords$raw == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(coords$raw);

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    return UpdatePointCoordsOpt_getPointById(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointCoordsOpt_getPointById updateWithJson(JsonObject data) {
    final rmhlxei.Point? coords_value;
    if (data.containsKey('coords')) {
      final coords$raw = data["coords"];
      coords_value =
          coords$raw == null
              ? null
              : rmhlxei.pointScalarImpl.deserialize(coords$raw);
    } else {
      coords_value = coords;
    }

    final String name_value;
    if (data.containsKey('name')) {
      final name$raw = data["name"];
      name_value = name$raw as String;
    } else {
      name_value = name;
    }

    final String id_value;
    if (data.containsKey('id')) {
      final id$raw = data["id"];
      id_value = id$raw as String;
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
          this.coords == null
              ? null
              : rmhlxei.pointScalarImpl.serialize(this.coords!),

      'name': this.name,

      'id': this.id,
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
      opName: 'UpdatePointCoordsOpt',
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
