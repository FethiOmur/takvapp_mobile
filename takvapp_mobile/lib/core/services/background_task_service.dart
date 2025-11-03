import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Coordinates foreground and background refresh strategies.
///
/// Platform-specific implementations should be provided in
/// `android/` and `ios/` layers and wired through dependency
/// injection once ready. This class acts as the common contract
/// for the Flutter layer.
abstract class BackgroundTaskService {
  /// Called when Significant Location Change events are delivered
  /// (3km+ on iOS, configurable on Android).
  Future<void> onSignificantLocationChange(Position newPosition);

  /// Called by periodic background handlers (e.g. WorkManager,
  /// BGAppRefreshTask) to ensure prayer times are refreshed when
  /// the calendar day changes while the app is not active.
  Future<void> onDailyRefreshTick();

  /// Registers the desired background tasks. Actual registration is
  /// platform-dependent and should be implemented in native code.
  Future<void> registerBackgroundTasks();

  /// Cancels any scheduled background tasks. Use when the user logs out
  /// or disables background refresh from settings.
  Future<void> cancelBackgroundTasks();
}

/// Base implementation used during development that simply no-ops.
/// This keeps the UI callable without relying on native bindings yet.
class NoopBackgroundTaskService implements BackgroundTaskService {
  @override
  Future<void> cancelBackgroundTasks() async {}

  @override
  Future<void> onDailyRefreshTick() async {}

  @override
  Future<void> onSignificantLocationChange(Position newPosition) async {}

  @override
  Future<void> registerBackgroundTasks() async {}
}
