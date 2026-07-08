// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'ZooAnimalsContractQuery.shalom.dart';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'ZooAnimalsContractQuery.shalom.dart';
import 'CommonAnimalFrag.shalom.dart';
import 'DogFavoriteFrag.shalom.dart';
import 'DogWithFavoriteToyFrag.shalom.dart';
import 'HasFavoriteToyFrag.shalom.dart';
import 'ToyFrag.shalom.dart';

abstract class $ZooAnimalsContractQuery extends StatefulWidget {
  String operation$Name() => 'ZooAnimalsContractQuery';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const $ZooAnimalsContractQuery({
    super.key,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, ZooAnimalsContractQueryData data);

  @override
  State<$ZooAnimalsContractQuery> createState() =>
      _$ZooAnimalsContractQueryState();
}

class _$ZooAnimalsContractQueryState extends State<$ZooAnimalsContractQuery>
    with
        ShalomObservingState<
          ZooAnimalsContractQueryData,
          $ZooAnimalsContractQuery
        > {
  ZooAnimalsContractQueryData? _data;
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
  void didUpdateWidget(covariant $ZooAnimalsContractQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch) {
      resubscribe();
    }
  }

  @override
  Stream<shalom_core.GraphQLResponse<ZooAnimalsContractQueryData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) => ZooAnimalsContractQueryObservable(
    executionPolicy: widget.executionPolicy,
    retryDelay: widget.retryDelay,
    autoRefetch: widget.autoRefetch,
  ).observe(client);

  @override
  void onResponse(
    shalom_core.GraphQLResponse<ZooAnimalsContractQueryData> response,
  ) {
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
