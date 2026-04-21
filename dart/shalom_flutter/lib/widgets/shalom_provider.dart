import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';

/// An [InheritedWidget] that provides a [ShalomRuntimeClient] to its descendants.
class ShalomProvider extends InheritedWidget {
  final ShalomRuntimeClient client;

  const ShalomProvider({super.key, required this.client, required super.child});

  /// Retrieves the nearest [ShalomRuntimeClient] from the given [BuildContext].
  ///
  /// Throws an assertion error if no [ShalomProvider] is found in the widget tree.
  static ShalomRuntimeClient of(BuildContext context) {
    final ShalomProvider? result = context
        .dependOnInheritedWidgetOfExactType<ShalomProvider>();
    assert(result != null, 'No ShalomProvider found in context');
    return result!.client;
  }

  /// Retrieves the nearest [ShalomRuntimeClient] from the given [BuildContext],
  /// or null if no [ShalomProvider] is found in the widget tree.
  static ShalomRuntimeClient? maybeOf(BuildContext context) {
    final ShalomProvider? result = context
        .dependOnInheritedWidgetOfExactType<ShalomProvider>();
    return result?.client;
  }

  @override
  bool updateShouldNotify(ShalomProvider oldWidget) {
    return client != oldWidget.client;
  }
}

/// Extension on [BuildContext] to easily access the [ShalomRuntimeClient].
extension ShalomRuntimeClientContext on BuildContext {
  /// Retrieves the nearest [ShalomRuntimeClient] from this context.
  ShalomRuntimeClient get shalomClient => ShalomProvider.of(this);
}
