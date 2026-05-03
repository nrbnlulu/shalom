// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'PeoplePage.shalom.dart';

import 'dart:async' show StreamSubscription;
import 'package:flutter/widgets.dart';
import 'package:shalom_flutter/shalom_flutter.dart' show ShalomScope;
import 'PeoplePage.shalom.dart';

abstract class $PeoplePage extends StatefulWidget {
  final PeoplePageVariables variables;
  const $PeoplePage({super.key, required this.variables});

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, PeoplePageData data);

  @override
  State<$PeoplePage> createState() => _$PeoplePageState();
}

class _$PeoplePageState extends State<$PeoplePage> {
  StreamSubscription<PeoplePageData>? _sub;
  PeoplePageData? _data;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant $PeoplePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.variables != oldWidget.variables) _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    final client = ShalomScope.of(context);
    _sub = client
        .request<PeoplePageData>(
          name: 'PeoplePage',

          variables: widget.variables.toJson(),

          decoder: PeoplePageData.fromCache,
        )
        .listen(
          (data) => setState(() {
            _data = data;
            _error = null;
          }),
          onError:
              (e) => setState(() {
                _error = e;
              }),
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
