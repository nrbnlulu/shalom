// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: MinimalDogStatusFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type MinimalDogStatusFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'MinimalDogStatusFrag';

  static MinimalDogStatusFragRef fromEntityKey(String entityKey) {
    return MinimalDogStatusFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static MinimalDogStatusFragRef fromId(String id) =>
      fromEntityKey(MinimalDogStatusFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [MinimalDogStatusFragData]. Returns `null` when absent or incomplete.
  MinimalDogStatusFragData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<MinimalDogStatusFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: MinimalDogStatusFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<MinimalDogStatusFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<MinimalDogStatusFragData>(
      ref: _inner,
      decoder: MinimalDogStatusFragData.fromCache,
    );
  }
}

abstract class MinimalDogStatusFrag {
  String get id;
  MinimalDogStatusFrag_status get status;

  shalom_core.JsonObject toJson();
}

abstract class MinimalDogStatusFrag_status {
  String get $__typename;
  const MinimalDogStatusFrag_status();

  shalom_core.JsonObject toJson();

  static MinimalDogStatusFrag_status fromJson(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String;
    switch (typename) {
      case 'IdleStatus':
        return MinimalDogStatusFrag_status__IdleStatus.fromJson(data);
      case 'MovementStatus':
        return MinimalDogStatusFrag_status__MovementStatus.fromJson(data);

      default:
        throw Exception("Unknown typename $typename");
    }
  }
}

final class MinimalDogStatusFrag_status__IdleStatus
    extends MinimalDogStatusFrag_status {
  static String G__typename = "IdleStatus";

  /// class members

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const MinimalDogStatusFrag_status__IdleStatus();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MinimalDogStatusFrag_status__IdleStatus);
  }

  @override
  int get hashCode =>
      Object.hashAll([MinimalDogStatusFrag_status__IdleStatus.G__typename]);

  shalom_core.JsonObject toJson() {
    return {"__typename": MinimalDogStatusFrag_status__IdleStatus.G__typename};
  }

  static MinimalDogStatusFrag_status__IdleStatus fromJson(
    shalom_core.JsonObject data,
  ) {
    return MinimalDogStatusFrag_status__IdleStatus();
  }
}

final class MinimalDogStatusFrag_status__MovementStatus
    extends MinimalDogStatusFrag_status {
  static String G__typename = "MovementStatus";

  /// class members

  final String motionType;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const MinimalDogStatusFrag_status__MovementStatus({required this.motionType});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MinimalDogStatusFrag_status__MovementStatus &&
            motionType == other.motionType);
  }

  @override
  int get hashCode => Object.hashAll([
    motionType,

    MinimalDogStatusFrag_status__MovementStatus.G__typename,
  ]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": MinimalDogStatusFrag_status__MovementStatus.G__typename,

      'motionType': this.motionType,
    };
  }

  static MinimalDogStatusFrag_status__MovementStatus fromJson(
    shalom_core.JsonObject data,
  ) {
    final String motionType$value = data['motionType'] as String;
    return MinimalDogStatusFrag_status__MovementStatus(
      motionType: motionType$value,
    );
  }
}

final class MinimalDogStatusFragData
    implements MinimalDogStatusFrag, shalom_core.FragmentInterface {
  final String id;
  final MinimalDogStatusFrag_status status;

  const MinimalDogStatusFragData({required this.id, required this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MinimalDogStatusFragData &&
          id == other.id &&
          status == other.status);

  @override
  int get hashCode => Object.hashAll([id, status]);

  @override
  String fragment$Name() => 'MinimalDogStatusFrag';

  @override
  String entity$Type() => 'Dog';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Dog:123'`.
  static String entityKey(String id) => 'Dog:$id';

  static MinimalDogStatusFragData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final MinimalDogStatusFrag_status status$value =
        MinimalDogStatusFrag_status.fromJson(
          data['status'] as shalom_core.JsonObject,
        );
    return MinimalDogStatusFragData(id: id$value, status: status$value);
  }

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'status': this.status.toJson()};
  }
}

abstract class $MinimalDogStatusFrag extends StatelessWidget {
  final MinimalDogStatusFragRef ref;
  const $MinimalDogStatusFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, MinimalDogStatusFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return MinimalDogStatusFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class MinimalDogStatusFragScope extends StatelessWidget {
  final MinimalDogStatusFragRef ref;
  final ShalomDataWidgetBuilder<MinimalDogStatusFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const MinimalDogStatusFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<MinimalDogStatusFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
