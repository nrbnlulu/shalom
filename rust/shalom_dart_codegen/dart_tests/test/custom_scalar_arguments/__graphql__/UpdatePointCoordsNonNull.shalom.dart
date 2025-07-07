// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointCoordsNonNullResponse {
  /// class members

  final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords;

  // keywordargs constructor
  UpdatePointCoordsNonNullResponse({this.updatePointCoords});
  static UpdatePointCoordsNonNullResponse fromJson(JsonObject data) {
    final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords_value;

    final JsonObject? updatePointCoords$raw = data['updatePointCoords'];
    if (updatePointCoords$raw != null) {
      updatePointCoords_value =
          UpdatePointCoordsNonNull_updatePointCoords.fromJson(
            updatePointCoords$raw,
          );
    } else {
      updatePointCoords_value = null;
    }

    return UpdatePointCoordsNonNullResponse(
      updatePointCoords: updatePointCoords_value,
    );
  }

  UpdatePointCoordsNonNullResponse updateWithJson(JsonObject data) {
    final UpdatePointCoordsNonNull_updatePointCoords? updatePointCoords_value;
    if (data.containsKey('updatePointCoords')) {
      final JsonObject? updatePointCoords$raw = data['updatePointCoords'];
      if (updatePointCoords$raw != null) {
        updatePointCoords_value =
            UpdatePointCoordsNonNull_updatePointCoords.fromJson(
              updatePointCoords$raw,
            );
      } else {
        updatePointCoords_value = null;
      }
    } else {
      updatePointCoords_value = updatePointCoords;
    }

    return UpdatePointCoordsNonNullResponse(
      updatePointCoords: updatePointCoords_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsNonNullResponse &&
            other.updatePointCoords == updatePointCoords);
  }

  @override
  int get hashCode => updatePointCoords.hashCode;

  JsonObject toJson() {
    return {'updatePointCoords': updatePointCoords?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointCoordsNonNull_updatePointCoords {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointCoordsNonNull_updatePointCoords({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointCoordsNonNull_updatePointCoords fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return UpdatePointCoordsNonNull_updatePointCoords(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointCoordsNonNull_updatePointCoords updateWithJson(JsonObject data) {
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

    return UpdatePointCoordsNonNull_updatePointCoords(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsNonNull_updatePointCoords &&
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

class RequestUpdatePointCoordsNonNull extends Requestable {
  final UpdatePointCoordsNonNullVariables variables;

  RequestUpdatePointCoordsNonNull({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdatePointCoordsNonNull($coords: Point!) {
  updatePointCoords(coords: $coords) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointCoordsNonNull',
    );
  }
}

class UpdatePointCoordsNonNullVariables {
  final rmhlxei.Point coords;

  UpdatePointCoordsNonNullVariables({required this.coords});

  JsonObject toJson() {
    JsonObject data = {};

    data["coords"] = rmhlxei.pointScalarImpl.serialize(this.coords);

    return data;
  }

  UpdatePointCoordsNonNullVariables updateWith({rmhlxei.Point? coords}) {
    final rmhlxei.Point coords$next;

    if (coords != null) {
      coords$next = coords;
    } else {
      coords$next = this.coords;
    }

    return UpdatePointCoordsNonNullVariables(coords: coords$next);
  }
}
