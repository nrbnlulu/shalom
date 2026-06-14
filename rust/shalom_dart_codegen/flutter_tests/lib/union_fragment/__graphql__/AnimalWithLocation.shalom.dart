// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: AnimalWithLocation

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type AnimalWithLocationRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

abstract class AnimalWithLocation {
  String get id;

  shalom_core.JsonObject toJson();
}

class AnimalWithLocation__Dog_location {
  static String G__typename = "Location";

  /// class members
  final double lat;

  final double lng;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  AnimalWithLocation__Dog_location({required this.lat, required this.lng});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AnimalWithLocation__Dog_location &&
            lat == other.lat &&
            lng == other.lng);
  }

  @override
  int get hashCode =>
      Object.hashAll([lat, lng, AnimalWithLocation__Dog_location.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'lat': this.lat, 'lng': this.lng};
  }

  @experimental
  static AnimalWithLocation__Dog_location fromJson(
    shalom_core.JsonObject data,
  ) {
    final double lat$value = data['lat'] as double;
    final double lng$value = data['lng'] as double;
    return AnimalWithLocation__Dog_location(lat: lat$value, lng: lng$value);
  }
}

sealed class AnimalWithLocationData {
  const AnimalWithLocationData();

  @experimental
  static AnimalWithLocationData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Cat':
        return AnimalWithLocationData$Cat.fromJson(data);
      case 'Dog':
        return AnimalWithLocationData$Dog.fromJson(data);

      default:
        return const AnimalWithLocationData$Unknown();
    }
  }
}

final class AnimalWithLocationData$Cat extends AnimalWithLocationData {
  final String id;
  final String color;

  const AnimalWithLocationData$Cat({required this.id, required this.color});

  @experimental
  static AnimalWithLocationData$Cat fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String color$value = data['color'] as String;
    return AnimalWithLocationData$Cat(id: id$value, color: color$value);
  }
}

final class AnimalWithLocationData$Dog extends AnimalWithLocationData {
  final String id;
  final AnimalWithLocation__Dog_location? location;
  final String breed;

  const AnimalWithLocationData$Dog({
    required this.id,
    required this.location,
    required this.breed,
  });

  @experimental
  static AnimalWithLocationData$Dog fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final AnimalWithLocation__Dog_location? location$value =
        data['location'] == null
        ? null
        : AnimalWithLocation__Dog_location.fromJson(
            data['location'] as shalom_core.JsonObject,
          );
    final String breed$value = data['breed'] as String;
    return AnimalWithLocationData$Dog(
      id: id$value,

      location: location$value,

      breed: breed$value,
    );
  }
}

final class AnimalWithLocationData$Unknown extends AnimalWithLocationData {
  const AnimalWithLocationData$Unknown();
}

abstract class $AnimalWithLocation extends StatefulWidget {
  final AnimalWithLocationRef ref;
  const $AnimalWithLocation({super.key, required this.ref});

  Widget buildData(BuildContext context, AnimalWithLocationData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$AnimalWithLocation> createState() => _$AnimalWithLocationState();
}

class _$AnimalWithLocationState extends State<$AnimalWithLocation> {
  StreamSubscription<AnimalWithLocationData>? _sub;
  AnimalWithLocationData? _data;
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
  void didUpdateWidget(covariant $AnimalWithLocation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<AnimalWithLocationData>(
          ref: widget.ref.toInput,
          decoder: AnimalWithLocationData.fromCache,
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
