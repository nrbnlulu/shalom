// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: ExtendedDogStatusFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'MinimalDogStatusFrag.shalom.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type ExtendedDogStatusFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'ExtendedDogStatusFrag';

  static ExtendedDogStatusFragRef fromEntityKey(String entityKey) {
    return ExtendedDogStatusFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static ExtendedDogStatusFragRef fromId(String id) =>
      fromEntityKey(ExtendedDogStatusFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [ExtendedDogStatusFragData]. Returns `null` when absent or incomplete.
  ExtendedDogStatusFragData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<ExtendedDogStatusFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: ExtendedDogStatusFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<ExtendedDogStatusFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<ExtendedDogStatusFragData>(
      ref: _inner,
      decoder: ExtendedDogStatusFragData.fromCache,
    );
  }
}

abstract class ExtendedDogStatusFrag implements MinimalDogStatusFrag {
  String get id;
  ExtendedDogStatusFrag_status get status;

  shalom_core.JsonObject toJson();
}

sealed class ExtendedDogStatusFrag_status
    implements MinimalDogStatusFrag_status {
  String get originMessage;

  String get $__typename;
  const ExtendedDogStatusFrag_status();

  shalom_core.JsonObject toJson();

  static ExtendedDogStatusFrag_status fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'IdleStatus':
        return ExtendedDogStatusFrag_status__IdleStatus.fromJson(data);
      case 'MovementStatus':
        return ExtendedDogStatusFrag_status__MovementStatus.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

final class ExtendedDogStatusFrag_status__IdleStatus
    extends ExtendedDogStatusFrag_status {
  static String G__typename = "IdleStatus";

  /// class members

  final String originMessage;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ExtendedDogStatusFrag_status__IdleStatus({required this.originMessage});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ExtendedDogStatusFrag_status__IdleStatus &&
            originMessage == other.originMessage);
  }

  @override
  int get hashCode => Object.hashAll([
    originMessage,

    ExtendedDogStatusFrag_status__IdleStatus.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ExtendedDogStatusFrag_status__IdleStatus.G__typename,

      'originMessage': this.originMessage,
    };
  }

  static ExtendedDogStatusFrag_status__IdleStatus fromJson(
    shalom_core.JsonObject data,
  ) {
    final String originMessage$value = data['originMessage'] as String;
    return ExtendedDogStatusFrag_status__IdleStatus(
      originMessage: originMessage$value,
    );
  }
}

final class ExtendedDogStatusFrag_status__MovementStatus
    extends ExtendedDogStatusFrag_status {
  static String G__typename = "MovementStatus";

  /// class members

  final String motionType;

  final String originMessage;

  final int sensitivity;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const ExtendedDogStatusFrag_status__MovementStatus({
    required this.motionType,

    required this.originMessage,

    required this.sensitivity,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ExtendedDogStatusFrag_status__MovementStatus &&
            motionType == other.motionType &&
            originMessage == other.originMessage &&
            sensitivity == other.sensitivity);
  }

  @override
  int get hashCode => Object.hashAll([
    motionType,

    originMessage,

    sensitivity,

    ExtendedDogStatusFrag_status__MovementStatus.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": ExtendedDogStatusFrag_status__MovementStatus.G__typename,

      'motionType': this.motionType,

      'originMessage': this.originMessage,

      'sensitivity': this.sensitivity,
    };
  }

  static ExtendedDogStatusFrag_status__MovementStatus fromJson(
    shalom_core.JsonObject data,
  ) {
    final String motionType$value = data['motionType'] as String;
    final String originMessage$value = data['originMessage'] as String;
    final int sensitivity$value = data['sensitivity'] as int;
    return ExtendedDogStatusFrag_status__MovementStatus(
      motionType: motionType$value,

      originMessage: originMessage$value,

      sensitivity: sensitivity$value,
    );
  }
}

final class ExtendedDogStatusFragData
    implements ExtendedDogStatusFrag, shalom_core.FragmentInterface {
  final String id;
  final ExtendedDogStatusFrag_status status;

  const ExtendedDogStatusFragData({required this.id, required this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtendedDogStatusFragData &&
          id == other.id &&
          status == other.status);

  @override
  int get hashCode => Object.hashAll([id, status]);

  @override
  String fragment$Name() => 'ExtendedDogStatusFrag';

  @override
  String entity$Type() => 'Dog';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Dog:123'`.
  static String entityKey(String id) => 'Dog:$id';

  static ExtendedDogStatusFragData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final ExtendedDogStatusFrag_status status$value =
        ExtendedDogStatusFrag_status.fromJson(
          data['status'] as shalom_core.JsonObject,
        );
    return ExtendedDogStatusFragData(id: id$value, status: status$value);
  }

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'status': this.status.toJson()};
  }
}

abstract class $ExtendedDogStatusFrag extends StatelessWidget {
  final ExtendedDogStatusFragRef ref;
  const $ExtendedDogStatusFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, ExtendedDogStatusFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return ExtendedDogStatusFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class ExtendedDogStatusFragScope extends StatelessWidget {
  final ExtendedDogStatusFragRef ref;
  final ShalomDataWidgetBuilder<ExtendedDogStatusFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const ExtendedDogStatusFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<ExtendedDogStatusFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
