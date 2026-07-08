import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart'
    show
        ShalomRuntimeClient,
        GraphQLResponse,
        GraphQLData,
        GraphQLError,
        LinkExceptionResponse;
import 'package:shalom_flutter/widgets/shalom_provider.dart' show ShalomScope;

typedef ShalomObserve<TData> =
    Stream<GraphQLResponse<TData>> Function(ShalomRuntimeClient client);

typedef ShalomErrorBuilder =
    Widget Function(BuildContext context, Object error);

typedef ShalomDataWidgetBuilder<TData> =
    Widget Function(BuildContext context, TData data);

class ShalomDataScope<TData> extends StatefulWidget {
  final Object identity;
  final ShalomObserve<TData> observe;
  final ShalomDataWidgetBuilder<TData> builder;
  final WidgetBuilder? loadingBuilder;
  final ShalomErrorBuilder? errorBuilder;

  const ShalomDataScope({
    super.key,
    required this.identity,
    required this.observe,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<ShalomDataScope<TData>> createState() => _ShalomDataScopeState<TData>();
}

class _ShalomDataScopeState<TData> extends State<ShalomDataScope<TData>> {
  StreamSubscription<GraphQLResponse<TData>>? _sub;
  ShalomRuntimeClient? _client;
  int _subscriptionGeneration = 0;
  TData? _data;
  bool _hasData = false;
  Object? _error;

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      _data = null;
      _hasData = false;
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
  void didUpdateWidget(covariant ShalomDataScope<TData> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.identity != oldWidget.identity) {
      _subscribe(_client ?? ShalomScope.of(context));
    }
  }

  void _subscribe(ShalomRuntimeClient client) {
    final generation = ++_subscriptionGeneration;
    unawaited(_sub?.cancel());
    _sub = widget
        .observe(client)
        .listen(
          (response) {
            if (generation != _subscriptionGeneration) return;
            setState(() {
              switch (response) {
                case GraphQLData(data: final data):
                  _data = data;
                  _hasData = true;
                  _error = null;
                case GraphQLError() || LinkExceptionResponse():
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
    final error = _error;
    if (error != null && widget.errorBuilder != null) {
      return widget.errorBuilder!(context, error);
    }
    if (!_hasData) {
      final loadingBuilder = widget.loadingBuilder;
      if (loadingBuilder != null) return loadingBuilder(context);
      return const SizedBox.shrink();
    }
    return widget.builder(context, _data as TData);
  }
}
