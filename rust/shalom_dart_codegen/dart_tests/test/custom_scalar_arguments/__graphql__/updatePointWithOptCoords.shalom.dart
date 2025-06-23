// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class updatePointWithOptCoordsResponse {
  /// class members

  final updatePointWithOptCoords_updatePointWithOptCoords?
  updatePointWithOptCoords;

  // keywordargs constructor
  updatePointWithOptCoordsResponse({this.updatePointWithOptCoords});
  static updatePointWithOptCoordsResponse fromJson(JsonObject data) {
    final updatePointWithOptCoords_updatePointWithOptCoords?
    updatePointWithOptCoords_value;

    final JsonObject? updatePointWithOptCoords$raw =
        data['updatePointWithOptCoords'];
    if (updatePointWithOptCoords$raw != null) {
      updatePointWithOptCoords_value =
          updatePointWithOptCoords_updatePointWithOptCoords.fromJson(
            updatePointWithOptCoords$raw,
          );
    } else {
      updatePointWithOptCoords_value = null;
    }

    return updatePointWithOptCoordsResponse(
      updatePointWithOptCoords: updatePointWithOptCoords_value,
    );
  }

  updatePointWithOptCoordsResponse updateWithJson(JsonObject data) {
    final updatePointWithOptCoords_updatePointWithOptCoords?
    updatePointWithOptCoords_value;
    if (data.containsKey('updatePointWithOptCoords')) {
      final JsonObject? updatePointWithOptCoords$raw =
          data['updatePointWithOptCoords'];
      if (updatePointWithOptCoords$raw != null) {
        updatePointWithOptCoords_value =
            updatePointWithOptCoords_updatePointWithOptCoords.fromJson(
              updatePointWithOptCoords$raw,
            );
      } else {
        updatePointWithOptCoords_value = null;
      }
    } else {
      updatePointWithOptCoords_value = updatePointWithOptCoords;
    }

    return updatePointWithOptCoordsResponse(
      updatePointWithOptCoords: updatePointWithOptCoords_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is updatePointWithOptCoordsResponse &&
            other.updatePointWithOptCoords == updatePointWithOptCoords);
  }

  @override
  int get hashCode => updatePointWithOptCoords.hashCode;

  JsonObject toJson() {
    return {'updatePointWithOptCoords': updatePointWithOptCoords?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class updatePointWithOptCoords_updatePointWithOptCoords {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  updatePointWithOptCoords_updatePointWithOptCoords({
    this.coords,
    required this.name,
    required this.id,
  });
  static updatePointWithOptCoords_updatePointWithOptCoords fromJson(
    JsonObject data,
  ) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return updatePointWithOptCoords_updatePointWithOptCoords(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  updatePointWithOptCoords_updatePointWithOptCoords updateWithJson(
    JsonObject data,
  ) {
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

    return updatePointWithOptCoords_updatePointWithOptCoords(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is updatePointWithOptCoords_updatePointWithOptCoords &&
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

class RequestupdatePointWithOptCoords extends Requestable {
  final updatePointWithOptCoordsVariables variables;

  RequestupdatePointWithOptCoords({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation updatePointWithOptCoords($pointData: PointDataOptCoordsInput!) {
  updatePointWithOptCoords(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'updatePointWithOptCoords',
    );
  }
}

class updatePointWithOptCoordsVariables {
  final PointDataOptCoordsInput pointData;

  updatePointWithOptCoordsVariables({required this.pointData});

  JsonObject toJson() {
    JsonObject data = {};

    data["pointData"] = pointData.toJson();

    return data;
  }

  updatePointWithOptCoordsVariables updateWith({
    PointDataOptCoordsInput? pointData,
  }) {
    final PointDataOptCoordsInput pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return updatePointWithOptCoordsVariables(pointData: pointData$next);
  }
}
