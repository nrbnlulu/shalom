// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PlanetWidget

import "../schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type PlanetWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

final class PlanetWidgetData {
  final int? diameter;
  final String? name;
  final double? population;
  final List<String?>? climates;
  final String id;
  final List<String?>? terrains;

  const PlanetWidgetData({
    required this.diameter,
    required this.name,
    required this.population,
    required this.climates,
    required this.id,
    required this.terrains,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanetWidgetData &&
          diameter == other.diameter &&
          name == other.name &&
          population == other.population &&
          const ListEquality().equals(climates, other.climates) &&
          id == other.id &&
          const ListEquality().equals(terrains, other.terrains));

  @override
  int get hashCode =>
      Object.hashAll([diameter, name, population, climates, id, terrains]);

  @experimental
  static PlanetWidgetData fromCache(shalom_core.JsonObject data) {
    final int? diameter$value = data['diameter'] as int?;
    final String? name$value = data['name'] as String?;
    final double? population$value = data['population'] as double?;
    final List<String?>? climates$value =
        data['climates'] == null
            ? null
            : (data['climates'] as List<dynamic>)
                .map((e) => e as String?)
                .toList();
    final String id$value = data['id'] as String;
    final List<String?>? terrains$value =
        data['terrains'] == null
            ? null
            : (data['terrains'] as List<dynamic>)
                .map((e) => e as String?)
                .toList();
    return PlanetWidgetData(
      diameter: diameter$value,

      name: name$value,

      population: population$value,

      climates: climates$value,

      id: id$value,

      terrains: terrains$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'diameter': this.diameter,

      'name': this.name,

      'population': this.population,

      'climates': this.climates?.map((e) => e).toList(),

      'id': this.id,

      'terrains': this.terrains?.map((e) => e).toList(),
    };
  }
}

abstract class $PlanetWidget extends StatefulWidget {
  final PlanetWidgetRef ref;
  const $PlanetWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, PlanetWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$PlanetWidget> createState() => _$PlanetWidgetState();
}

class _$PlanetWidgetState extends State<$PlanetWidget> {
  StreamSubscription<PlanetWidgetData>? _sub;
  PlanetWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $PlanetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<PlanetWidgetData>(
          ref: widget.ref.toInput,
          decoder: PlanetWidgetData.fromCache,
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
