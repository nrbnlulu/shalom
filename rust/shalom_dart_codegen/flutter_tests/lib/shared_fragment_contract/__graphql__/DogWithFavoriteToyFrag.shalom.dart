// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: DogWithFavoriteToyFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'CommonAnimalFrag.shalom.dart';
import 'HasFavoriteToyFrag.shalom.dart';
import 'ToyFrag.shalom.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type DogWithFavoriteToyFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'DogWithFavoriteToyFrag';

  static DogWithFavoriteToyFragRef fromEntityKey(String entityKey) {
    return DogWithFavoriteToyFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static DogWithFavoriteToyFragRef fromId(String id) =>
      fromEntityKey(DogWithFavoriteToyFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    '__shalom_observed_ref': shalom_core.shalomJsonObject({
      'observable_id': shalom_core.shalomJsonValue(_inner.observableId),
      'anchor': shalom_core.shalomJsonValue(_inner.anchor),
    }),
  });

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [DogWithFavoriteToyFragData]. Returns `null` when absent or incomplete.
  Future<DogWithFavoriteToyFragData?> readFrom(
    shalom_core.CacheProxy cache,
  ) async {
    return await cache.readFragment<DogWithFavoriteToyFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      bridgeDecoder: DogWithFavoriteToyFragData.fromShalomValue,
    );
  }

  Stream<shalom_core.GraphQLResponse<DogWithFavoriteToyFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<DogWithFavoriteToyFragData>(
      ref: _inner,
      bridgeDecoder: DogWithFavoriteToyFragData.fromShalomValue,
    );
  }
}

abstract class DogWithFavoriteToyFrag
    implements CommonAnimalFrag, HasFavoriteToyFrag {
  String get breed;
  HasFavoriteToyFrag_favoriteToy get favoriteToy;
  String get id;

  shalom_core.JsonObject toJson();
  shalom_core.ShalomJsonValue toShalomValue();
}

final class DogWithFavoriteToyFragData
    implements DogWithFavoriteToyFrag, shalom_core.FragmentInterface {
  final String breed;
  final HasFavoriteToyFrag_favoriteToy favoriteToy;
  final String id;

  const DogWithFavoriteToyFragData({
    required this.breed,
    required this.favoriteToy,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DogWithFavoriteToyFragData &&
          breed == other.breed &&
          favoriteToy == other.favoriteToy &&
          id == other.id);

  @override
  int get hashCode => Object.hashAll([breed, favoriteToy, id]);

  @override
  String fragment$Name() => 'DogWithFavoriteToyFrag';

  @override
  String entity$Type() => 'Dog';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Dog:123'`.
  static String entityKey(String id) => 'Dog:$id';

  static DogWithFavoriteToyFragData fromCache(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final HasFavoriteToyFrag_favoriteToy favoriteToy$value =
        HasFavoriteToyFrag_favoriteToy.fromJson(
          data['favoriteToy'] as shalom_core.JsonObject,
        );
    final String id$value = data['id'] as String;
    return DogWithFavoriteToyFragData(
      breed: breed$value,

      favoriteToy: favoriteToy$value,

      id: id$value,
    );
  }

  static DogWithFavoriteToyFragData fromShalomValue(
    shalom_core.ShalomJsonValue data,
  ) {
    final shalom_core.ShalomJsonValue? breed$raw = data.field('breed');
    final String breed$value = breed$raw!.stringValue;
    final shalom_core.ShalomJsonValue? favoriteToy$raw = data.field(
      'favoriteToy',
    );
    final HasFavoriteToyFrag_favoriteToy favoriteToy$value =
        HasFavoriteToyFrag_favoriteToy.fromShalomValue(favoriteToy$raw!);
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final String id$value = id$raw!.stringValue;
    return DogWithFavoriteToyFragData(
      breed: breed$value,
      favoriteToy: favoriteToy$value,
      id: id$value,
    );
  }

  shalom_core.JsonObject toJson() {
    return {
      'breed': this.breed,

      'favoriteToy': this.favoriteToy.toJson(),

      'id': this.id,
    };
  }

  @override
  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'breed': shalom_core.shalomJsonValue(this.breed!),

    'favoriteToy': this.favoriteToy!.toShalomValue(),

    'id': shalom_core.shalomJsonValue(this.id!),
  });
}

abstract class $DogWithFavoriteToyFrag extends StatelessWidget {
  final DogWithFavoriteToyFragRef ref;
  const $DogWithFavoriteToyFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, DogWithFavoriteToyFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return DogWithFavoriteToyFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class DogWithFavoriteToyFragScope extends StatelessWidget {
  final DogWithFavoriteToyFragRef ref;
  final ShalomDataWidgetBuilder<DogWithFavoriteToyFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const DogWithFavoriteToyFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<DogWithFavoriteToyFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
