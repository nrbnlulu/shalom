// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: PetWidget

import "../../../__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type PetWidgetRef._(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
}

sealed class PetWidgetData {
  const PetWidgetData();

  @experimental
  static PetWidgetData fromCache(shalom_core.JsonObject data) {
    return PetWidgetData$Impl.fromJson(data);
  }
}

final class PetWidgetData$Impl extends PetWidgetData {
  final String name;
  final String id;

  const PetWidgetData$Impl({required this.name, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetWidgetData$Impl && name == other.name && id == other.id);

  @override
  int get hashCode => Object.hash(name, id);

  @experimental
  static PetWidgetData$Impl fromJson(shalom_core.JsonObject data) {
    final String name$value = data['name'] as String;
    final String id$value = data['id'] as String;
    return PetWidgetData$Impl(name: name$value, id: id$value);
  }

  shalom_core.JsonObject toJson() {
    return {'name': this.name, 'id': this.id};
  }
}

final class PetWidgetData$Unknown extends PetWidgetData {
  const PetWidgetData$Unknown();
}

abstract class $PetWidget extends StatefulWidget {
  final PetWidgetRef ref;
  const $PetWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, PetWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$PetWidget> createState() => _$PetWidgetState();
}

class _$PetWidgetState extends State<$PetWidget> {
  StreamSubscription<PetWidgetData>? _sub;
  PetWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $PetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<PetWidgetData>(
          ref: widget.ref.toInput,
          decoder: PetWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() {
            _data = data;
            _error = null;
          }),
          onError: (e) => setState(() {
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
