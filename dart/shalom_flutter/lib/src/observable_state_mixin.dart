import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart' show ShalomRuntimeClient, GraphQLResponse;
import 'package:shalom_flutter/widgets/shalom_provider.dart' show ShalomScope;

/// Shared subscription lifecycle for widgets that observe a stream keyed off
/// a [ShalomRuntimeClient] resolved from [ShalomScope].
///
/// Resolves the client exactly once (on the first [didChangeDependencies]
/// call) instead of on every call — `didChangeDependencies` fires on any
/// ancestor [InheritedWidget] rebuild, not just when the client actually
/// changes, so resubscribing there unconditionally causes spurious
/// loading-state flicker. Call [resubscribe] explicitly whenever a widget
/// parameter that should restart the subscription changes (e.g. from
/// `didUpdateWidget`).
///
/// [_subscriptionGeneration] also guards against a stale subscription's
/// `onDone` firing after a newer [resubscribe] call has already superseded
/// it, which would otherwise spawn a duplicate subscription.
mixin ShalomObservingState<TData, T extends StatefulWidget> on State<T> {
  StreamSubscription<GraphQLResponse<TData>>? _sub;
  late ShalomRuntimeClient _client;
  int _subscriptionGeneration = 0;

  /// Builds the stream to observe against [client].
  Stream<GraphQLResponse<TData>> observe(ShalomRuntimeClient client);

  /// Handles each emitted response (typically via `setState`).
  void onResponse(GraphQLResponse<TData> response);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subscriptionGeneration == 0) {
      _client = ShalomScope.of(context);
      resubscribe();
    }
  }

  /// Cancels any existing subscription and starts a new one against the
  /// resolved client. Safe to call multiple times.
  @protected
  void resubscribe() {
    final generation = ++_subscriptionGeneration;
    unawaited(_sub?.cancel());
    _sub = observe(_client).listen(
      (response) {
        if (generation != _subscriptionGeneration) return;
        onResponse(response);
      },
      onDone: () {
        if (mounted && generation == _subscriptionGeneration) {
          resubscribe();
        }
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
