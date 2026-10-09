// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'ZooQuery.shalom.dart';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'ZooQuery.shalom.dart';
import 'ZooWidget.shalom.dart';

abstract class $ZooQuery extends StatefulWidget {
  String operation$Name() => 'ZooQuery';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final ZooQueryVariables variables;
  const $ZooQuery({
    super.key,
    required this.variables,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, ZooQueryData data);

  @override
  State<$ZooQuery> createState() => _$ZooQueryState();
}

class _$ZooQueryState extends State<$ZooQuery>
    with ShalomObservingState<ZooQueryData, $ZooQuery> {
  ZooQueryData? _data;
  Object? _error;

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      _data = null;
      _error = null;
    });
  }

  @override
  void didUpdateWidget(covariant $ZooQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch ||
        widget.variables != oldWidget.variables) {
      resubscribe();
    }
  }

  @override
  Stream<shalom_core.GraphQLResponse<ZooQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) => ZooQueryObservable(
    variables: widget.variables,

    executionPolicy: widget.executionPolicy,
    retryDelay: widget.retryDelay,
    autoRefetch: widget.autoRefetch,
  ).observe(client);

  @override
  void onResponse(shalom_core.GraphQLResponse<ZooQueryData> response) {
    setState(() {
      switch (response) {
        case shalom_core.GraphQLData(data: final data):
          _data = data;
          _error = null;
        case shalom_core.GraphQLError() || shalom_core.LinkExceptionResponse():
          _error = response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.buildError(context, _error!);
    if (_data == null) return widget.buildLoading(context);
    return widget.buildData(context, _data!);
  }
}
