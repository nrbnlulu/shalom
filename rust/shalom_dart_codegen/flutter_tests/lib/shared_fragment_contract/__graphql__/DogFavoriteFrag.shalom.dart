// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: DogFavoriteFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'ToyFrag.shalom.dart';
import 'HasFavoriteToyFrag.shalom.dart';
import 'CommonAnimalFrag.shalom.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type DogFavoriteFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'DogFavoriteFrag';

  static DogFavoriteFragRef fromEntityKey(String entityKey) {
    return DogFavoriteFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  static DogFavoriteFragRef fromId(String id) =>
      fromEntityKey(DogFavoriteFragData.entityKey(id));

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [DogFavoriteFragData]. Returns `null` when absent or incomplete.
  DogFavoriteFragData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<DogFavoriteFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: DogFavoriteFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<DogFavoriteFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<DogFavoriteFragData>(
      ref: _inner,
      decoder: DogFavoriteFragData.fromCache,
    );
  }
}

abstract class DogFavoriteFrag implements CommonAnimalFrag, HasFavoriteToyFrag {
  String get breed;
  HasFavoriteToyFrag_favoriteToy get favoriteToy;
  String get id;

  shalom_core.JsonObject toJson();
}

final class DogFavoriteFragData
    implements DogFavoriteFrag, shalom_core.FragmentInterface {
  final String breed;
  final HasFavoriteToyFrag_favoriteToy favoriteToy;
  final String id;

  const DogFavoriteFragData({
    required this.breed,
    required this.favoriteToy,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DogFavoriteFragData &&
          breed == other.breed &&
          favoriteToy == other.favoriteToy &&
          id == other.id);

  @override
  int get hashCode => Object.hashAll([breed, favoriteToy, id]);

  @override
  String fragment$Name() => 'DogFavoriteFrag';

  @override
  String entity$Type() => 'Dog';

  @override
  String entity$Id() => this.id;

  /// The normalized cache key for the entity identified by [id], e.g.
  /// `'Dog:123'`.
  static String entityKey(String id) => 'Dog:$id';

  static DogFavoriteFragData fromCache(shalom_core.JsonObject data) {
    final String breed$value = data['breed'] as String;
    final HasFavoriteToyFrag_favoriteToy favoriteToy$value =
        HasFavoriteToyFrag_favoriteToy.fromJson(
          data['favoriteToy'] as shalom_core.JsonObject,
        );
    final String id$value = data['id'] as String;
    return DogFavoriteFragData(
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
}

abstract class $DogFavoriteFrag extends StatelessWidget {
  final DogFavoriteFragRef ref;
  const $DogFavoriteFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, DogFavoriteFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return DogFavoriteFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class DogFavoriteFragScope extends StatelessWidget {
  final DogFavoriteFragRef ref;
  final ShalomDataWidgetBuilder<DogFavoriteFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const DogFavoriteFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<DogFavoriteFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
