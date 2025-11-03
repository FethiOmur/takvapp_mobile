typedef RetryCallback<T> = Future<T> Function();

Future<T> retry<T>(
  RetryCallback<T> task, {
  int maxAttempts = 3,
  Duration baseDelay = const Duration(milliseconds: 250),
  void Function(Object error, int attempt)? onRetry,
}) async {
  assert(maxAttempts > 0, 'maxAttempts must be greater than zero');

  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await task();
    } catch (error) {
      if (attempt == maxAttempts) {
        rethrow;
      }

      onRetry?.call(error, attempt);
      final delayMilliseconds = baseDelay.inMilliseconds * attempt;
      if (delayMilliseconds > 0) {
        await Future.delayed(Duration(milliseconds: delayMilliseconds));
      }
    }
  }

  throw StateError('retry failed but no error was thrown');
}
