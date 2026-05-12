





























































// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions
// GENERATED CODE - DO NOT MODIFY BY HAND
// Fragment: ZooWidget

import "../../graphql/__graphql__/schema.shalom.dart";
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show experimental;






import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;



// ------------ V2 FRAGMENT WIDGET API -------------

extension type ZooWidgetRef.fromInput(shalom_core.ObservedRefInput _inner) {
  shalom_core.ObservedRefInput get toInput => _inner;
  shalom_core.JsonObject toJson() => {'observable_id': _inner.observableId, 'anchor': _inner.anchor};
}






class ZooWidget_cages   {
        
    static String G__typename = "Cage";
    
    
    /// class members
    final 
    
        String
     id;
        
    final 
    
        String
     name;
        
    

    

    // keywordargs constructor
     ZooWidget_cages(
        {
                required this.id,
        
        
                required this.name,
        }
        
    );

    @override
    bool operator ==(Object other) {
        return identical(this, other) ||
            
            (other is ZooWidget_cages &&
                    
    
        
            id == other.id
        
    
 &&
                    
    
        
            name == other.name
        
    
 
                    );
            
    }

    @override
    int get hashCode =>
    
        Object.hashAll([
        
                id,
        
                name,
        
        ZooWidget_cages.G__typename
        ]);
    

    shalom_core.JsonObject toJson() {
    return {
    
        
        
        'id':
            
                
    
        
            this.id
        
    

            
        ,
        
    
        
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
        
    
    };
    }

    @experimental
    static ZooWidget_cages fromJson(shalom_core.JsonObject data) {
        final 
    
        String
     id$value = 
    
        
            
                data['id'] as String
            
        
    
;
        final 
    
        String
     name$value = 
    
        
            
                data['name'] as String
            
        
    
;
        return ZooWidget_cages(
            
                    id: id$value,
                
            
                    name: name$value,
                
            );
    }

    }



final class ZooWidgetData {
  final 
    
        String
     name;
  final 
    
        List<ZooWidget_cages>
     cages;
  final 
    
        String
     id;
  

  const ZooWidgetData({
    required this.name,
    required this.cages,
    required this.id,
    
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ZooWidgetData
    && 
    
        
            name == other.name
        
    

    && 
    
        const ListEquality().equals(cages, other.cages)
    

    && 
    
        
            id == other.id
        
    

    
  );

  @override
  int get hashCode => Object.hashAll([
    name,
    cages,
    id,
    
  ]);

  @experimental
  static ZooWidgetData fromCache(shalom_core.JsonObject data) {
    final 
    
        String
     name$value = 
    
        
            
                data['name'] as String
            
        
    
;
    final 
    
        List<ZooWidget_cages>
     cages$value = 
    
        
        
        (data['cages'] as List<dynamic>).map((e) => 
    
        ZooWidget_cages.fromJson(e as shalom_core.JsonObject)
    
).toList()
    
;
    final 
    
        String
     id$value = 
    
        
            
                data['id'] as String
            
        
    
;
    return ZooWidgetData(
      
          name: name$value,
        
      
          cages: cages$value,
        
      
          id: id$value,
        
      );
  }

  shalom_core.JsonObject toJson() {
    return {
      
        'name': 
    
        
            this.name
        
    
,
      
        'cages': 
    
        
        
            this.cages.map((e) => 
    
        
            e.toJson()
        
    
).toList()
        
    
,
      
        'id': 
    
        
            this.id
        
    
,
      
    };
  }
}


abstract class $ZooWidget extends StatefulWidget {
  final ZooWidgetRef ref;
  const $ZooWidget({super.key, required this.ref});

  Widget buildData(BuildContext context, ZooWidgetData data);
  Widget buildLoading(BuildContext context) => const SizedBox.shrink();
  Widget buildError(BuildContext context, Object error) => ErrorWidget(error);

  @override
  State<$ZooWidget> createState() => _$ZooWidgetState();
}

class _$ZooWidgetState extends State<$ZooWidget> {
  StreamSubscription<ZooWidgetData>? _sub;
  ZooWidgetData? _data;
  Object? _error;

  @override
  void reassemble() {
    super.reassemble();
    setState(() { _data = null; _error = null; });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $ZooWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ref != oldWidget.ref) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .subscribeToFragment<ZooWidgetData>(
          ref: widget.ref.toInput,
          decoder: ZooWidgetData.fromCache,
        )
        .listen(
          (data) => setState(() { _data = data; _error = null; }),
          onError: (e) => setState(() { _error = e; }),
          onDone: () { if (mounted) _subscribe(); },
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
