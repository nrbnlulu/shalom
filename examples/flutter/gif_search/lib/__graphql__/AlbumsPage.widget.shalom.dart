


// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'AlbumsPage.shalom.dart';

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;
import 'AlbumsPage.shalom.dart';

abstract class $AlbumsPage extends StatefulWidget {
    
        const $AlbumsPage({super.key});
    

    Widget buildLoading(BuildContext context);
    Widget buildError(BuildContext context, Object error);
    Widget buildData(BuildContext context, AlbumsPageData data);

    @override
    State<$AlbumsPage> createState() => _$AlbumsPageState();
}

class _$AlbumsPageState extends State<$AlbumsPage> {
    StreamSubscription<AlbumsPageData>? _sub;
    AlbumsPageData? _data;
    Object? _error;

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        _subscribe();
    }

    @override
    void didUpdateWidget(covariant $AlbumsPage oldWidget) {
        super.didUpdateWidget(oldWidget);
        
    }

    void _subscribe() {
        _sub?.cancel();
        final client = ShalomScope.of(context);
        _sub = client
            .request<AlbumsPageData>(
                name: 'AlbumsPage',
                
                variables: null,
                
                decoder: AlbumsPageData.fromCache,
                executionPolicy: shalom_core.ExecutionPolicyInput.cacheFirst,
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