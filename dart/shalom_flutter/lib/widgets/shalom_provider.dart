import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';

/// An [InheritedWidget] that provides a [ShalomRuntimeClient] to its descendants.
///
/// Place this at the root of your widget tree:
/// ```dart
/// ShalomProvider(
///   client: client,
///   child: const MaterialApp(...),
/// );
/// ```
///
/// Access the client from any descendant:
/// ```dart
/// final client = ShalomScope.of(context);
/// // or
/// final client = context.shalom;
/// ```
class ShalomProvider extends InheritedWidget {
  final ShalomRuntimeClient client;

  const ShalomProvider({super.key, required this.client, required super.child});

  @override
  bool updateShouldNotify(ShalomProvider oldWidget) {
    return client != oldWidget.client;
  }
}

/// Convenience accessor for [ShalomProvider].
///
/// `ShalomScope.of(context)` is equivalent to `ShalomProvider.of(context)`.
class ShalomScope {
  const ShalomScope._();

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
}

/// Extension on [BuildContext] to easily access the [ShalomRuntimeClient].
extension ShalomContextExtension on BuildContext {
  /// Retrieves the nearest [ShalomRuntimeClient] from this context.
  ShalomRuntimeClient get shalomClient => ShalomScope.of(this);

  /// Shorthand for [shalomClient].
  ShalomRuntimeClient get shalom => ShalomScope.of(this);
}
