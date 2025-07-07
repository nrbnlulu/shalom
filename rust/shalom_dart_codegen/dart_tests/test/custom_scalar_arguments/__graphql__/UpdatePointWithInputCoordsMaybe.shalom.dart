// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointWithInputCoordsMaybeResponse {
  /// class members

  final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe?
  updatePointWithInputCoordsMaybe;

  // keywordargs constructor
  UpdatePointWithInputCoordsMaybeResponse({
    this.updatePointWithInputCoordsMaybe,
  });
  static UpdatePointWithInputCoordsMaybeResponse fromJson(JsonObject data) {
    final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe?
    updatePointWithInputCoordsMaybe_value;

    final JsonObject? updatePointWithInputCoordsMaybe$raw =
        data['updatePointWithInputCoordsMaybe'];
    if (updatePointWithInputCoordsMaybe$raw != null) {
      updatePointWithInputCoordsMaybe_value =
          UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.fromJson(
            updatePointWithInputCoordsMaybe$raw,
          );
    } else {
      updatePointWithInputCoordsMaybe_value = null;
    }

    return UpdatePointWithInputCoordsMaybeResponse(
      updatePointWithInputCoordsMaybe: updatePointWithInputCoordsMaybe_value,
    );
  }

  UpdatePointWithInputCoordsMaybeResponse updateWithJson(JsonObject data) {
    final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe?
    updatePointWithInputCoordsMaybe_value;
    if (data.containsKey('updatePointWithInputCoordsMaybe')) {
      final JsonObject? updatePointWithInputCoordsMaybe$raw =
          data['updatePointWithInputCoordsMaybe'];
      if (updatePointWithInputCoordsMaybe$raw != null) {
        updatePointWithInputCoordsMaybe_value =
            UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.fromJson(
              updatePointWithInputCoordsMaybe$raw,
            );
      } else {
        updatePointWithInputCoordsMaybe_value = null;
      }
    } else {
      updatePointWithInputCoordsMaybe_value = updatePointWithInputCoordsMaybe;
    }

    return UpdatePointWithInputCoordsMaybeResponse(
      updatePointWithInputCoordsMaybe: updatePointWithInputCoordsMaybe_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputCoordsMaybeResponse &&
            other.updatePointWithInputCoordsMaybe ==
                updatePointWithInputCoordsMaybe);
  }

  @override
  int get hashCode => updatePointWithInputCoordsMaybe.hashCode;

  JsonObject toJson() {
    return {
      'updatePointWithInputCoordsMaybe':
          updatePointWithInputCoordsMaybe?.toJson(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe
  fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe
  updateWithJson(JsonObject data) {
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

    return UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe &&
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

class RequestUpdatePointWithInputCoordsMaybe extends Requestable {
  final UpdatePointWithInputCoordsMaybeVariables variables;

  RequestUpdatePointWithInputCoordsMaybe({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation UpdatePointWithInputCoordsMaybe($pointData: PointUpdateCoordsMaybe!) {
  updatePointWithInputCoordsMaybe(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointWithInputCoordsMaybe',
    );
  }
}

class UpdatePointWithInputCoordsMaybeVariables {
  final PointUpdateCoordsMaybe pointData;

  UpdatePointWithInputCoordsMaybeVariables({required this.pointData});

  JsonObject toJson() {
    JsonObject data = {};

    data["pointData"] = this.pointData.toJson();

    return data;
  }

  UpdatePointWithInputCoordsMaybeVariables updateWith({
    PointUpdateCoordsMaybe? pointData,
  }) {
    final PointUpdateCoordsMaybe pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return UpdatePointWithInputCoordsMaybeVariables(pointData: pointData$next);
  }
}
