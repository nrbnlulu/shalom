// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'StreetSubscription.shalom.dart';

import 'dart:async' show StreamSubscription, unawaited;
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'StreetSubscription.shalom.dart';
import 'DogFrag.shalom.dart';

abstract class $StreetSubscription extends StatefulWidget {
  String operation$Name() => 'StreetSubscription';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  const $StreetSubscription({
    super.key,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, StreetSubscriptionData data);

  @override
  State<$StreetSubscription> createState() => _$StreetSubscriptionState();
}

class _$StreetSubscriptionState extends State<$StreetSubscription> {
  StreamSubscription<shalom_core.GraphQLResponse<StreetSubscriptionData>>? _sub;
  late shalom_core.ShalomRuntimeClient _client;
  int _subscriptionGeneration = 0;
  StreetSubscriptionData? _data;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subscriptionGeneration == 0) {
      _client = ShalomScope.of(context);
      _subscribe();
    }
  }

  @override
  void didUpdateWidget(covariant $StreetSubscription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch) {
      _subscribe();
    }
  }

  void _subscribe() {
    final generation = ++_subscriptionGeneration;
    unawaited(_sub?.cancel());
    _sub =
        StreetSubscriptionObservable(
              executionPolicy: widget.executionPolicy,
              retryDelay: widget.retryDelay,
              autoRefetch: widget.autoRefetch,
            )
            .observe(_client)
            .listen(
              (response) {
                if (generation != _subscriptionGeneration) return;
                setState(() {
                  switch (response) {
                    case shalom_core.GraphQLData(data: final data):
                      _data = data;
                      _error = null;
                    case shalom_core.GraphQLError() ||
                        shalom_core.LinkExceptionResponse():
                      _error = response;
                  }
                });
              },
              onDone: () {
                if (mounted && generation == _subscriptionGeneration) {
                  _subscribe();
                }
              },
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
