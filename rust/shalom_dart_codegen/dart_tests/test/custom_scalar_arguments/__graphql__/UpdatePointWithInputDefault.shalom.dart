// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointWithInputDefaultResponse {
  /// class members

  final UpdatePointWithInputDefault_updatePointWithInputDefault?
  updatePointWithInputDefault;

  // keywordargs constructor
  UpdatePointWithInputDefaultResponse({this.updatePointWithInputDefault});
  static UpdatePointWithInputDefaultResponse fromJson(JsonObject data) {
    final UpdatePointWithInputDefault_updatePointWithInputDefault?
    updatePointWithInputDefault_value;

    final JsonObject? updatePointWithInputDefault$raw =
        data['updatePointWithInputDefault'];
    if (updatePointWithInputDefault$raw != null) {
      updatePointWithInputDefault_value =
          UpdatePointWithInputDefault_updatePointWithInputDefault.fromJson(
            updatePointWithInputDefault$raw,
          );
    } else {
      updatePointWithInputDefault_value = null;
    }

    return UpdatePointWithInputDefaultResponse(
      updatePointWithInputDefault: updatePointWithInputDefault_value,
    );
  }

  UpdatePointWithInputDefaultResponse updateWithJson(JsonObject data) {
    final UpdatePointWithInputDefault_updatePointWithInputDefault?
    updatePointWithInputDefault_value;
    if (data.containsKey('updatePointWithInputDefault')) {
      final JsonObject? updatePointWithInputDefault$raw =
          data['updatePointWithInputDefault'];
      if (updatePointWithInputDefault$raw != null) {
        updatePointWithInputDefault_value =
            UpdatePointWithInputDefault_updatePointWithInputDefault.fromJson(
              updatePointWithInputDefault$raw,
            );
      } else {
        updatePointWithInputDefault_value = null;
      }
    } else {
      updatePointWithInputDefault_value = updatePointWithInputDefault;
    }

    return UpdatePointWithInputDefaultResponse(
      updatePointWithInputDefault: updatePointWithInputDefault_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputDefaultResponse &&
            other.updatePointWithInputDefault == updatePointWithInputDefault);
  }

  @override
  int get hashCode => updatePointWithInputDefault.hashCode;

  JsonObject toJson() {
    return {
      'updatePointWithInputDefault': updatePointWithInputDefault?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointWithInputDefault_updatePointWithInputDefault {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointWithInputDefault_updatePointWithInputDefault({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointWithInputDefault_updatePointWithInputDefault fromJson(
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

    return UpdatePointWithInputDefault_updatePointWithInputDefault(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointWithInputDefault_updatePointWithInputDefault updateWithJson(
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

    return UpdatePointWithInputDefault_updatePointWithInputDefault(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputDefault_updatePointWithInputDefault &&
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

class RequestUpdatePointWithInputDefault extends Requestable {
  final UpdatePointWithInputDefaultVariables variables;

  RequestUpdatePointWithInputDefault({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation UpdatePointWithInputDefault($pointData: PointDataInputWithDefault!) {
  updatePointWithInputDefault(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointWithInputDefault',
    );
  }
}

class UpdatePointWithInputDefaultVariables {
  final PointDataInputWithDefault pointData;

  UpdatePointWithInputDefaultVariables({required this.pointData});

  JsonObject toJson() {
    JsonObject data = {};

    data["pointData"] = pointData.toJson();

    return data;
  }

  UpdatePointWithInputDefaultVariables updateWith({
    PointDataInputWithDefault? pointData,
  }) {
    final PointDataInputWithDefault pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return UpdatePointWithInputDefaultVariables(pointData: pointData$next);
  }
}
