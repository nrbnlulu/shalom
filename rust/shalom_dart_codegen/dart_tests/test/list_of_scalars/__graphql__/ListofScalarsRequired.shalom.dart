// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";
import 'dart:async';

import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';

typedef JsonObject = Map<String, dynamic>;

class ListofScalarsRequiredResponse {
  /// class members

  final List<String> listOfScalarsRequired;

  // keywordargs constructor
  ListofScalarsRequiredResponse({required this.listOfScalarsRequired});
  static ListofScalarsRequiredResponse fromJson(
    JsonObject data,
    ShalomContext? context,
  ) {
    final List<String> listOfScalarsRequired_value;
    final listOfScalarsRequired$raw = data["listOfScalarsRequired"];
    listOfScalarsRequired_value =
        (listOfScalarsRequired$raw as List<dynamic>)
            .map((e) => e as String)
            .toList();

    return ListofScalarsRequiredResponse(
      listOfScalarsRequired: listOfScalarsRequired_value,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ListofScalarsRequiredResponse &&
            const ListEquality().equals(
              other.listOfScalarsRequired,
              listOfScalarsRequired,
            ));
  }

  @override
  int get hashCode => listOfScalarsRequired.hashCode;

  JsonObject toJson() {
    return {
      'listOfScalarsRequired':
          this.listOfScalarsRequired.map((e) => e).toList(),
    };
  }
}

// ------------ OBJECT DEFINITIONS -------------

// ------------ END OBJECT DEFINITIONS -------------

class RequestListofScalarsRequired extends Requestable {
  RequestListofScalarsRequired();

  @override
  Request toRequest() {
    JsonObject variablesJson = {};
    return Request(
      query: r"""query ListofScalarsRequired {
  listOfScalarsRequired
}""",
      variables: variablesJson,
      opType: OperationType.Query,
      opName: 'ListofScalarsRequired',
    );
  }
}
