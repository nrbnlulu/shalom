// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: DogWithFriendWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;

// ------------ V2 FRAGMENT WIDGET API -------------

extension type DogWithFriendWidgetRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {
    'observable_id': _inner.observableId,
    'anchor': _inner.anchor,
  };
}

abstract class DogWithFriendWidget {
  DogWithFriendWidget_friend? get friend;

  String get breed;

  String get id;

  shalom_core.JsonObject toJson();
}

sealed class DogWithFriendWidget_friend {
  const DogWithFriendWidget_friend();
  shalom_core.JsonObject toJson();
  @experimental
  static DogWithFriendWidget_friend fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'Cat':
        return DogWithFriendWidget_friend$Cat.fromJson(data);
      case 'Dog':
        return DogWithFriendWidget_friend$Dog.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

final class DogWithFriendWidget_friend$Cat extends DogWithFriendWidget_friend {
  final String color;
  final String id;

  const DogWithFriendWidget_friend$Cat({required this.color, required this.id});
  @override
  shalom_core.JsonObject toJson() {
    return {'__typename': 'Cat', 'color': this.color, 'id': this.id};
  }

  @experimental
  static DogWithFriendWidget_friend$Cat fromJson(shalom_core.JsonObject data) {
    final String color$value = data['color'] as String;
    final String id$value = data['id'] as String;
    return DogWithFriendWidget_friend$Cat(color: color$value, id: id$value);
  }
}

final class DogWithFriendWidget_friend$Dog extends DogWithFriendWidget_friend {
  final String id;
  final String breed;

  const DogWithFriendWidget_friend$Dog({required this.id, required this.breed});
  @override
  shalom_core.JsonObject toJson() {
    return {'__typename': 'Dog', 'id': this.id, 'breed': this.breed};
  }

  @experimental
  static DogWithFriendWidget_friend$Dog fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String breed$value = data['breed'] as String;
    return DogWithFriendWidget_friend$Dog(id: id$value, breed: breed$value);
  }
}

final class DogWithFriendWidgetData {
  final String id;
  final DogWithFriendWidget_friend? friend;
  final String breed;

  const DogWithFriendWidgetData({
    required this.id,
    required this.friend,
    required this.breed,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DogWithFriendWidgetData &&
          id == other.id &&
          friend == other.friend &&
          breed == other.breed);

  @override
  int get hashCode => Object.hashAll([id, friend, breed]);

  @experimental
  static DogWithFriendWidgetData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final DogWithFriendWidget_friend? friend$value = data['friend'] == null
        ? null
        : DogWithFriendWidget_friend.fromJson(
            data['friend'] as shalom_core.JsonObject,
          );
    final String breed$value = data['breed'] as String;
    return DogWithFriendWidgetData(
      id: id$value,

      friend: friend$value,

      breed: breed$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'friend': this.friend?.toJson(),

      'breed': this.breed,
    };
  }
}

abstract class $DogWithFriendWidget extends StatefulWidget {
  final DogWithFriendWidgetRef ref;
  const $DogWithFriendWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, DogWithFriendWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$DogWithFriendWidget> createState() => _$DogWithFriendWidgetState();
}

class _$DogWithFriendWidgetState extends State<$DogWithFriendWidget> {
  StreamSubscription<DogWithFriendWidgetData>? _sub;
  DogWithFriendWidgetData? _data;
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
  void didUpdateWidget(covariant $DogWithFriendWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<DogWithFriendWidgetData>(
          ref: widget.ref.toInput,
          decoder: DogWithFriendWidgetData.fromCache,
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
