// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: HasFavoriteToyFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'ToyFrag.shalom.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type HasFavoriteToyFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'HasFavoriteToyFrag';

  static HasFavoriteToyFragRef fromEntityKey(String entityKey) {
    return HasFavoriteToyFragRef.fromInput(
      shalom_core.ObservedRefInput(
        observableId: fragmentName,
        anchor: entityKey,
      ),
    );
  }

  shalom_core.ObservedRefInput get toInput => _inner;
  String get anchor => _inner.anchor;
  shalom_core.JsonObject toJson() => {
    '__shalom_observed_ref': {
      'observable_id': _inner.observableId,
      'anchor': _inner.anchor,
    },
  };

  /// Reads the entity this ref points to through [cache], decoding it as
  /// [HasFavoriteToyFragData]. Returns `null` when absent or incomplete.
  Future<HasFavoriteToyFragData?> readFrom(shalom_core.CacheProxy cache) async {
    return await cache.readFragment<HasFavoriteToyFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: HasFavoriteToyFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<HasFavoriteToyFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<HasFavoriteToyFragData>(
      ref: _inner,
      decoder: HasFavoriteToyFragData.fromCache,
    );
  }
}

abstract class HasFavoriteToyFrag {
  HasFavoriteToyFrag_favoriteToy get favoriteToy;

  shalom_core.JsonObject toJson();
}

sealed class HasFavoriteToyFragData implements HasFavoriteToyFrag {
  const HasFavoriteToyFragData();

  HasFavoriteToyFrag_favoriteToy get favoriteToy;

  static HasFavoriteToyFragData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Dog':
        return HasFavoriteToyFragData$Dog.fromJson(data);

      default:
        return const HasFavoriteToyFragData$Unknown();
    }
  }
}

final class HasFavoriteToyFragData$Dog extends HasFavoriteToyFragData {
  static String G__typename = "Dog";

  /// class members

  final HasFavoriteToyFrag_favoriteToy favoriteToy;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const HasFavoriteToyFragData$Dog({required this.favoriteToy});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HasFavoriteToyFragData$Dog &&
            favoriteToy == other.favoriteToy);
  }

  @override
  int get hashCode =>
      Object.hashAll([favoriteToy, HasFavoriteToyFragData$Dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      "__typename": HasFavoriteToyFragData$Dog.G__typename,

      'favoriteToy': this.favoriteToy.toJson(),
    };
  }

  static HasFavoriteToyFragData$Dog fromJson(shalom_core.JsonObject data) {
    final HasFavoriteToyFrag_favoriteToy favoriteToy$value =
        HasFavoriteToyFrag_favoriteToy.fromJson(
          data['favoriteToy'] as shalom_core.JsonObject,
        );
    return HasFavoriteToyFragData$Dog(favoriteToy: favoriteToy$value);
  }
}

final class HasFavoriteToyFragData$Unknown extends HasFavoriteToyFragData {
  const HasFavoriteToyFragData$Unknown();

  @override
  HasFavoriteToyFrag_favoriteToy get favoriteToy => throw UnimplementedError();

  @override
  shalom_core.JsonObject toJson() => throw UnimplementedError();
}

class HasFavoriteToyFrag_favoriteToy {
  static String G__typename = "Toy";

  /// class members
  final String id;

  final String label;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  HasFavoriteToyFrag_favoriteToy({required this.id, required this.label});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HasFavoriteToyFrag_favoriteToy &&
            id == other.id &&
            label == other.label);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, label, HasFavoriteToyFrag_favoriteToy.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'id': this.id, 'label': this.label};
  }

  static HasFavoriteToyFrag_favoriteToy fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    final String label$value = data['label'] as String;
    return HasFavoriteToyFrag_favoriteToy(id: id$value, label: label$value);
  }
}

abstract class $HasFavoriteToyFrag extends StatelessWidget {
  final HasFavoriteToyFragRef ref;
  const $HasFavoriteToyFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, HasFavoriteToyFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return HasFavoriteToyFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class HasFavoriteToyFragScope extends StatelessWidget {
  final HasFavoriteToyFragRef ref;
  final ShalomDataWidgetBuilder<HasFavoriteToyFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const HasFavoriteToyFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<HasFavoriteToyFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
