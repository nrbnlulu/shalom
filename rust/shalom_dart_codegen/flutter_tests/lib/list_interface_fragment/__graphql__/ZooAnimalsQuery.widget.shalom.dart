// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'ZooAnimalsQuery.shalom.dart';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'ZooAnimalsQuery.shalom.dart';
import 'ZooAnimalsWidget.shalom.dart';

abstract class $ZooAnimalsQuery extends StatefulWidget {
  String operation$Name() => 'ZooAnimalsQuery';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final ZooAnimalsQueryVariables variables;
  const $ZooAnimalsQuery({
    super.key,
    required this.variables,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, ZooAnimalsQueryData data);

  @override
  State<$ZooAnimalsQuery> createState() => _$ZooAnimalsQueryState();
}

class _$ZooAnimalsQueryState extends State<$ZooAnimalsQuery>
    with ShalomObservingState<ZooAnimalsQueryData, $ZooAnimalsQuery> {
  ZooAnimalsQueryData? _data;
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
  void didUpdateWidget(covariant $ZooAnimalsQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch ||
        widget.variables != oldWidget.variables) {
      resubscribe();
    }
  }

  @override
  Stream<shalom_core.GraphQLResponse<ZooAnimalsQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) => ZooAnimalsQueryObservable(
    variables: widget.variables,

    executionPolicy: widget.executionPolicy,
    retryDelay: widget.retryDelay,
    autoRefetch: widget.autoRefetch,
  ).observe(client);

  @override
  void onResponse(shalom_core.GraphQLResponse<ZooAnimalsQueryData> response) {
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
