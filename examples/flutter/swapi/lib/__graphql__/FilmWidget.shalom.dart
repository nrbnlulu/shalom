





























































// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: FilmWidget

import "../schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;






import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;



// ------------ V2 FRAGMENT WIDGET API -------------

extension type FilmWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {'observable_id': _inner.observableId, 'anchor': _inner.anchor};
}





final class FilmWidgetData {
  final 
    
        String?
     releaseDate;
  final 
    
        String?
     title;
  final 
    
        String?
     director;
  final 
    
        String
     id;
  final 
    
        int?
     episodeID;
  

  const FilmWidgetData({
    required this.releaseDate,
    required this.title,
    required this.director,
    required this.id,
    required this.episodeID,
    
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FilmWidgetData
    && 
    
        
            releaseDate == other.releaseDate
        
    

    && 
    
        
            title == other.title
        
    

    && 
    
        
            director == other.director
        
    

    && 
    
        
            id == other.id
        
    

    && 
    
        
            episodeID == other.episodeID
        
    

    
  );

  @override
  int get hashCode => Object.hashAll([
    releaseDate,
    title,
    director,
    id,
    episodeID,
    
  ]);

  @experimental
  static FilmWidgetData fromCache(shalom_core.JsonObject data) {
    final 
    
        String?
     releaseDate$value = 
    
        
            
                data['releaseDate'] as String?
            
        
    
;
    final 
    
        String?
     title$value = 
    
        
            
                data['title'] as String?
            
        
    
;
    final 
    
        String?
     director$value = 
    
        
            
                data['director'] as String?
            
        
    
;
    final 
    
        String
     id$value = 
    
        
            
                data['id'] as String
            
        
    
;
    final 
    
        int?
     episodeID$value = 
    
        
            
                data['episodeID'] as int?
            
        
    
;
    return FilmWidgetData(
      
          releaseDate: releaseDate$value,
        
      
          title: title$value,
        
      
          director: director$value,
        
      
          id: id$value,
        
      
          episodeID: episodeID$value,
        
      );
  }

  shalom_core.JsonObject toJson() {
    return {
      
        'releaseDate': 
    
        
            this.releaseDate
        
    
,
      
        'title': 
    
        
            this.title
        
    
,
      
        'director': 
    
        
            this.director
        
    
,
      
        'id': 
    
        
            this.id
        
    
,
      
        'episodeID': 
    
        
            this.episodeID
        
    
,
      
    };
  }
}


abstract class $FilmWidget extends StatefulWidget {
  final FilmWidgetRef ref;
  const $FilmWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, FilmWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$FilmWidget> createState() => _$FilmWidgetState();
}

class _$FilmWidgetState extends State<$FilmWidget> {
  StreamSubscription<FilmWidgetData>? _sub;
  FilmWidgetData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $FilmWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<FilmWidgetData>(
          ref: widget.ref.toInput,
          decoder: FilmWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() { _data = data; _error = null; }),
          onError: (e) => setState(() { _error = e; }),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null) return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}

// ------------ END V2 FRAGMENT WIDGET API -------------
