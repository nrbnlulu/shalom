// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: CommonAnimalFrag

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

import 'dart:async' show Stream;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart';

// ------------ fragment widget API -------------

extension type CommonAnimalFragRef.fromInput(
  shalom_core.ObservedRefInput _inner
) {
  static const String fragmentName = 'CommonAnimalFrag';

  static CommonAnimalFragRef fromEntityKey(String entityKey) {
    return CommonAnimalFragRef.fromInput(
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
  /// [CommonAnimalFragData]. Returns `null` when absent or incomplete.
  CommonAnimalFragData? readFrom(shalom_core.CacheProxy cache) {
    return cache.readFragment<CommonAnimalFragData>(
      fragmentName: fragmentName,
      entityKey: anchor,
      decoder: CommonAnimalFragData.fromCache,
    );
  }

  Stream<shalom_core.GraphQLResponse<CommonAnimalFragData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) {
    return client.subscribeToFragment<CommonAnimalFragData>(
      ref: _inner,
      decoder: CommonAnimalFragData.fromCache,
    );
  }
}

abstract class CommonAnimalFrag {
  String get id;

  shalom_core.JsonObject toJson();
}

sealed class CommonAnimalFragData implements CommonAnimalFrag {
  const CommonAnimalFragData();

  String get id;

  static CommonAnimalFragData fromCache(shalom_core.JsonObject data) {
    final typename = data['__typename'] as String?;
    switch (typename) {
      case 'Cat':
        return CommonAnimalFragData$Cat.fromJson(data);
      case 'Dog':
        return CommonAnimalFragData$Dog.fromJson(data);

      default:
        return const CommonAnimalFragData$Unknown();
    }
  }
}

final class CommonAnimalFragData$Cat extends CommonAnimalFragData {
  static String G__typename = "Cat";

  /// class members

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const CommonAnimalFragData$Cat({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CommonAnimalFragData$Cat && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, CommonAnimalFragData$Cat.G__typename]);

  shalom_core.JsonObject toJson() {
    return {"__typename": CommonAnimalFragData$Cat.G__typename, 'id': this.id};
  }

  static CommonAnimalFragData$Cat fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    return CommonAnimalFragData$Cat(id: id$value);
  }
}

final class CommonAnimalFragData$Dog extends CommonAnimalFragData {
  static String G__typename = "Dog";

  /// class members

  final String id;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  const CommonAnimalFragData$Dog({required this.id});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CommonAnimalFragData$Dog && id == other.id);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, CommonAnimalFragData$Dog.G__typename]);

  shalom_core.JsonObject toJson() {
    return {"__typename": CommonAnimalFragData$Dog.G__typename, 'id': this.id};
  }

  static CommonAnimalFragData$Dog fromJson(shalom_core.JsonObject data) {
    final String id$value = data['id'] as String;
    return CommonAnimalFragData$Dog(id: id$value);
  }
}

final class CommonAnimalFragData$Unknown extends CommonAnimalFragData {
  const CommonAnimalFragData$Unknown();

  @override
  String get id => throw UnimplementedError();

  @override
  shalom_core.JsonObject toJson() => throw UnimplementedError();
}

abstract class $CommonAnimalFrag extends StatelessWidget {
  final CommonAnimalFragRef ref;
  const $CommonAnimalFrag({super.key, required this.ref});

  Widget buildData(BuildContext context, CommonAnimalFragData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  Widget build(BuildContext context) {
    return CommonAnimalFragScope(
      ref: ref,
      loadingBuilder: buildLoading,
      errorBuilder: buildError,
      builder: buildData,
    );
  }
}

class CommonAnimalFragScope extends StatelessWidget {
  final CommonAnimalFragRef ref;
  final ShalomDataWidgetBuilder<CommonAnimalFragData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const CommonAnimalFragScope({
    super.key,
    required this.ref,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ShalomDataScope<CommonAnimalFragData>(
      identity: ref.toInput,
      observe: (client) => ref.observe(client),
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      builder: builder,
    );
  }
}

// ------------ END fragment widget API -------------
