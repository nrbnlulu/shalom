// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointWithInputCoordsOptResponse {
  /// class members

  final UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt?
  updatePointWithInputCoordsOpt;

  // keywordargs constructor
  UpdatePointWithInputCoordsOptResponse({this.updatePointWithInputCoordsOpt});
  static UpdatePointWithInputCoordsOptResponse fromJson(JsonObject data) {
    final UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt?
    updatePointWithInputCoordsOpt_value;

    final JsonObject? updatePointWithInputCoordsOpt$raw =
        data['updatePointWithInputCoordsOpt'];
    if (updatePointWithInputCoordsOpt$raw != null) {
      updatePointWithInputCoordsOpt_value =
          UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt.fromJson(
            updatePointWithInputCoordsOpt$raw,
          );
    } else {
      updatePointWithInputCoordsOpt_value = null;
    }

    return UpdatePointWithInputCoordsOptResponse(
      updatePointWithInputCoordsOpt: updatePointWithInputCoordsOpt_value,
    );
  }

  UpdatePointWithInputCoordsOptResponse updateWithJson(JsonObject data) {
    final UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt?
    updatePointWithInputCoordsOpt_value;
    if (data.containsKey('updatePointWithInputCoordsOpt')) {
      final JsonObject? updatePointWithInputCoordsOpt$raw =
          data['updatePointWithInputCoordsOpt'];
      if (updatePointWithInputCoordsOpt$raw != null) {
        updatePointWithInputCoordsOpt_value =
            UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt.fromJson(
              updatePointWithInputCoordsOpt$raw,
            );
      } else {
        updatePointWithInputCoordsOpt_value = null;
      }
    } else {
      updatePointWithInputCoordsOpt_value = updatePointWithInputCoordsOpt;
    }

    return UpdatePointWithInputCoordsOptResponse(
      updatePointWithInputCoordsOpt: updatePointWithInputCoordsOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputCoordsOptResponse &&
            other.updatePointWithInputCoordsOpt ==
                updatePointWithInputCoordsOpt);
  }

  @override
  int get hashCode => updatePointWithInputCoordsOpt.hashCode;

  JsonObject toJson() {
    return {
      'updatePointWithInputCoordsOpt': updatePointWithInputCoordsOpt?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt fromJson(
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

    return UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt updateWithJson(
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

    return UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputCoordsOpt_updatePointWithInputCoordsOpt &&
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

class RequestUpdatePointWithInputCoordsOpt extends Requestable {
  final UpdatePointWithInputCoordsOptVariables variables;

  RequestUpdatePointWithInputCoordsOpt({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation UpdatePointWithInputCoordsOpt($pointData: PointUpdateCoordsOpt!) {
  updatePointWithInputCoordsOpt(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointWithInputCoordsOpt',
    );
  }
}

class UpdatePointWithInputCoordsOptVariables {
  final PointUpdateCoordsOpt pointData;

  UpdatePointWithInputCoordsOptVariables({required this.pointData});

  JsonObject toJson() {
    JsonObject data = {};

    data["pointData"] = pointData.toJson();

    return data;
  }

  UpdatePointWithInputCoordsOptVariables updateWith({
    PointUpdateCoordsOpt? pointData,
  }) {
    final PointUpdateCoordsOpt pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return UpdatePointWithInputCoordsOptVariables(pointData: pointData$next);
  }
}
