// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AnimalWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AnimalWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

sealed class AnimalWidgetData {
  const AnimalWidgetData();

  @experimental
  static AnimalWidgetData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Dog':
        return AnimalWidgetData$Dog.fromJson(data);
      case 'Cat':
        return AnimalWidgetData$Cat.fromJson(data);

      default:
        return const AnimalWidgetData$Unknown();
    }
  }
}

final class AnimalWidgetData$Dog extends AnimalWidgetData {
  final String id;
  final String breed;

  const AnimalWidgetData$Dog({required this.id, required this.breed});

  @experimental
  static AnimalWidgetData$Dog fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String breed$value = data['breed'] as String;
    return AnimalWidgetData$Dog(id: id$value, breed: breed$value);
  }
}

final class AnimalWidgetData$Cat extends AnimalWidgetData {
  final String id;
  final String color;

  const AnimalWidgetData$Cat({required this.id, required this.color});

  @experimental
  static AnimalWidgetData$Cat fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String color$value = data['color'] as String;
    return AnimalWidgetData$Cat(id: id$value, color: color$value);
  }
}

final class AnimalWidgetData$Unknown extends AnimalWidgetData {
  const AnimalWidgetData$Unknown();
}

abstract class $AnimalWidget extends StatefulWidget {
  final AnimalWidgetRef ref;
  const $AnimalWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, AnimalWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$AnimalWidget> createState() => _$AnimalWidgetState();
}

class _$AnimalWidgetState extends State<$AnimalWidget> {
  StreamSubscription<AnimalWidgetData>? _sub;
  AnimalWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $AnimalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<AnimalWidgetData>(
          ref: widget.ref.toInput,
          decoder: AnimalWidgetData.fromCache,
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
