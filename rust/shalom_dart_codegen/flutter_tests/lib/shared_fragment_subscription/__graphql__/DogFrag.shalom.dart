// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: DogFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type DogFragRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

abstract class DogFrag {
  String get id;

  String get name;

  String get breed;

  shalom_core.JsonObject toJson();
}

final class DogFragData {
  final String breed;
  final String id;
  final String name;

  const DogFragData({
    required this.breed,
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DogFragData &&
          breed == other.breed &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hashAll([breed, id, name]);

  static DogFragData fromCache(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final String id$value = data['id'] as String;
    final String name$value = data['name'] as String;
    return DogFragData(breed: breed$value, id: id$value, name: name$value);
  }

  shalom_core.JsonObject toJson() {
    return {'breed': this.breed, 'id': this.id, 'name': this.name};
  }
}

abstract class $DogFrag extends StatefulWidget {
  final DogFragRef ref;
  const $DogFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, DogFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$DogFrag> createState() => _$DogFragState();
}

class _$DogFragState extends State<$DogFrag> {
  StreamSubscription<DogFragData>? _sub;
  DogFragData? _data;
  Object? _error;

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      _data = null;
      _error = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $DogFrag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<DogFragData>(
          ref: widget.ref.toInput,
          decoder: DogFragData.fromCache,
        )
        .listen(
          (data) => setState(() {
            _data = data;
            _error = null;
          }),
          onError: (e) => setState(() {
            _error = e;
          }),
          onDone: () {
            if (mounted) _subscribe();
          },
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
