// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: CharacterCard

import "../../schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';

// Generate abstract fragment class
abstract class CharacterCard {
  int get id;
  CharacterCard_image? get image;
  CharacterCard_name? get name;

  Map<String, dynamic> toJson();
  shalom_core.ShalomJsonValue toShalomValue();
}

class CharacterCardImpl implements CharacterCard {
  static String G__typename = "Character";

  /// class members
  final int id;

  final CharacterCard_image? image;

  final CharacterCard_name? name;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  CharacterCardImpl({required this.id, this.image, this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CharacterCardImpl &&
            id == other.id &&
            image == other.image &&
            name == other.name);
  }

  @override
  int get hashCode =>
      Object.hashAll([id, image, name, CharacterCardImpl.G__typename]);

  shalom_core.JsonObject toJson() {
    return {
      'id': this.id,

      'image': this.image?.toJson(),

      'name': this.name?.toJson(),
    };
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'id': shalom_core.shalomJsonValue(this.id!),

    'image': this.image == null
        ? shalom_core.shalomJsonValue(null)
        : this.image!.toShalomValue(),

    'name': this.name == null
        ? shalom_core.shalomJsonValue(null)
        : this.name!.toShalomValue(),
  });

  static CharacterCardImpl fromJson(shalom_core.JsonObject data) {
    final int id$value = data['id'] as int;
    final CharacterCard_image? image$value = data['image'] == null
        ? null
        : CharacterCard_image.fromJson(data['image'] as shalom_core.JsonObject);
    final CharacterCard_name? name$value = data['name'] == null
        ? null
        : CharacterCard_name.fromJson(data['name'] as shalom_core.JsonObject);
    return CharacterCardImpl(
      id: id$value,

      image: image$value,

      name: name$value,
    );
  }

  static CharacterCardImpl fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? id$raw = data.field('id');
    final int id$value = id$raw!.intValue;
    final shalom_core.ShalomJsonValue? image$raw = data.field('image');
    final CharacterCard_image? image$value =
        image$raw == null || image$raw!.isNull
        ? null
        : CharacterCard_image.fromShalomValue(image$raw!);
    final shalom_core.ShalomJsonValue? name$raw = data.field('name');
    final CharacterCard_name? name$value = name$raw == null || name$raw!.isNull
        ? null
        : CharacterCard_name.fromShalomValue(name$raw!);
    return CharacterCardImpl(
      id: id$value,
      image: image$value,
      name: name$value,
    );
  }
}

// ------------ START OBJECT DEFINITIONS -------------
class CharacterCard_image {
  static String G__typename = "CharacterImage";

  /// class members
  final String? large;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  CharacterCard_image({this.large});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CharacterCard_image && large == other.large);
  }

  @override
  int get hashCode => Object.hashAll([large, CharacterCard_image.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'large': this.large};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'large': this.large == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.large!),
  });

  static CharacterCard_image fromJson(shalom_core.JsonObject data) {
    final String? large$value = data['large'] as String?;
    return CharacterCard_image(large: large$value);
  }

  static CharacterCard_image fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? large$raw = data.field('large');
    final String? large$value = large$raw == null || large$raw!.isNull
        ? null
        : large$raw!.stringValue;
    return CharacterCard_image(large: large$value);
  }
}

class CharacterCard_name {
  static String G__typename = "CharacterName";

  /// class members
  final String? full;

  // Getter for typename (public accessor for static __typename field)
  String get $__typename => G__typename;

  // keywordargs constructor
  CharacterCard_name({this.full});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CharacterCard_name && full == other.full);
  }

  @override
  int get hashCode => Object.hashAll([full, CharacterCard_name.G__typename]);

  shalom_core.JsonObject toJson() {
    return {'full': this.full};
  }

  shalom_core.ShalomJsonValue toShalomValue() => shalom_core.shalomJsonObject({
    'full': this.full == null
        ? shalom_core.shalomJsonValue(null)
        : shalom_core.shalomJsonValue(this.full!),
  });

  static CharacterCard_name fromJson(shalom_core.JsonObject data) {
    final String? full$value = data['full'] as String?;
    return CharacterCard_name(full: full$value);
  }

  static CharacterCard_name fromShalomValue(shalom_core.ShalomJsonValue data) {
    final shalom_core.ShalomJsonValue? full$raw = data.field('full');
    final String? full$value = full$raw == null || full$raw!.isNull
        ? null
        : full$raw!.stringValue;
    return CharacterCard_name(full: full$value);
  }
}

// ------------ END OBJECT DEFINITIONS -------------

// ------------ START UNION DEFINITIONS -------------

// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------

// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------
