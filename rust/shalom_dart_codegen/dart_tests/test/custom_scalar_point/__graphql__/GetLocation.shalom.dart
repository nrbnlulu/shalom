import 'package:shalom_core/shalom_core.dart';

import '../point.dart';

typedef JsonObject = Map<String, dynamic>;
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

class GetLocationResponse {
  /// class members

  final GetLocation_getLocation? getLocation;

  // keywordargs constructor
  GetLocationResponse({this.getLocation});
  static GetLocationResponse fromJson(JsonObject data) {
    final GetLocation_getLocation? getLocation_value;

    final JsonObject? getLocation$raw = data['getLocation'];
    if (getLocation$raw != null) {
      getLocation_value = GetLocation_getLocation.fromJson(getLocation$raw);
    } else {
      getLocation_value = null;
    }

    return GetLocationResponse(getLocation: getLocation_value);
  }

  GetLocationResponse updateWithJson(JsonObject data) {
    final GetLocation_getLocation? getLocation_value;
    if (data.containsKey('getLocation')) {
      final JsonObject? getLocation$raw = data['getLocation'];
      if (getLocation$raw != null) {
        getLocation_value = GetLocation_getLocation.fromJson(getLocation$raw);
      } else {
        getLocation_value = null;
      }
    } else {
      getLocation_value = getLocation;
    }

    return GetLocationResponse(getLocation: getLocation_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetLocationResponse && other.getLocation == getLocation);
  }

  @override
  int get hashCode => getLocation.hashCode;

  JsonObject toJson() {
    return {'getLocation': getLocation?.toJson()};
  }
}

// ------------ OBJECT DEFINITIONS -------------

class GetLocation_getLocation {
  /// class members

  final String id;

  final Point? coords;

  // keywordargs constructor
  GetLocation_getLocation({required this.id, this.coords});
  static GetLocation_getLocation fromJson(JsonObject data) {
    final String id_value;

    id_value = data['id'];

    final Point? coords_value;

    coords_value =
        data['coords'] == null
            ? null
            : customScalars['Point']!.deserialize(data['coords']);

    return GetLocation_getLocation(id: id_value, coords: coords_value);
  }

  GetLocation_getLocation updateWithJson(JsonObject data) {
    final String id_value;
    if (data.containsKey('id')) {
      id_value = data['id'];
    } else {
      id_value = id;
    }

    final Point? coords_value;
    if (data.containsKey('coords')) {
      coords_value =
          data['coords'] == null
              ? null
              : customScalars['Point']!.deserialize(data['coords']);
    } else {
      coords_value = coords;
    }

    return GetLocation_getLocation(id: id_value, coords: coords_value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GetLocation_getLocation &&
            other.id == id &&
            other.coords == coords);
  }

  @override
  int get hashCode => Object.hashAll([id, coords]);

  JsonObject toJson() {
    return {
      'id': id,

      'coords':
          coords == null ? null : customScalars['Point']!.serialize(coords),
    };
  }
}

// ------------ END OBJECT DEFINITIONS -------------

class RequestGetLocation extends Requestable {
  RequestGetLocation();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query GetLocation {
  getLocation {
    id
    coords
  }
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      StringopName: 'GetLocation',
    );
  }
}
