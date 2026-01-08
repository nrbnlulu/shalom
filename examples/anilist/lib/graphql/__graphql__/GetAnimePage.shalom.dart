























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../../schema.shalom.dart";





import 'package:shalom_core/shalom_core.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports
import 'MediaCard.shalom.dart';










    
































// ------------ OBJECT DEFINITIONS -------------

class GetAnimePageResponse   {
    
    static String G__typename = "query";
    
    
    /// class members
    final GetAnimePage_Page? Page;
        
    

    

    // keywordargs constructor
     GetAnimePageResponse(
        {
                 this.Page,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
             GetAnimePageVariables variables,
            ){
        final String this$normalizedID = "ROOT_QUERY";
            final this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord("ROOT_QUERY");
        final PageNormalized$Key = '''Page(page:${variables.page }, perPage:${variables.perPage })''';
            final Page$normalizedID = "${this$normalizedID}.${ PageNormalized$Key }";
        ctx.addDependantRecords(
            {
            Page$normalizedID  
            }
        );
        final Page$cached = this$NormalizedRecord[PageNormalized$Key];
            final Page$raw = data["Page"];
            if (Page$raw != null){
                
        
        if (Page$cached == null){
            ctx.addChangedRecord(Page$normalizedID);
        }

        GetAnimePage_Page.normalize$inCache(
            Page$raw as shalom_core.JsonObject,
            ctx,
            variables,
            this$cached: Page$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(Page$cached.normalizedID()): Page$cached,
            this$fieldName: PageNormalized$Key,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final Page$id = (Page$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (Page$id != null) {
            final Page$normalized = shalom_core.NormalizedObjectRecord(typename: "Page", id: Page$id);
            this$NormalizedRecord[PageNormalized$Key] = Page$normalized;
            
            if (Page$cached != null && Page$cached is shalom_core.NormalizedObjectRecord && Page$cached != Page$normalized) {
                ctx.addChangedRecord(Page$normalizedID);
            }
        } else {
            this$NormalizedRecord[PageNormalized$Key] = shalom_core.getOrCreateObject(this$NormalizedRecord, PageNormalized$Key);
        }
    
            } else if (data.containsKey("Page") && Page$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[PageNormalized$Key] = null;
                    ctx.addChangedRecord(Page$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[PageNormalized$Key] = null;
            }
        }
    static GetAnimePageResponse fromCache(shalom_core.ShalomCtx ctx, GetAnimePageVariables variables) {
    final data = ctx.getCachedRecord("ROOT_QUERY");
        final Page$cacheKey = '''Page(page:${variables.page }, perPage:${variables.perPage })''';
                final Page$raw = data[Page$cacheKey];
            final GetAnimePage_Page? Page$value = 
        Page$raw == null ? null :
        (Page$raw is  shalom_core.NormalizedObjectRecord)?
            GetAnimePage_Page.fromCached(ctx.getCachedRecord((Page$raw as shalom_core.NormalizedObjectRecord).normalizedID()), ctx, variables)
        : GetAnimePage_Page.fromCached(Page$raw, ctx, variables)
    
;
        return GetAnimePageResponse(
            
                    Page: Page$value,
                
            );
    }
    static (GetAnimePageResponse, shalom_core.CacheUpdateContext)  fromResponseImpl(shalom_core.JsonObject data, shalom_core.ShalomCtx ctx, GetAnimePageVariables variables){
            // first update the cache
            final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
            normalize$inCache(
                data,
                updateCtx,
                
    variables
    
            );
            ctx.invalidateRefs(updateCtx.changedRecords);
            return (fromCache(ctx
    , variables
    ), updateCtx);
        }

        static GetAnimePageResponse fromResponse(shalom_core.JsonObject data, {shalom_core.ShalomCtx? ctx, required GetAnimePageVariables variables}){
            // if ctx not provider we create dummy one
            return fromResponseImpl(data, ctx ?? shalom_core.ShalomCtx.withCapacity()
    , variables
    ).$1;
        }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetAnimePageResponse &&
                    
    
        
            Page == other.Page
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                Page,
        
        GetAnimePageResponse.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'Page':
            
                
    
        
            this.Page?.toJson()
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetAnimePageResponse fromJson(shalom_core.JsonObject data) {
        final GetAnimePage_Page? Page$value = 
        
            data['Page'] == null ? null :
        GetAnimePage_Page.fromJson(data['Page'] as shalom_core.JsonObject)
    
;
        return GetAnimePageResponse(
            
                    Page: Page$value,
                
            );
    }

}



    class GetAnimePage_Page   {
        
    static String G__typename = "Page";
    
    
    /// class members
    final List<GetAnimePage_Page_media?>? media;
        
    final GetAnimePage_Page_pageInfo? pageInfo;
        
    

    

    // keywordargs constructor
     GetAnimePage_Page(
        {
                 this.media,
        
        
                 this.pageInfo,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
             GetAnimePageVariables variables,
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
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "Page", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final mediaNormalized$Key = '''media(type:ANIME, sort:POPULARITY_DESC)''';
            final media$normalizedID = "${this$normalizedID}.${ mediaNormalized$Key }";
        final pageInfoNormalized$Key = "pageInfo";
            final pageInfo$normalizedID = "${this$normalizedID}.${ pageInfoNormalized$Key }";
        ctx.addDependantRecords(
            {
            media$normalizedID  ,
            pageInfo$normalizedID  
            }
        );
        final media$cached = this$NormalizedRecord[mediaNormalized$Key];
            final media$raw = data["media"];
            if (media$raw != null){
                
        
        
        final media$rawList = media$raw as List<dynamic>;
        final media$cachedList = media$cached as List<dynamic>?;

        
        if (media$cachedList == null || media$cachedList.length != media$rawList.length) {
            ctx.addChangedRecord(media$normalizedID);
        }

        final media$normalizedList = <dynamic>[];

        for (int i = 0; i < media$rawList.length; i++) {
            final item$raw = media$rawList[i];
            final item$cached = media$cachedList?.elementAtOrNull(i);
            final item$normalizedKey = "media$i";

            
            
            if (item$raw != null) {
                
                
        
        if (item$cached == null){
            ctx.addChangedRecord(media$normalizedID);
        }

        GetAnimePage_Page_media.normalize$inCache(
            item$raw as shalom_core.JsonObject,
            ctx,
            variables,
            this$cached: item$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(item$cached.normalizedID()): item$cached,
            this$fieldName: item$normalizedKey,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final media$item$id = (item$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (media$item$id != null) {
            final media$item$normalized = shalom_core.NormalizedObjectRecord(typename: "Media", id: media$item$id);
            this$NormalizedRecord[item$normalizedKey] = media$item$normalized;
            
            if (item$cached != null && item$cached is shalom_core.NormalizedObjectRecord && item$cached != media$item$normalized) {
                ctx.addChangedRecord(media$normalizedID);
            }
        } else {
            this$NormalizedRecord[item$normalizedKey] = shalom_core.getOrCreateObject(this$NormalizedRecord, item$normalizedKey);
        }
    
            } else {
                
                if (item$cached != null) {
                    ctx.addChangedRecord(media$normalizedID);
                }
                this$NormalizedRecord[item$normalizedKey] = null;
            }
            

            
            
                
                media$normalizedList.add(this$NormalizedRecord[item$normalizedKey]);
            
        }

        this$NormalizedRecord[mediaNormalized$Key] = media$normalizedList;
    
            } else if (data.containsKey("media") && media$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[mediaNormalized$Key] = null;
                    ctx.addChangedRecord(media$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[mediaNormalized$Key] = null;
            }
        final pageInfo$cached = this$NormalizedRecord[pageInfoNormalized$Key];
            final pageInfo$raw = data["pageInfo"];
            if (pageInfo$raw != null){
                
        
        if (pageInfo$cached == null){
            ctx.addChangedRecord(pageInfo$normalizedID);
        }

        GetAnimePage_Page_pageInfo.normalize$inCache(
            pageInfo$raw as shalom_core.JsonObject,
            ctx,
            variables,
            this$cached: pageInfo$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(pageInfo$cached.normalizedID()): pageInfo$cached,
            this$fieldName: pageInfoNormalized$Key,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final pageInfo$id = (pageInfo$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (pageInfo$id != null) {
            final pageInfo$normalized = shalom_core.NormalizedObjectRecord(typename: "PageInfo", id: pageInfo$id);
            this$NormalizedRecord[pageInfoNormalized$Key] = pageInfo$normalized;
            
            if (pageInfo$cached != null && pageInfo$cached is shalom_core.NormalizedObjectRecord && pageInfo$cached != pageInfo$normalized) {
                ctx.addChangedRecord(pageInfo$normalizedID);
            }
        } else {
            this$NormalizedRecord[pageInfoNormalized$Key] = shalom_core.getOrCreateObject(this$NormalizedRecord, pageInfoNormalized$Key);
        }
    
            } else if (data.containsKey("pageInfo") && pageInfo$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[pageInfoNormalized$Key] = null;
                    ctx.addChangedRecord(pageInfo$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[pageInfoNormalized$Key] = null;
            }
        }
    static GetAnimePage_Page fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx, GetAnimePageVariables variables) {
    final media$cacheKey = '''media(type:ANIME, sort:POPULARITY_DESC)''';
                final media$raw = data[media$cacheKey];
            final List<GetAnimePage_Page_media?>? media$value = 
        
        
        media$raw == null ? null :
        (media$raw as List<dynamic>).map((e) => 
        e == null ? null :
        (e is  shalom_core.NormalizedObjectRecord)?
            GetAnimePage_Page_media.fromCached(ctx.getCachedRecord((e as shalom_core.NormalizedObjectRecord).normalizedID()), ctx, variables)
        : GetAnimePage_Page_media.fromCached(e, ctx, variables)
    
).toList()
    
;
        final pageInfo$raw = data["pageInfo"];
            final GetAnimePage_Page_pageInfo? pageInfo$value = 
        pageInfo$raw == null ? null :
        (pageInfo$raw is  shalom_core.NormalizedObjectRecord)?
            GetAnimePage_Page_pageInfo.fromCached(ctx.getCachedRecord((pageInfo$raw as shalom_core.NormalizedObjectRecord).normalizedID()), ctx, variables)
        : GetAnimePage_Page_pageInfo.fromCached(pageInfo$raw, ctx, variables)
    
;
        return GetAnimePage_Page(
            
                    media: media$value,
                
            
                    pageInfo: pageInfo$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetAnimePage_Page &&
                    
    
        const ListEquality().equals(media, other.media)
    
 &&
                    
    
        
            pageInfo == other.pageInfo
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                media,
        
                pageInfo,
        
        GetAnimePage_Page.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'media':
            
                
    
        
        
            this.media?.map((e) => 
    
        
            e?.toJson()
        
    
).toList()
        
    

            
        ,
        
    
        
        
        'pageInfo':
            
                
    
        
            this.pageInfo?.toJson()
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetAnimePage_Page fromJson(shalom_core.JsonObject data) {
        final List<GetAnimePage_Page_media?>? media$value = 
        
        
        data['media'] == null ? null :
        (data['media'] as List<dynamic>).map((e) => 
        
            e == null ? null :
        GetAnimePage_Page_media.fromJson(e as shalom_core.JsonObject)
    
).toList()
    
;
        final GetAnimePage_Page_pageInfo? pageInfo$value = 
        
            data['pageInfo'] == null ? null :
        GetAnimePage_Page_pageInfo.fromJson(data['pageInfo'] as shalom_core.JsonObject)
    
;
        return GetAnimePage_Page(
            
                    media: media$value,
                
            
                    pageInfo: pageInfo$value,
                
            );
    }

    }


    class GetAnimePage_Page_media  implements

    MediaCard
    
  {
        
    static String G__typename = "Media";
    
    
    /// class members
    final MediaCard_coverImage? coverImage;
        
    final int id;
        
    final MediaCard_title? title;
        
    final int? episodes;
        
    final MediaFormat? format;
        
    

    

    // keywordargs constructor
     GetAnimePage_Page_media(
        {
                 this.coverImage,
        
        
                required this.id,
        
        
                 this.title,
        
        
                 this.episodes,
        
        
                 this.format,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
             GetAnimePageVariables variables,
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
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "Media", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final coverImageNormalized$Key = "coverImage";
            final coverImage$normalizedID = "${this$normalizedID}.${ coverImageNormalized$Key }";
        final idNormalized$Key = "id";
            final id$normalizedID = "${this$normalizedID}.${ idNormalized$Key }";
        final titleNormalized$Key = "title";
            final title$normalizedID = "${this$normalizedID}.${ titleNormalized$Key }";
        final episodesNormalized$Key = "episodes";
            final episodes$normalizedID = "${this$normalizedID}.${ episodesNormalized$Key }";
        final formatNormalized$Key = "format";
            final format$normalizedID = "${this$normalizedID}.${ formatNormalized$Key }";
        ctx.addDependantRecords(
            {
            coverImage$normalizedID  ,
            id$normalizedID  ,
            title$normalizedID  ,
            episodes$normalizedID  ,
            format$normalizedID  
            }
        );
        final coverImage$cached = this$NormalizedRecord[coverImageNormalized$Key];
            final coverImage$raw = data["coverImage"];
            if (coverImage$raw != null){
                
        
        if (coverImage$cached == null){
            ctx.addChangedRecord(coverImage$normalizedID);
        }

        MediaCard_coverImage.normalize$inCache(
            coverImage$raw as shalom_core.JsonObject,
            ctx,
            
            this$cached: coverImage$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(coverImage$cached.normalizedID()): coverImage$cached,
            this$fieldName: coverImageNormalized$Key,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final coverImage$id = (coverImage$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (coverImage$id != null) {
            final coverImage$normalized = shalom_core.NormalizedObjectRecord(typename: "MediaCoverImage", id: coverImage$id);
            this$NormalizedRecord[coverImageNormalized$Key] = coverImage$normalized;
            
            if (coverImage$cached != null && coverImage$cached is shalom_core.NormalizedObjectRecord && coverImage$cached != coverImage$normalized) {
                ctx.addChangedRecord(coverImage$normalizedID);
            }
        } else {
            this$NormalizedRecord[coverImageNormalized$Key] = shalom_core.getOrCreateObject(this$NormalizedRecord, coverImageNormalized$Key);
        }
    
            } else if (data.containsKey("coverImage") && coverImage$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[coverImageNormalized$Key] = null;
                    ctx.addChangedRecord(coverImage$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[coverImageNormalized$Key] = null;
            }
        final id$cached = this$NormalizedRecord[idNormalized$Key];
            final id$raw = data["id"];
            if (id$raw != null){
                
        
        if (
            
    
        
            id$cached != id$raw
        
    

        ){
            ctx.addChangedRecord(id$normalizedID);
        }
        this$NormalizedRecord[idNormalized$Key] = id$raw;
    
            } else if (data.containsKey("id") && id$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[idNormalized$Key] = null;
                    ctx.addChangedRecord(id$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[idNormalized$Key] = null;
            }
        final title$cached = this$NormalizedRecord[titleNormalized$Key];
            final title$raw = data["title"];
            if (title$raw != null){
                
        
        if (title$cached == null){
            ctx.addChangedRecord(title$normalizedID);
        }

        MediaCard_title.normalize$inCache(
            title$raw as shalom_core.JsonObject,
            ctx,
            
            this$cached: title$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(title$cached.normalizedID()): title$cached,
            this$fieldName: titleNormalized$Key,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final title$id = (title$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (title$id != null) {
            final title$normalized = shalom_core.NormalizedObjectRecord(typename: "MediaTitle", id: title$id);
            this$NormalizedRecord[titleNormalized$Key] = title$normalized;
            
            if (title$cached != null && title$cached is shalom_core.NormalizedObjectRecord && title$cached != title$normalized) {
                ctx.addChangedRecord(title$normalizedID);
            }
        } else {
            this$NormalizedRecord[titleNormalized$Key] = shalom_core.getOrCreateObject(this$NormalizedRecord, titleNormalized$Key);
        }
    
            } else if (data.containsKey("title") && title$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[titleNormalized$Key] = null;
                    ctx.addChangedRecord(title$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[titleNormalized$Key] = null;
            }
        final episodes$cached = this$NormalizedRecord[episodesNormalized$Key];
            final episodes$raw = data["episodes"];
            if (episodes$raw != null){
                
        
        if (
            
    
        
            episodes$cached != episodes$raw
        
    

        ){
            ctx.addChangedRecord(episodes$normalizedID);
        }
        this$NormalizedRecord[episodesNormalized$Key] = episodes$raw;
    
            } else if (data.containsKey("episodes") && episodes$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[episodesNormalized$Key] = null;
                    ctx.addChangedRecord(episodes$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[episodesNormalized$Key] = null;
            }
        final format$cached = this$NormalizedRecord[formatNormalized$Key];
            final format$raw = data["format"];
            if (format$raw != null){
                
        
        if (
            
    
        
            format$cached != format$raw
        
    

        ){
            ctx.addChangedRecord(format$normalizedID);
        }
        this$NormalizedRecord[formatNormalized$Key] = format$raw;
    
            } else if (data.containsKey("format") && format$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[formatNormalized$Key] = null;
                    ctx.addChangedRecord(format$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[formatNormalized$Key] = null;
            }
        }
    static GetAnimePage_Page_media fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx, GetAnimePageVariables variables) {
    final coverImage$raw = data["coverImage"];
            final MediaCard_coverImage? coverImage$value = 
        coverImage$raw == null ? null :
        (coverImage$raw is  shalom_core.NormalizedObjectRecord)?
            MediaCard_coverImage.fromCached(ctx.getCachedRecord((coverImage$raw as shalom_core.NormalizedObjectRecord).normalizedID()), ctx)
        : MediaCard_coverImage.fromCached(coverImage$raw, ctx)
    
;
        final id$raw = data["id"];
            final int id$value = 
        
            
                id$raw as int
            
        
    
;
        final title$raw = data["title"];
            final MediaCard_title? title$value = 
        title$raw == null ? null :
        (title$raw is  shalom_core.NormalizedObjectRecord)?
            MediaCard_title.fromCached(ctx.getCachedRecord((title$raw as shalom_core.NormalizedObjectRecord).normalizedID()), ctx)
        : MediaCard_title.fromCached(title$raw, ctx)
    
;
        final episodes$raw = data["episodes"];
            final int? episodes$value = 
        
            
                episodes$raw as int?
            
        
    
;
        final format$raw = data["format"];
            final MediaFormat? format$value = 
        
        
            format$raw == null ? null : MediaFormat.fromString(format$raw)
        
    
;
        return GetAnimePage_Page_media(
            
                    coverImage: coverImage$value,
                
            
                    id: id$value,
                
            
                    title: title$value,
                
            
                    episodes: episodes$value,
                
            
                    format: format$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetAnimePage_Page_media &&
                    
    
        
            coverImage == other.coverImage
        
    
 &&
                    
    
        
            id == other.id
        
    
 &&
                    
    
        
            title == other.title
        
    
 &&
                    
    
        
            episodes == other.episodes
        
    
 &&
                    
    
        
            format == other.format
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                coverImage,
        
                id,
        
                title,
        
                episodes,
        
                format,
        
        GetAnimePage_Page_media.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'coverImage':
            
                
    
        
            this.coverImage?.toJson()
        
    

            
        ,
        
    
        
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
        
    
        
        
        'title':
            
                
    
        
            this.title?.toJson()
        
    

            
        ,
        
    
        
        
        'episodes':
            
                
    
        
            this.episodes
        
    

            
        ,
        
    
        
        
        'format':
            
                
    
        
            this.format?.name
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetAnimePage_Page_media fromJson(shalom_core.JsonObject data) {
        final MediaCard_coverImage? coverImage$value = 
        
            data['coverImage'] == null ? null :
        MediaCard_coverImage.fromJson(data['coverImage'] as shalom_core.JsonObject)
    
;
        final int id$value = 
        
            
                data['id'] as int
            
        
    
;
        final MediaCard_title? title$value = 
        
            data['title'] == null ? null :
        MediaCard_title.fromJson(data['title'] as shalom_core.JsonObject)
    
;
        final int? episodes$value = 
        
            
                data['episodes'] as int?
            
        
    
;
        final MediaFormat? format$value = 
        
        
            data['format'] == null ? null : MediaFormat.fromString(data['format'])
        
    
;
        return GetAnimePage_Page_media(
            
                    coverImage: coverImage$value,
                
            
                    id: id$value,
                
            
                    title: title$value,
                
            
                    episodes: episodes$value,
                
            
                    format: format$value,
                
            );
    }

    }


    class GetAnimePage_Page_pageInfo   {
        
    static String G__typename = "PageInfo";
    
    
    /// class members
    final int? currentPage;
        
    final int? lastPage;
        
    final bool? hasNextPage;
        
    

    

    // keywordargs constructor
     GetAnimePage_Page_pageInfo(
        {
                 this.currentPage,
        
        
                 this.lastPage,
        
        
                 this.hasNextPage,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
             GetAnimePageVariables variables,
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
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "PageInfo", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final currentPageNormalized$Key = "currentPage";
            final currentPage$normalizedID = "${this$normalizedID}.${ currentPageNormalized$Key }";
        final lastPageNormalized$Key = "lastPage";
            final lastPage$normalizedID = "${this$normalizedID}.${ lastPageNormalized$Key }";
        final hasNextPageNormalized$Key = "hasNextPage";
            final hasNextPage$normalizedID = "${this$normalizedID}.${ hasNextPageNormalized$Key }";
        ctx.addDependantRecords(
            {
            currentPage$normalizedID  ,
            lastPage$normalizedID  ,
            hasNextPage$normalizedID  
            }
        );
        final currentPage$cached = this$NormalizedRecord[currentPageNormalized$Key];
            final currentPage$raw = data["currentPage"];
            if (currentPage$raw != null){
                
        
        if (
            
    
        
            currentPage$cached != currentPage$raw
        
    

        ){
            ctx.addChangedRecord(currentPage$normalizedID);
        }
        this$NormalizedRecord[currentPageNormalized$Key] = currentPage$raw;
    
            } else if (data.containsKey("currentPage") && currentPage$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[currentPageNormalized$Key] = null;
                    ctx.addChangedRecord(currentPage$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[currentPageNormalized$Key] = null;
            }
        final lastPage$cached = this$NormalizedRecord[lastPageNormalized$Key];
            final lastPage$raw = data["lastPage"];
            if (lastPage$raw != null){
                
        
        if (
            
    
        
            lastPage$cached != lastPage$raw
        
    

        ){
            ctx.addChangedRecord(lastPage$normalizedID);
        }
        this$NormalizedRecord[lastPageNormalized$Key] = lastPage$raw;
    
            } else if (data.containsKey("lastPage") && lastPage$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[lastPageNormalized$Key] = null;
                    ctx.addChangedRecord(lastPage$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[lastPageNormalized$Key] = null;
            }
        final hasNextPage$cached = this$NormalizedRecord[hasNextPageNormalized$Key];
            final hasNextPage$raw = data["hasNextPage"];
            if (hasNextPage$raw != null){
                
        
        if (
            
    
        
            hasNextPage$cached != hasNextPage$raw
        
    

        ){
            ctx.addChangedRecord(hasNextPage$normalizedID);
        }
        this$NormalizedRecord[hasNextPageNormalized$Key] = hasNextPage$raw;
    
            } else if (data.containsKey("hasNextPage") && hasNextPage$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[hasNextPageNormalized$Key] = null;
                    ctx.addChangedRecord(hasNextPage$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[hasNextPageNormalized$Key] = null;
            }
        }
    static GetAnimePage_Page_pageInfo fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx, GetAnimePageVariables variables) {
    final currentPage$raw = data["currentPage"];
            final int? currentPage$value = 
        
            
                currentPage$raw as int?
            
        
    
;
        final lastPage$raw = data["lastPage"];
            final int? lastPage$value = 
        
            
                lastPage$raw as int?
            
        
    
;
        final hasNextPage$raw = data["hasNextPage"];
            final bool? hasNextPage$value = 
        
            
                hasNextPage$raw as bool?
            
        
    
;
        return GetAnimePage_Page_pageInfo(
            
                    currentPage: currentPage$value,
                
            
                    lastPage: lastPage$value,
                
            
                    hasNextPage: hasNextPage$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetAnimePage_Page_pageInfo &&
                    
    
        
            currentPage == other.currentPage
        
    
 &&
                    
    
        
            lastPage == other.lastPage
        
    
 &&
                    
    
        
            hasNextPage == other.hasNextPage
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                currentPage,
        
                lastPage,
        
                hasNextPage,
        
        GetAnimePage_Page_pageInfo.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'currentPage':
            
                
    
        
            this.currentPage
        
    

            
        ,
        
    
        
        
        'lastPage':
            
                
    
        
            this.lastPage
        
    

            
        ,
        
    
        
        
        'hasNextPage':
            
                
    
        
            this.hasNextPage
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetAnimePage_Page_pageInfo fromJson(shalom_core.JsonObject data) {
        final int? currentPage$value = 
        
            
                data['currentPage'] as int?
            
        
    
;
        final int? lastPage$value = 
        
            
                data['lastPage'] as int?
            
        
    
;
        final bool? hasNextPage$value = 
        
            
                data['hasNextPage'] as bool?
            
        
    
;
        return GetAnimePage_Page_pageInfo(
            
                    currentPage: currentPage$value,
                
            
                    lastPage: lastPage$value,
                
            
                    hasNextPage: hasNextPage$value,
                
            );
    }

    }



// ------------ END OBJECT DEFINITIONS -------------


// ------------ UNION DEFINITIONS -------------




// ------------ END UNION DEFINITIONS -------------

// ------------ INTERFACE DEFINITIONS -------------



// ------------ END INTERFACE DEFINITIONS -------------

// ------------ MULTI-TYPE LIST EXTENSIONS -------------

// ------------ END MULTI-TYPE LIST EXTENSIONS -------------


class RequestGetAnimePage extends shalom_core.Requestable<GetAnimePageResponse>{
    
    final GetAnimePageVariables variables;
    

    RequestGetAnimePage(
        
        {
            required this.variables,
        }
        
    );
    @override
    shalom_core.RequestMeta<GetAnimePageResponse> getRequestMeta(){
        shalom_core.JsonObject variablesJson =  variables.toJson() ;
        final request = shalom_core.Request(
            query: r"""
            query GetAnimePage($page: Int!, $perPage: Int!) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      currentPage
      hasNextPage
      lastPage
    }
    media(type: ANIME, sort: POPULARITY_DESC) {
      ...MediaCard
      id
    }
  }
}
 fragment MediaCard on Media {
  id
  title {
    romaji
    english
  }
  coverImage {
    large
  }
  episodes
  format
}
            """,
            variables: variablesJson,
            opType: shalom_core.OperationType.Query,
            opName: 'GetAnimePage',
        );
        return shalom_core.RequestMeta(
            request: request,
            loadFn: ({required shalom_core.JsonObject data, required shalom_core.ShalomCtx ctx}){
                final (deserialized, updatedCtx) = GetAnimePageResponse.fromResponseImpl(data, ctx, variables);
                return (deserialized, updatedCtx.dependantRecords);
            },
            fromCacheFn: (shalom_core.ShalomCtx ctx){
                final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
                final deserialized = GetAnimePageResponse.fromCache(ctx, variables);
                return (deserialized, updateCtx.dependantRecords);
            }
        );
    }
}


class GetAnimePageVariables {
    
    
    
        final int page;
    
        final int perPage;
    

    GetAnimePageVariables(
        {
        
    
        required this.page
            
    
,
            
    
        required this.perPage
            
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
data["page"] = 
    
        this.page
    
;
    data["perPage"] = 
    
        this.perPage
    
;
    
        return data;
    }

    

GetAnimePageVariables updateWith(
    {
        int? page
            ,
        int? perPage
            
        }
) {
    
        
            final page$next = page ?? this.page;
        
        
            final perPage$next = perPage ?? this.perPage;
        
    return GetAnimePageVariables(
        
            page:page$next,
        
            perPage:perPage$next
        );
}


}
