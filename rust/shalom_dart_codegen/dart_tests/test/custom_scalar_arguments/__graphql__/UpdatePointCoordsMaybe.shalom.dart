// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointCoordsMaybeResponse {
  /// class members

  final UpdatePointCoordsMaybe_updatePointCoordsMaybe? updatePointCoordsMaybe;

  // keywordargs constructor
  UpdatePointCoordsMaybeResponse({this.updatePointCoordsMaybe});

  UpdatePointCoordsMaybeResponse updateWithJson(JsonObject data) {
    final UpdatePointCoordsMaybe_updatePointCoordsMaybe?
    updatePointCoordsMaybe_value;
    if (data.containsKey('updatePointCoordsMaybe')) {
      final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
      updatePointCoordsMaybe_value =
          updatePointCoordsMaybe$raw == null
              ? null
              : UpdatePointCoordsMaybe_updatePointCoordsMaybe.fromJson(
                updatePointCoordsMaybe$raw,
              );
    } else {
      updatePointCoordsMaybe_value = updatePointCoordsMaybe;
    }

    return UpdatePointCoordsMaybeResponse(
      updatePointCoordsMaybe: updatePointCoordsMaybe_value,
    );
  }

  static UpdatePointCoordsMaybeResponse fromJson(JsonObject data) {
    final UpdatePointCoordsMaybe_updatePointCoordsMaybe?
    updatePointCoordsMaybe_value;
    final updatePointCoordsMaybe$raw = data["updatePointCoordsMaybe"];
    updatePointCoordsMaybe_value =
        updatePointCoordsMaybe$raw == null
            ? null
            : UpdatePointCoordsMaybe_updatePointCoordsMaybe.fromJson(
              updatePointCoordsMaybe$raw,
            );

    return UpdatePointCoordsMaybeResponse(
      updatePointCoordsMaybe: updatePointCoordsMaybe_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsMaybeResponse &&
            other.updatePointCoordsMaybe == updatePointCoordsMaybe);
  }

  @override
  int get hashCode => updatePointCoordsMaybe.hashCode;

  JsonObject toJson() {
    return {'updatePointCoordsMaybe': this.updatePointCoordsMaybe?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointCoordsMaybe_updatePointCoordsMaybe {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointCoordsMaybe_updatePointCoordsMaybe({
    this.coords,
    required this.name,
    required this.id,
  });

  UpdatePointCoordsMaybe_updatePointCoordsMaybe updateWithJson(
    JsonObject data,
  ) {
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

    return UpdatePointCoordsMaybe_updatePointCoordsMaybe(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  static UpdatePointCoordsMaybe_updatePointCoordsMaybe fromJson(
    JsonObject data,
  ) {
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

    return UpdatePointCoordsMaybe_updatePointCoordsMaybe(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointCoordsMaybe_updatePointCoordsMaybe &&
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

class RequestUpdatePointCoordsMaybe extends Requestable {
  final UpdatePointCoordsMaybeVariables variables;

  RequestUpdatePointCoordsMaybe({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query: r"""mutation UpdatePointCoordsMaybe($coords: Point) {
  updatePointCoordsMaybe(coords: $coords) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'UpdatePointCoordsMaybe',
    );
  }
}

class UpdatePointCoordsMaybeVariables {
  final Option<rmhlxei.Point?> coords;

  UpdatePointCoordsMaybeVariables({this.coords = const None()});

  JsonObject toJson() {
    JsonObject data = {};

    if (coords.isSome()) {
      final value = this.coords.some();
      data["coords"] =
          value == null ? null : rmhlxei.pointScalarImpl.serialize(value!);
    }

    return data;
  }

  UpdatePointCoordsMaybeVariables updateWith({
    Option<Option<rmhlxei.Point?>> coords = const None(),
  }) {
    final Option<rmhlxei.Point?> coords$next;

    switch (coords) {
      case Some(value: final updateData):
        coords$next = updateData;
      case None():
        coords$next = this.coords;
    }

    return UpdatePointCoordsMaybeVariables(coords: coords$next);
  }
}
