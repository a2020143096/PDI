import 'dart:async';

typedef _Callbacker<T> = String? Function(void Function(T?) callback);

Future<T> futurize<T>(_Callbacker<T> callbacker) {
  final Completer<T> completer = Completer<T>.sync();
  // If the callback synchronously throws an error, then synchronously
  // rethrow that error instead of adding it to the completer. This
  // prevents the Zone from receiving an uncaught exception.
  bool sync = true;
  final String? error = callbacker((T? t) {
    if (t == null) {
      if (sync) {
        throw Exception('operation failed');
      } else {
        completer.completeError(Exception('operation failed'));
      }
    } else {
      completer.complete(t);
    }
  });
  sync = false;
  if (error != null) {
    throw Exception(error);
  }
  return completer.future;
}
