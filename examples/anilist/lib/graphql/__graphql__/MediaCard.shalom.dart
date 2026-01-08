































    
































// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: MediaCard

import "../../schema.shalom.dart";
import 'package:shalom_core/shalom_core.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;






// Generate abstract fragment class
abstract class MediaCard {
    MediaCard_title? get title;
    int? get episodes;
    MediaCard_coverImage? get coverImage;
    MediaFormat? get format;
    int get id;
    

  Map<String, dynamic> toJson();

}

// ------------ START OBJECT DEFINITIONS -------------
class MediaCard_coverImage   {
        
    static String G__typename = "MediaCoverImage";
    
    
    /// class members
    final String? large;
        
    

    

    // keywordargs constructor
     MediaCard_coverImage(
        {
                 this.large,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
            
            {
                /// can be just the selection name but also may include serialized arguments.
                required shalom_core.RecordID  this$fieldName,
                required shalom_core.JsonObject? this$cached,
                required shalom_core.JsonObject parent$record,
                required shalom_core.RecordID parent$normalizedID
                }
            ){
        
            String this$normalizedID;
            shalom_core.JsonObject this$NormalizedRecord;
            
            final shalom_core.RecordID? this$normalizedID_temp = data["id"] as shalom_core.RecordID?;
            if (this$normalizedID_temp == null) {
                this$normalizedID = "${parent$normalizedID}.${this$fieldName}";
                
                    this$NormalizedRecord = shalom_core.getOrCreateObject(parent$record, this$fieldName);
                
            } else {
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "MediaCoverImage", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final largeNormalized$Key = "large";
            final large$normalizedID = "${this$normalizedID}.${ largeNormalized$Key }";
        ctx.addDependantRecords(
            {
            large$normalizedID  
            }
        );
        final large$cached = this$NormalizedRecord[largeNormalized$Key];
            final large$raw = data["large"];
            if (large$raw != null){
                
        
        if (
            
    
        
            large$cached != large$raw
        
    

        ){
            ctx.addChangedRecord(large$normalizedID);
        }
        this$NormalizedRecord[largeNormalized$Key] = large$raw;
    
            } else if (data.containsKey("large") && large$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[largeNormalized$Key] = null;
                    ctx.addChangedRecord(large$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[largeNormalized$Key] = null;
            }
        }
    static MediaCard_coverImage fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx) {
    final large$raw = data["large"];
            final String? large$value = 
        
            
                large$raw as String?
            
        
    
;
        return MediaCard_coverImage(
            
                    large: large$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is MediaCard_coverImage &&
                    
    
        
            large == other.large
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                large,
        
        MediaCard_coverImage.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'large':
            
                
    
        
            this.large
        
    

            
        ,
        
    
    };
    }

    @experimental
    static MediaCard_coverImage fromJson(shalom_core.JsonObject data) {
        final String? large$value = 
        
            
                data['large'] as String?
            
        
    
;
        return MediaCard_coverImage(
            
                    large: large$value,
                
            );
    }

    }

class MediaCard_title   {
        
    static String G__typename = "MediaTitle";
    
    
    /// class members
    final String? romaji;
        
    final String? english;
        
    

    

    // keywordargs constructor
     MediaCard_title(
        {
                 this.romaji,
        
        
                 this.english,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
            
            {
                /// can be just the selection name but also may include serialized arguments.
                required shalom_core.RecordID  this$fieldName,
                required shalom_core.JsonObject? this$cached,
                required shalom_core.JsonObject parent$record,
                required shalom_core.RecordID parent$normalizedID
                }
            ){
        
            String this$normalizedID;
            shalom_core.JsonObject this$NormalizedRecord;
            
            final shalom_core.RecordID? this$normalizedID_temp = data["id"] as shalom_core.RecordID?;
            if (this$normalizedID_temp == null) {
                this$normalizedID = "${parent$normalizedID}.${this$fieldName}";
                
                    this$NormalizedRecord = shalom_core.getOrCreateObject(parent$record, this$fieldName);
                
            } else {
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "MediaTitle", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final romajiNormalized$Key = "romaji";
            final romaji$normalizedID = "${this$normalizedID}.${ romajiNormalized$Key }";
        final englishNormalized$Key = "english";
            final english$normalizedID = "${this$normalizedID}.${ englishNormalized$Key }";
        ctx.addDependantRecords(
            {
            romaji$normalizedID  ,
            english$normalizedID  
            }
        );
        final romaji$cached = this$NormalizedRecord[romajiNormalized$Key];
            final romaji$raw = data["romaji"];
            if (romaji$raw != null){
                
        
        if (
            
    
        
            romaji$cached != romaji$raw
        
    

        ){
            ctx.addChangedRecord(romaji$normalizedID);
        }
        this$NormalizedRecord[romajiNormalized$Key] = romaji$raw;
    
            } else if (data.containsKey("romaji") && romaji$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[romajiNormalized$Key] = null;
                    ctx.addChangedRecord(romaji$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[romajiNormalized$Key] = null;
            }
        final english$cached = this$NormalizedRecord[englishNormalized$Key];
            final english$raw = data["english"];
            if (english$raw != null){
                
        
        if (
            
    
        
            english$cached != english$raw
        
    

        ){
            ctx.addChangedRecord(english$normalizedID);
        }
        this$NormalizedRecord[englishNormalized$Key] = english$raw;
    
            } else if (data.containsKey("english") && english$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[englishNormalized$Key] = null;
                    ctx.addChangedRecord(english$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[englishNormalized$Key] = null;
            }
        }
    static MediaCard_title fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx) {
    final romaji$raw = data["romaji"];
            final String? romaji$value = 
        
            
                romaji$raw as String?
            
        
    
;
        final english$raw = data["english"];
            final String? english$value = 
        
            
                english$raw as String?
            
        
    
;
        return MediaCard_title(
            
                    romaji: romaji$value,
                
            
                    english: english$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is MediaCard_title &&
                    
    
        
            romaji == other.romaji
        
    
 &&
                    
    
        
            english == other.english
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                romaji,
        
                english,
        
        MediaCard_title.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'romaji':
            
                
    
        
            this.romaji
        
    

            
        ,
        
    
        
        
        'english':
            
                
    
        
            this.english
        
    

            
        ,
        
    
    };
    }

    @experimental
    static MediaCard_title fromJson(shalom_core.JsonObject data) {
        final String? romaji$value = 
        
            
                data['romaji'] as String?
            
        
    
;
        final String? english$value = 
        
            
                data['english'] as String?
            
        
    
;
        return MediaCard_title(
            
                    romaji: romaji$value,
                
            
                    english: english$value,
                
            );
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


// ------------ START UNION DEFINITIONS -------------



// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------



// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------
