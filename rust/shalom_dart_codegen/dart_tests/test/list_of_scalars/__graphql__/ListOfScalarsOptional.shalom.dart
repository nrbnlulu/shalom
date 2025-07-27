// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class ListOfScalarsOptionalResponse {
  /// class members

  List<String>? listOfScalarsOptional;

  // keywordargs constructor
  ListOfScalarsOptionalResponse({this.listOfScalarsOptional});
  static ListOfScalarsOptionalResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final List<String>? listOfScalarsOptional_value;
    final listOfScalarsOptional$raw = data["listOfScalarsOptional"];

    listOfScalarsOptional_value =
        listOfScalarsOptional$raw == null
            ? null
            : (listOfScalarsOptional$raw as List<dynamic>)
                .map((e) => e as String)
                .toList();

    return ListOfScalarsOptionalResponse(
      listOfScalarsOptional: listOfScalarsOptional_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ListOfScalarsOptionalResponse &&
            const ListEquality().equals(
              other.listOfScalarsOptional,
              listOfScalarsOptional,
            ));
  }

  @override
  int get hashCode => listOfScalarsOptional.hashCode;

  JsonObject toJson() {
    return {
      'listOfScalarsOptional':
          this.listOfScalarsOptional?.map((e) => e).toList(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestListOfScalarsOptional extends Requestable {
  RequestListOfScalarsOptional();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query ListOfScalarsOptional {
  listOfScalarsOptional
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'ListOfScalarsOptional',
    );
  }
}
