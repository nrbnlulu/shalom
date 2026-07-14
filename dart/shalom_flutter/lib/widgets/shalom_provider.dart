import 'package:flutter/widgets.dart';
import 'package:shalom/shalom.dart';

/// Low-level [InheritedWidget] that stores a [ShalomRuntimeClient] in the
/// widget tree.  Not intended for direct use — the generated `ShalomProvider`
/// in `shalom_init.shalom.dart` wraps this and adds hot-reload support.
class ShalomInheritedWidget extends InheritedWidget {
  final ShalomRuntimeClient client;

  /// Bumped post-frame so dependent widgets retry subscriptions after the Rust transport initializes.
  final int generation;

  const ShalomInheritedWidget({
    super.key,
    required this.client,
    this.generation = 0,
    required super.child,
  });

  @override
  bool updateShouldNotify(ShalomInheritedWidget oldWidget) =>
      client != oldWidget.client || generation != oldWidget.generation;
}

/// Convenience accessor for [ShalomInheritedWidget].
class ShalomScope {
  const ShalomScope._();

  /// Retrieves the nearest [ShalomRuntimeClient] from the given [BuildContext].
  static ShalomRuntimeClient of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ShalomInheritedWidget>();
    assert(result != null, 'No ShalomProvider found in context');
    return result!.client;
  }

  /// Returns the nearest [ShalomRuntimeClient], or null if none is found.
  static ShalomRuntimeClient? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ShalomInheritedWidget>()
      ?.client;
}

/// Extension on [BuildContext] to easily access the [ShalomRuntimeClient].
extension ShalomContextExtension on BuildContext {
  ShalomRuntimeClient get shalomClient => ShalomScope.of(this);
  ShalomRuntimeClient get shalom => ShalomScope.of(this);
}
