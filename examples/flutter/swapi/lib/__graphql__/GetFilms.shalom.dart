























// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

import "../schema.shalom.dart";





import 'package:shalom_core/shalom_core.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;

// Fragment imports










    
































// ------------ OBJECT DEFINITIONS -------------

class GetFilmsResponse   {
    
    static String G__typename = "query";
    
    
    /// class members
    final GetFilms_allFilms? allFilms;
        
    

    

    // keywordargs constructor
     GetFilmsResponse(
        {
                 this.allFilms,
        }
        
    );

    static void normalize$inCache(shalom_core.JsonObject data,
            shalom_core.CacheUpdateContext ctx,
            
            ){
        final String this$normalizedID = "ROOT_QUERY";
            final this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord("ROOT_QUERY");
        final allFilmsNormalized$Key = "allFilms";
            final allFilms$normalizedID = "${this$normalizedID}.${ allFilmsNormalized$Key }";
        ctx.addDependantRecords(
            {
            allFilms$normalizedID  
            }
        );
        final allFilms$cached = this$NormalizedRecord[allFilmsNormalized$Key];
            final allFilms$raw = data["allFilms"];
            if (allFilms$raw != null){
                
        
        if (allFilms$cached == null){
            ctx.addChangedRecord(allFilms$normalizedID);
        }

        GetFilms_allFilms.normalize$inCache(
            allFilms$raw as shalom_core.JsonObject,
            ctx,
            
            this$cached: allFilms$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(allFilms$cached.normalizedID()): allFilms$cached,
            this$fieldName: allFilmsNormalized$Key,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final allFilms$id = (allFilms$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (allFilms$id != null) {
            final allFilms$normalized = shalom_core.NormalizedObjectRecord(typename: "FilmsConnection", id: allFilms$id);
            this$NormalizedRecord[allFilmsNormalized$Key] = allFilms$normalized;
            
            if (allFilms$cached != null && allFilms$cached is shalom_core.NormalizedObjectRecord && allFilms$cached != allFilms$normalized) {
                ctx.addChangedRecord(allFilms$normalizedID);
            }
        } else {
            this$NormalizedRecord[allFilmsNormalized$Key] = shalom_core.getOrCreateObject(this$NormalizedRecord, allFilmsNormalized$Key);
        }
    
            } else if (data.containsKey("allFilms") && allFilms$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[allFilmsNormalized$Key] = null;
                    ctx.addChangedRecord(allFilms$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[allFilmsNormalized$Key] = null;
            }
        }
    static GetFilmsResponse fromCache(shalom_core.ShalomCtx ctx) {
    final data = ctx.getCachedRecord("ROOT_QUERY");
        final allFilms$raw = data["allFilms"];
            final GetFilms_allFilms? allFilms$value = 
        allFilms$raw == null ? null :
        (allFilms$raw is  shalom_core.NormalizedObjectRecord)?
            GetFilms_allFilms.fromCached(ctx.getCachedRecord((allFilms$raw as shalom_core.NormalizedObjectRecord).normalizedID()), ctx)
        : GetFilms_allFilms.fromCached(allFilms$raw, ctx)
    
;
        return GetFilmsResponse(
            
                    allFilms: allFilms$value,
                
            );
    }
    static (GetFilmsResponse, shalom_core.CacheUpdateContext)  fromResponseImpl(shalom_core.JsonObject data, shalom_core.ShalomCtx ctx){
            // first update the cache
            final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
            normalize$inCache(
                data,
                updateCtx,
                
    
            );
            ctx.invalidateRefs(updateCtx.changedRecords);
            return (fromCache(ctx
    ), updateCtx);
        }

        static GetFilmsResponse fromResponse(shalom_core.JsonObject data, {shalom_core.ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            return fromResponseImpl(data, ctx ?? shalom_core.ShalomCtx.withCapacity()
    ).$1;
        }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetFilmsResponse &&
                    
    
        
            allFilms == other.allFilms
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                allFilms,
        
        GetFilmsResponse.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'allFilms':
            
                
    
        
            this.allFilms?.toJson()
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetFilmsResponse fromJson(shalom_core.JsonObject data) {
        final GetFilms_allFilms? allFilms$value = 
        
            data['allFilms'] == null ? null :
        GetFilms_allFilms.fromJson(data['allFilms'] as shalom_core.JsonObject)
    
;
        return GetFilmsResponse(
            
                    allFilms: allFilms$value,
                
            );
    }

}



    class GetFilms_allFilms   {
        
    static String G__typename = "FilmsConnection";
    
    
    /// class members
    final List<GetFilms_allFilms_films?>? films;
        
    

    

    // keywordargs constructor
     GetFilms_allFilms(
        {
                 this.films,
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
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "FilmsConnection", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final filmsNormalized$Key = "films";
            final films$normalizedID = "${this$normalizedID}.${ filmsNormalized$Key }";
        ctx.addDependantRecords(
            {
            films$normalizedID  
            }
        );
        final films$cached = this$NormalizedRecord[filmsNormalized$Key];
            final films$raw = data["films"];
            if (films$raw != null){
                
        
        
        final films$rawList = films$raw as List<dynamic>;
        final films$cachedList = films$cached as List<dynamic>?;

        
        if (films$cachedList == null || films$cachedList.length != films$rawList.length) {
            ctx.addChangedRecord(films$normalizedID);
        }

        final films$normalizedList = <dynamic>[];

        for (int i = 0; i < films$rawList.length; i++) {
            final item$raw = films$rawList[i];
            final item$cached = films$cachedList?.elementAtOrNull(i);
            final item$normalizedKey = "films$i";

            
            
            if (item$raw != null) {
                
                
        
        if (item$cached == null){
            ctx.addChangedRecord(films$normalizedID);
        }

        GetFilms_allFilms_films.normalize$inCache(
            item$raw as shalom_core.JsonObject,
            ctx,
            
            this$cached: item$cached is shalom_core.NormalizedObjectRecord ? ctx.shalomContext.getCachedRecord(item$cached.normalizedID()): item$cached,
            this$fieldName: item$normalizedKey,
            parent$record: this$NormalizedRecord,
            parent$normalizedID: this$normalizedID
        );

        
        final films$item$id = (item$raw as shalom_core.JsonObject)["id"] as shalom_core.RecordID?;
        if (films$item$id != null) {
            final films$item$normalized = shalom_core.NormalizedObjectRecord(typename: "Film", id: films$item$id);
            this$NormalizedRecord[item$normalizedKey] = films$item$normalized;
            
            if (item$cached != null && item$cached is shalom_core.NormalizedObjectRecord && item$cached != films$item$normalized) {
                ctx.addChangedRecord(films$normalizedID);
            }
        } else {
            this$NormalizedRecord[item$normalizedKey] = shalom_core.getOrCreateObject(this$NormalizedRecord, item$normalizedKey);
        }
    
            } else {
                
                if (item$cached != null) {
                    ctx.addChangedRecord(films$normalizedID);
                }
                this$NormalizedRecord[item$normalizedKey] = null;
            }
            

            
            
                
                films$normalizedList.add(this$NormalizedRecord[item$normalizedKey]);
            
        }

        this$NormalizedRecord[filmsNormalized$Key] = films$normalizedList;
    
            } else if (data.containsKey("films") && films$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[filmsNormalized$Key] = null;
                    ctx.addChangedRecord(films$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[filmsNormalized$Key] = null;
            }
        }
    static GetFilms_allFilms fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx) {
    final films$raw = data["films"];
            final List<GetFilms_allFilms_films?>? films$value = 
        
        
        films$raw == null ? null :
        (films$raw as List<dynamic>).map((e) => 
        e == null ? null :
        (e is  shalom_core.NormalizedObjectRecord)?
            GetFilms_allFilms_films.fromCached(ctx.getCachedRecord((e as shalom_core.NormalizedObjectRecord).normalizedID()), ctx)
        : GetFilms_allFilms_films.fromCached(e, ctx)
    
).toList()
    
;
        return GetFilms_allFilms(
            
                    films: films$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetFilms_allFilms &&
                    
    
        const ListEquality().equals(films, other.films)
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                films,
        
        GetFilms_allFilms.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'films':
            
                
    
        
        
            this.films?.map((e) => 
    
        
            e?.toJson()
        
    
).toList()
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetFilms_allFilms fromJson(shalom_core.JsonObject data) {
        final List<GetFilms_allFilms_films?>? films$value = 
        
        
        data['films'] == null ? null :
        (data['films'] as List<dynamic>).map((e) => 
        
            e == null ? null :
        GetFilms_allFilms_films.fromJson(e as shalom_core.JsonObject)
    
).toList()
    
;
        return GetFilms_allFilms(
            
                    films: films$value,
                
            );
    }

    }


    class GetFilms_allFilms_films   {
        
    static String G__typename = "Film";
    
    
    /// class members
    final String? releaseDate;
        
    final String id;
        
    final int? episodeID;
        
    final String? director;
        
    final String? title;
        
    

    

    // keywordargs constructor
     GetFilms_allFilms_films(
        {
                 this.releaseDate,
        
        
                required this.id,
        
        
                 this.episodeID,
        
        
                 this.director,
        
        
                 this.title,
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
                
                    final normalized$objRecord = shalom_core.NormalizedObjectRecord(typename: "Film", id: this$normalizedID_temp!);
                    if (this$cached != null && this$cached is shalom_core.NormalizedObjectRecord && this$cached as shalom_core.NormalizedObjectRecord != normalized$objRecord){
                        ctx.addChangedRecord("${parent$normalizedID}.${this$fieldName}");
                    }
                    parent$record[this$fieldName] = normalized$objRecord;
                    this$normalizedID = normalized$objRecord.normalizedID();
                this$NormalizedRecord = ctx.getOrCreateCachedObjectRecord(this$normalizedID);
                ctx.addDependantRecord(this$normalizedID);
            }
        final releaseDateNormalized$Key = "releaseDate";
            final releaseDate$normalizedID = "${this$normalizedID}.${ releaseDateNormalized$Key }";
        final idNormalized$Key = "id";
            final id$normalizedID = "${this$normalizedID}.${ idNormalized$Key }";
        final episodeIDNormalized$Key = "episodeID";
            final episodeID$normalizedID = "${this$normalizedID}.${ episodeIDNormalized$Key }";
        final directorNormalized$Key = "director";
            final director$normalizedID = "${this$normalizedID}.${ directorNormalized$Key }";
        final titleNormalized$Key = "title";
            final title$normalizedID = "${this$normalizedID}.${ titleNormalized$Key }";
        ctx.addDependantRecords(
            {
            releaseDate$normalizedID  ,
            id$normalizedID  ,
            episodeID$normalizedID  ,
            director$normalizedID  ,
            title$normalizedID  
            }
        );
        final releaseDate$cached = this$NormalizedRecord[releaseDateNormalized$Key];
            final releaseDate$raw = data["releaseDate"];
            if (releaseDate$raw != null){
                
        
        if (
            
    
        
            releaseDate$cached != releaseDate$raw
        
    

        ){
            ctx.addChangedRecord(releaseDate$normalizedID);
        }
        this$NormalizedRecord[releaseDateNormalized$Key] = releaseDate$raw;
    
            } else if (data.containsKey("releaseDate") && releaseDate$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[releaseDateNormalized$Key] = null;
                    ctx.addChangedRecord(releaseDate$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[releaseDateNormalized$Key] = null;
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
        final episodeID$cached = this$NormalizedRecord[episodeIDNormalized$Key];
            final episodeID$raw = data["episodeID"];
            if (episodeID$raw != null){
                
        
        if (
            
    
        
            episodeID$cached != episodeID$raw
        
    

        ){
            ctx.addChangedRecord(episodeID$normalizedID);
        }
        this$NormalizedRecord[episodeIDNormalized$Key] = episodeID$raw;
    
            } else if (data.containsKey("episodeID") && episodeID$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[episodeIDNormalized$Key] = null;
                    ctx.addChangedRecord(episodeID$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[episodeIDNormalized$Key] = null;
            }
        final director$cached = this$NormalizedRecord[directorNormalized$Key];
            final director$raw = data["director"];
            if (director$raw != null){
                
        
        if (
            
    
        
            director$cached != director$raw
        
    

        ){
            ctx.addChangedRecord(director$normalizedID);
        }
        this$NormalizedRecord[directorNormalized$Key] = director$raw;
    
            } else if (data.containsKey("director") && director$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[directorNormalized$Key] = null;
                    ctx.addChangedRecord(director$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[directorNormalized$Key] = null;
            }
        final title$cached = this$NormalizedRecord[titleNormalized$Key];
            final title$raw = data["title"];
            if (title$raw != null){
                
        
        if (
            
    
        
            title$cached != title$raw
        
    

        ){
            ctx.addChangedRecord(title$normalizedID);
        }
        this$NormalizedRecord[titleNormalized$Key] = title$raw;
    
            } else if (data.containsKey("title") && title$cached != null){
                    // if this field was null in the response and key exists clear the cache.

                    this$NormalizedRecord[titleNormalized$Key] = null;
                    ctx.addChangedRecord(title$normalizedID);
            } else {
                // data is null and cache is null, do nothing.
                this$NormalizedRecord[titleNormalized$Key] = null;
            }
        }
    static GetFilms_allFilms_films fromCached(shalom_core.NormalizedRecordData data, shalom_core.ShalomCtx ctx) {
    final releaseDate$raw = data["releaseDate"];
            final String? releaseDate$value = 
        
            
                releaseDate$raw as String?
            
        
    
;
        final id$raw = data["id"];
            final String id$value = 
        
            
                id$raw as String
            
        
    
;
        final episodeID$raw = data["episodeID"];
            final int? episodeID$value = 
        
            
                episodeID$raw as int?
            
        
    
;
        final director$raw = data["director"];
            final String? director$value = 
        
            
                director$raw as String?
            
        
    
;
        final title$raw = data["title"];
            final String? title$value = 
        
            
                title$raw as String?
            
        
    
;
        return GetFilms_allFilms_films(
            
                    releaseDate: releaseDate$value,
                
            
                    id: id$value,
                
            
                    episodeID: episodeID$value,
                
            
                    director: director$value,
                
            
                    title: title$value,
                
            );
    }
    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is GetFilms_allFilms_films &&
                    
    
        
            releaseDate == other.releaseDate
        
    
 &&
                    
    
        
            id == other.id
        
    
 &&
                    
    
        
            episodeID == other.episodeID
        
    
 &&
                    
    
        
            director == other.director
        
    
 &&
                    
    
        
            title == other.title
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                releaseDate,
        
                id,
        
                episodeID,
        
                director,
        
                title,
        
        GetFilms_allFilms_films.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'releaseDate':
            
                
    
        
            this.releaseDate
        
    

            
        ,
        
    
        
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
        
    
        
        
        'episodeID':
            
                
    
        
            this.episodeID
        
    

            
        ,
        
    
        
        
        'director':
            
                
    
        
            this.director
        
    

            
        ,
        
    
        
        
        'title':
            
                
    
        
            this.title
        
    

            
        ,
        
    
    };
    }

    @experimental
    static GetFilms_allFilms_films fromJson(shalom_core.JsonObject data) {
        final String? releaseDate$value = 
        
            
                data['releaseDate'] as String?
            
        
    
;
        final String id$value = 
        
            
                data['id'] as String
            
        
    
;
        final int? episodeID$value = 
        
            
                data['episodeID'] as int?
            
        
    
;
        final String? director$value = 
        
            
                data['director'] as String?
            
        
    
;
        final String? title$value = 
        
            
                data['title'] as String?
            
        
    
;
        return GetFilms_allFilms_films(
            
                    releaseDate: releaseDate$value,
                
            
                    id: id$value,
                
            
                    episodeID: episodeID$value,
                
            
                    director: director$value,
                
            
                    title: title$value,
                
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


class RequestGetFilms extends shalom_core.Requestable<GetFilmsResponse>{
    

    RequestGetFilms(
        
    );
    @override
    shalom_core.RequestMeta<GetFilmsResponse> getRequestMeta(){
        shalom_core.JsonObject variablesJson =  {}  ;
        final request = shalom_core.Request(
            query: r"""
            query GetFilms {
  allFilms {
    films {
      title
      director
      releaseDate
      episodeID
      id
    }
  }
}
            """,
            variables: variablesJson,
            opType: shalom_core.OperationType.Query,
            opName: 'GetFilms',
        );
        return shalom_core.RequestMeta(
            request: request,
            loadFn: ({required shalom_core.JsonObject data, required shalom_core.ShalomCtx ctx}){
                final (deserialized, updatedCtx) = GetFilmsResponse.fromResponseImpl(data, ctx);
                return (deserialized, updatedCtx.dependantRecords);
            },
            fromCacheFn: (shalom_core.ShalomCtx ctx){
                final updateCtx = shalom_core.CacheUpdateContext(shalomContext: ctx);
                final deserialized = GetFilmsResponse.fromCache(ctx);
                return (deserialized, updateCtx.dependantRecords);
            }
        );
    }
}

