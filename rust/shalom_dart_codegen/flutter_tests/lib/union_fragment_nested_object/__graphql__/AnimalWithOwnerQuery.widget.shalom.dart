// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, empty_statements, annotate_overrides, no_leading_underscores_for_local_identifiers, unnecessary_cast, camel_case_extensions

// Re-export all generated types so importers only need this file.
export 'AnimalWithOwnerQuery.shalom.dart';

import 'dart:async' show StreamSubscription, unawaited;
import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' as shalom_core;
import 'package:shalom_flutter/shalom_flutter.dart';
import 'AnimalWithOwnerQuery.shalom.dart';
import 'AnimalWithOwnerWidget.shalom.dart';

abstract class $AnimalWithOwnerQuery extends StatefulWidget {
  String operation$Name() => 'AnimalWithOwnerQuery';

  final shalom_core.ExecutionPolicyInput executionPolicy;
  final shalom_core.RetryDelay retryDelay;
  final Duration? autoRefetch;

  final AnimalWithOwnerQueryVariables variables;
  const $AnimalWithOwnerQuery({
    super.key,
    required this.variables,
    this.executionPolicy = .cacheFirst,
    this.retryDelay = const .inherit(),
    this.autoRefetch,
  });

  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildData(BuildContext context, AnimalWithOwnerQueryData data);

  @override
  State<$AnimalWithOwnerQuery> createState() => _$AnimalWithOwnerQueryState();
}

class _$AnimalWithOwnerQueryState extends State<$AnimalWithOwnerQuery> {
  StreamSubscription<shalom_core.GraphQLResponse<AnimalWithOwnerQueryData>>?
  _sub;
  shalom_core.ShalomRuntimeClient? _client;
  int _subscriptionGeneration = 0;
  AnimalWithOwnerQueryData? _data;
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
    final client = ShalomScope.of(context);
    if (!identical(client, _client)) {
      _client = client;
      _subscribe(client);
    }
  }

  @override
  void didUpdateWidget(covariant $AnimalWithOwnerQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.executionPolicy != oldWidget.executionPolicy ||
        widget.retryDelay != oldWidget.retryDelay ||
        widget.autoRefetch != oldWidget.autoRefetch ||
        widget.variables != oldWidget.variables) {
      _subscribe(_client ?? ShalomScope.of(context));
    }
  }

  void _subscribe(shalom_core.ShalomRuntimeClient client) {
    final generation = ++_subscriptionGeneration;
    unawaited(_sub?.cancel());
    _sub =
        AnimalWithOwnerQueryObservable(
              variables: widget.variables,

              executionPolicy: widget.executionPolicy,
              retryDelay: widget.retryDelay,
              autoRefetch: widget.autoRefetch,
            )
            .observe(client)
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
                  _subscribe(client);
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
