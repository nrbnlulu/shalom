// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'ShelterSubscription.shalom.dart';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'ShelterSubscription.shalom.dart';
import 'DogFrag.shalom.dart';

abstract class $ShelterSubscription extends StatefulWidget {
  String operation$Name() => 'ShelterSubscription';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const $ShelterSubscription({
    super.key,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, ShelterSubscriptionData data);

  @override
  State<$ShelterSubscription> createState() => _$ShelterSubscriptionState();
}

class _$ShelterSubscriptionState extends State<$ShelterSubscription>
    with ShalomObservingState<ShelterSubscriptionData, $ShelterSubscription> {
  ShelterSubscriptionData? _data;
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
  void didUpdateWidget(covariant $ShelterSubscription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch) {
      resubscribe();
    }
  }

  @override
  Stream<shalom_core.GraphQLResponse<ShelterSubscriptionData>> observe(
    shalom_core.ShalomRuntimeClient client,
  ) => ShelterSubscriptionObservable(
    executionPolicy: widget.executionPolicy,
    retryDelay: widget.retryDelay,
    autoRefetch: widget.autoRefetch,
  ).observe(client);

  @override
  void onResponse(
    shalom_core.GraphQLResponse<ShelterSubscriptionData> response,
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
