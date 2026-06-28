// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: ToyFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ V2 FRAGMENT WIDGET API -------------

extension type ToyFragRef.fromInput(shalom_core.ObservedRefInput _inner) {
  static const String fragmentName = 'ToyFrag';

  static ToyFragRef fromEntityKey(String entityKey) {
    return ToyFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static ToyFragRef fromId(String id) =>
      fromEntityKey(ToyFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [ToyFragData]. Returns `null` when absent or incomplete.
  ToyFragData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<ToyFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: ToyFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<ToyFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<ToyFragData>(
      ref: _inner,
      decoder: ToyFragData.fromCache,
    );
  }
}

abstract class ToyFrag {
  String get id;
  String get label;

  shalom_core.JsonObject toJson();
}

final class ToyFragData implements ToyFrag, shalom_core.FragmentInterface {
  final String id;
  final String label;

  const ToyFragData({required this.id, required this.label});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToyFragData && id == other.id && label == other.label);

  @override
  int get hashCode => Object.hashAll([id, label]);

  @override
  String fragment$Name() => 'ToyFrag';

  @override
  String entity$Type() => 'Toy';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Toy:123'`.
  static String entityKey(String id) => 'Toy:$id';

  static ToyFragData fromCache(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String label$value = data['label'] as String;
    return ToyFragData(id: id$value, label: label$value);
  }

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'label': this.label};
  }
}

abstract class $ToyFrag extends StatelessWidget {
  final ToyFragRef ref;
  const $ToyFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, ToyFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return ToyFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class ToyFragScope extends StatelessWidget {
  final ToyFragRef ref;
  final ShalomDataWidgetBuilder<ToyFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const ToyFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<ToyFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
