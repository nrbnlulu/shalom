// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointCoordsOptResponse {
  /// class members

  final UpdatePointCoordsOpt_updatePointCoordsOpt? updatePointCoordsOpt;

  // keywordargs constructor
  UpdatePointCoordsOptResponse({this.updatePointCoordsOpt});
  static UpdatePointCoordsOptResponse fromJson(JsonObject data) {
    final UpdatePointCoordsOpt_updatePointCoordsOpt? updatePointCoordsOpt_value;

    final JsonObject? updatePointCoordsOpt$raw = data['updatePointCoordsOpt'];
    if (updatePointCoordsOpt$raw != null) {
      updatePointCoordsOpt_value =
          UpdatePointCoordsOpt_updatePointCoordsOpt.fromJson(
            updatePointCoordsOpt$raw,
          );
    } else {
      updatePointCoordsOpt_value = null;
    }

    return UpdatePointCoordsOptResponse(
      updatePointCoordsOpt: updatePointCoordsOpt_value,
    );
  }

  UpdatePointCoordsOptResponse updateWithJson(JsonObject data) {
    final UpdatePointCoordsOpt_updatePointCoordsOpt? updatePointCoordsOpt_value;
    if (data.containsKey('updatePointCoordsOpt')) {
      final JsonObject? updatePointCoordsOpt$raw = data['updatePointCoordsOpt'];
      if (updatePointCoordsOpt$raw != null) {
        updatePointCoordsOpt_value =
            UpdatePointCoordsOpt_updatePointCoordsOpt.fromJson(
              updatePointCoordsOpt$raw,
            );
      } else {
        updatePointCoordsOpt_value = null;
      }
    } else {
      updatePointCoordsOpt_value = updatePointCoordsOpt;
    }

    return UpdatePointCoordsOptResponse(
      updatePointCoordsOpt: updatePointCoordsOpt_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsOptResponse &&
            other.updatePointCoordsOpt == updatePointCoordsOpt);
  }

  @override
  int get hashCode => updatePointCoordsOpt.hashCode;

  JsonObject toJson() {
    return {'updatePointCoordsOpt': updatePointCoordsOpt?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointCoordsOpt_updatePointCoordsOpt {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointCoordsOpt_updatePointCoordsOpt({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointCoordsOpt_updatePointCoordsOpt fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : rmhlxei.pointScalarImpl.deserialize(data['coords']);

    final String name_value;

    name_value = data['name'];

    final String id_value;

    id_value = data['id'];

    return UpdatePointCoordsOpt_updatePointCoordsOpt(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointCoordsOpt_updatePointCoordsOpt updateWithJson(JsonObject data) {
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

    return UpdatePointCoordsOpt_updatePointCoordsOpt(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsOpt_updatePointCoordsOpt &&
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
      query: r"""mutation UpdatePointCoordsOpt($coords: Point) {
  updatePointCoordsOpt(coords: $coords) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointCoordsOpt',
    );
  }
}

class UpdatePointCoordsOptVariables {
  final Option<rmhlxei.Point?> coords;

  UpdatePointCoordsOptVariables({this.coords = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (coords.isSome()) {
      if (coords.some() == null) {
        data["coords"] = null;
      } else {
        data["coords"] = rmhlxei.pointScalarImpl.serialize(coords.some()!);
      }
    }

    return data;
  }

  UpdatePointCoordsOptVariables updateWith({
    Option<Option<rmhlxei.Point?>> coords = const None(),
  }) {
    final Option<rmhlxei.Point?> coords$next;

    switch (coords) {
      case Some(value: final data):
        coords$next = data;
      case None():
        coords$next = this.coords;
    }

    return UpdatePointCoordsOptVariables(coords: coords$next);
  }
}
