// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";
import '../../custom_scalar/point.dart' as rmhlxei;

import 'package:shalom_core/shalom_core.dart';

typedef JsonObject = Map<String, dynamic>;

class UpdatePointWithInputNonNullResponse {
  /// class members

  final UpdatePointWithInputNonNull_updatePointWithInput? updatePointWithInput;

  // keywordargs constructor
  UpdatePointWithInputNonNullResponse({this.updatePointWithInput});
  static UpdatePointWithInputNonNullResponse fromJson(JsonObject data) {
    final UpdatePointWithInputNonNull_updatePointWithInput?
    updatePointWithInput_value;

    final JsonObject? updatePointWithInput$raw = data['updatePointWithInput'];
    if (updatePointWithInput$raw != null) {
      updatePointWithInput_value =
          UpdatePointWithInputNonNull_updatePointWithInput.fromJson(
            updatePointWithInput$raw,
          );
    } else {
      updatePointWithInput_value = null;
    }

    return UpdatePointWithInputNonNullResponse(
      updatePointWithInput: updatePointWithInput_value,
    );
  }

  UpdatePointWithInputNonNullResponse updateWithJson(JsonObject data) {
    final UpdatePointWithInputNonNull_updatePointWithInput?
    updatePointWithInput_value;
    if (data.containsKey('updatePointWithInput')) {
      final JsonObject? updatePointWithInput$raw = data['updatePointWithInput'];
      if (updatePointWithInput$raw != null) {
        updatePointWithInput_value =
            UpdatePointWithInputNonNull_updatePointWithInput.fromJson(
              updatePointWithInput$raw,
            );
      } else {
        updatePointWithInput_value = null;
      }
    } else {
      updatePointWithInput_value = updatePointWithInput;
    }

    return UpdatePointWithInputNonNullResponse(
      updatePointWithInput: updatePointWithInput_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputNonNullResponse &&
            other.updatePointWithInput == updatePointWithInput);
  }

  @override
  int get hashCode => updatePointWithInput.hashCode;

  JsonObject toJson() {
    return {'updatePointWithInput': updatePointWithInput?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class UpdatePointWithInputNonNull_updatePointWithInput {
  /// class members

  final rmhlxei.Point? coords;

  final String name;

  final String id;

  // keywordargs constructor
  UpdatePointWithInputNonNull_updatePointWithInput({
    this.coords,
    required this.name,
    required this.id,
  });
  static UpdatePointWithInputNonNull_updatePointWithInput fromJson(
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

    return UpdatePointWithInputNonNull_updatePointWithInput(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  UpdatePointWithInputNonNull_updatePointWithInput updateWithJson(
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

    return UpdatePointWithInputNonNull_updatePointWithInput(
      coords: coords_value,

      name: name_value,

      id: id_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePointWithInputNonNull_updatePointWithInput &&
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

class RequestUpdatePointWithInputNonNull extends Requestable {
  final UpdatePointWithInputNonNullVariables variables;

  RequestUpdatePointWithInputNonNull({required this.variables});

  @override
  Request toRequest() {
    JsonObject variablesJson = variables.toJson();
    return Request(
      query:
          r"""mutation UpdatePointWithInputNonNull($pointData: PointDataInput!) {
  updatePointWithInput(pointData: $pointData) {
    coords
    name
    id
  }
}""",
      variables: variablesJson,
      opType: OperationType.Mutation,
      StringopName: 'UpdatePointWithInputNonNull',
    );
  }
}

class UpdatePointWithInputNonNullVariables {
  final PointDataInput pointData;

  UpdatePointWithInputNonNullVariables({required this.pointData});

  JsonObject toJson() {
    JsonObject data = {};

    data["pointData"] = pointData.toJson();

    return data;
  }

  UpdatePointWithInputNonNullVariables updateWith({PointDataInput? pointData}) {
    final PointDataInput pointData$next;

    if (pointData != null) {
      pointData$next = pointData;
    } else {
      pointData$next = this.pointData;
    }

    return UpdatePointWithInputNonNullVariables(pointData: pointData$next);
  }
}

// ------------ Node DEFINITIONS -------------

class UpdatePointWithInputNonNullNode extends Node {
  UpdatePointWithInputNonNullResponse? _obj;
  UpdatePointWithInputNonNullNode({required super.id});

  @override
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = UpdatePointWithInputNonNullResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
      _obj = _obj?.updateWithJson(newData);
    } else {
      _obj = UpdatePointWithInputNonNullResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
    if (data != null) {
      _obj = UpdatePointWithInputNonNullResponse.fromJson(data);
    }
  }

  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  UpdatePointWithInputNonNullResponse? get obj {
    return _obj;
  }
}

// ------------ END Node DEFINITIONS -------------
