// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PersonWidget

import "../schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type PersonWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

final class PersonWidgetData {
  final String? birthYear;
  final String? name;
  final String? hairColor;
  final String id;
  final double? mass;
  final String? gender;
  final int? height;
  final String? eyeColor;

  const PersonWidgetData({
    required this.birthYear,
    required this.name,
    required this.hairColor,
    required this.id,
    required this.mass,
    required this.gender,
    required this.height,
    required this.eyeColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonWidgetData &&
          birthYear == other.birthYear &&
          name == other.name &&
          hairColor == other.hairColor &&
          id == other.id &&
          mass == other.mass &&
          gender == other.gender &&
          height == other.height &&
          eyeColor == other.eyeColor);

  @override
  int get hashCode => Object.hashAll([
    birthYear,
    name,
    hairColor,
    id,
    mass,
    gender,
    height,
    eyeColor,
  ]);

  @experimental
  static PersonWidgetData fromCache(shalom_core.JsonObject data) {
    final String? birthYear$value = data['birthYear'] as String?;
    final String? name$value = data['name'] as String?;
    final String? hairColor$value = data['hairColor'] as String?;
    final String id$value = data['id'] as String;
    final double? mass$value = data['mass'] as double?;
    final String? gender$value = data['gender'] as String?;
    final int? height$value = data['height'] as int?;
    final String? eyeColor$value = data['eyeColor'] as String?;
    return PersonWidgetData(
      birthYear: birthYear$value,

      name: name$value,

      hairColor: hairColor$value,

      id: id$value,

      mass: mass$value,

      gender: gender$value,

      height: height$value,

      eyeColor: eyeColor$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'birthYear': this.birthYear,

      'name': this.name,

      'hairColor': this.hairColor,

      'id': this.id,

      'mass': this.mass,

      'gender': this.gender,

      'height': this.height,

      'eyeColor': this.eyeColor,
    };
  }
}

abstract class $PersonWidget extends StatefulWidget {
  final PersonWidgetRef ref;
  const $PersonWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, PersonWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$PersonWidget> createState() => _$PersonWidgetState();
}

class _$PersonWidgetState extends State<$PersonWidget> {
  StreamSubscription<PersonWidgetData>? _sub;
  PersonWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $PersonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<PersonWidgetData>(
          ref: widget.ref.toInput,
          decoder: PersonWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() {
            _data = data;
            _error = null;
          }),
          onError:
              (e) => setState(() {
                _error = e;
              }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null) return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
