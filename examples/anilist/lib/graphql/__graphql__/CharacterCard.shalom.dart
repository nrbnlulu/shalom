// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: CharacterCard

import "../../schema.shalom.dart";
import 'package:shalom_core/shalom_core.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Generate abstract fragment class
abstract class CharacterCard {
  int get id;
  CharacterCard_name? get name;
  CharacterCard_image? get image;

  Map<String, dynamic> toJson();
}

// ------------ START OBJECT DEFINITIONS -------------
class CharacterCard_image {
  static String G__typename = "CharacterImage";

  /// class members
  final String? large;

  // keywordargs constructor
  CharacterCard_image({this.large});

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "CharacterImage",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final largeNormalized$Key = "large";
    final large$normalizedID = "${this$normalizedID}.${largeNormalized$Key}";
    ctx.addDependantRecords({large$normalizedID});
    final large$cached = this$NormalizedRecord[largeNormalized$Key];
    final large$raw = data["large"];
    if (large$raw != null) {
      if (large$cached != large$raw) {
        ctx.addChangedRecord(large$normalizedID);
      }
      this$NormalizedRecord[largeNormalized$Key] = large$raw;
    } else if (data.containsKey("large") && large$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[largeNormalized$Key] = null;
      ctx.addChangedRecord(large$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[largeNormalized$Key] = null;
    }
  }

  static CharacterCard_image fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
  ) {
    final large$raw = data["large"];
    final String? large$value = large$raw as String?;
    return CharacterCard_image(large: large$value);
  }

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

  @experimental
  static CharacterCard_image fromJson(shalom_core.JsonObject data) {
    final String? large$value = data['large'] as String?;
    return CharacterCard_image(large: large$value);
  }
}

class CharacterCard_name {
  static String G__typename = "CharacterName";

  /// class members
  final String? full;

  // keywordargs constructor
  CharacterCard_name({this.full});

  static void normalize$inCache(
    shalom_core.JsonObject data,
    shalom_core.CacheUpdateContext ctx, {

    /// can be just the selection name but also may include serialized arguments.
    required shalom_core.RecordID this$fieldName,
    required shalom_core.JsonObject? this$cached,
    required shalom_core.JsonObject parent$record,
    required shalom_core.RecordID parent$normalizedID,
  }) {
    String this$normalizedID;
    shalom_core.JsonObject this$NormalizedRecord;

    final shalom_core.RecordID? this$normalizedID_temp =
        data["id"] as shalom_core.RecordID?;
    if (this$normalizedID_temp == null) {
      this$normalizedID = "${parent$normalizedID}.${this$fieldName}";

      this$NormalizedRecord = shalom_core.getOrCreateObject(
        parent$record,
        this$fieldName,
      );
    } else {
      final normalized$objRecord = shalom_core.NormalizedObjectRecord(
        typename: "CharacterName",
        id: this$normalizedID_temp!,
      );
      if (this$cached != null &&
          this$cached is shalom_core.NormalizedObjectRecord &&
          this$cached as shalom_core.NormalizedObjectRecord !=
              normalized$objRecord) {
        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
      }
      parent$record[this$fieldName] = normalized$objRecord;
      this$normalizedID = normalized$objRecord.normalizedID();
      this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(
        this$normalizedID,
      );
      ctx.addDependantRecord(this$normalizedID);
    }
    final fullNormalized$Key = "full";
    final full$normalizedID = "${this$normalizedID}.${fullNormalized$Key}";
    ctx.addDependantRecords({full$normalizedID});
    final full$cached = this$NormalizedRecord[fullNormalized$Key];
    final full$raw = data["full"];
    if (full$raw != null) {
      if (full$cached != full$raw) {
        ctx.addChangedRecord(full$normalizedID);
      }
      this$NormalizedRecord[fullNormalized$Key] = full$raw;
    } else if (data.containsKey("full") && full$cached != null) {
      // if this field was null in the response and key exists clear the cache.

      this$NormalizedRecord[fullNormalized$Key] = null;
      ctx.addChangedRecord(full$normalizedID);
    } else {
      // data is null and cache is null, do nothing.
      this$NormalizedRecord[fullNormalized$Key] = null;
    }
  }

  static CharacterCard_name fromCached(
    shalom_core.NormalizedRecordData data,
    shalom_core.ShalomCtx ctx,
  ) {
    final full$raw = data["full"];
    final String? full$value = full$raw as String?;
    return CharacterCard_name(full: full$value);
  }

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

  @experimental
  static CharacterCard_name fromJson(shalom_core.JsonObject data) {
    final String? full$value = data['full'] as String?;
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
