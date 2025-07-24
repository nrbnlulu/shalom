// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointWithInputCoordsMaybeResponse {
  /// class members

  final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe?
  updatePointWithInputCoordsMaybe;

  // keywordargs constructor
  UpdatePointWithInputCoordsMaybeResponse({this.updatePointWithInputCoordsMaybe});
  static UpdatePointWithInputCoordsMaybeResponse fromJson(JsonObject data) {
    final UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe?
    updatePointWithInputCoordsMaybe_value;
    final updatePointWithInputCoordsMaybe$raw = data["updatePointWithInputCoordsMaybe"];
    updatePointWithInputCoordsMaybe_value =
        updatePointWithInputCoordsMaybe$raw == null
            ? null
            : UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.fromJson(
              updatePointWithInputCoordsMaybe$raw,
            );

    return UpdatePointWithInputCoordsMaybeResponse(
      updatePointWithInputCoordsMaybe: updatePointWithInputCoordsMaybe_value,
    );
  }

  static UpdatePointWithInputCoordsMaybeResponse deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = UpdatePointWithInputCoordsMaybeResponse.fromJson(data);

    return self;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputCoordsMaybeResponse &&
            other.updatePointWithInputCoordsMaybe == updatePointWithInputCoordsMaybe);
  }

  @override
  int get hashCode => updatePointWithInputCoordsMaybe.hashCode;

  JsonObject toJson() {
    return {'updatePointWithInputCoordsMaybe': this.updatePointWithInputCoordsMaybe?.toJson()};
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
  static UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe fromJson(JsonObject data) {
    final rmhlxei.Point? coords_value;
    final coords$raw = data["coords"];
    coords_value = coords$raw == null ? null : rmhlxei.pointScalarImpl.deserialize(coords$raw);

    final String name_value;
    final name$raw = data["name"];
    name_value = name$raw as String;

    final String id_value;
    final id$raw = data["id"];
    id_value = id$raw as String;

    return UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  static UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe deserialize(
    JsonObject data,
    ShalomContext context,
  ) {
    final self = UpdatePointWithInputCoordsMaybe_updatePointWithInputCoordsMaybe.fromJson(data);

    return self;
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
      'coords': this.coords == null ? null : rmhlxei.pointScalarImpl.serialize(this.coords!),

      'name': this.name,

      'id': this.id,
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
      query: r"""mutation UpdatePointWithInputCoordsMaybe($pointData: PointUpdateCoordsMaybe!) {
  updatePointWithInputCoordsMaybe(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      opName: 'UpdatePointWithInputCoordsMaybe',
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

  UpdatePointWithInputCoordsMaybeVariables updateWith({PointUpdateCoordsMaybe? pointData}) {
    final PointUpdateCoordsMaybe pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return UpdatePointWithInputCoordsMaybeVariables(pointData: pointData$next);
  }
}
