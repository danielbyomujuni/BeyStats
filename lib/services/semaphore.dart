import 'dart:async';

class Semaphore {
  final int _maxPermits;
  int _availablePermits;
  final List<Completer<void>> _waiters = [];

  Semaphore(this._maxPermits) : _availablePermits = _maxPermits;

  Future<void> acquire() async {
    if (_availablePermits > 0) {
      _availablePermits--;
    } else {
      var completer = Completer<void>();
      _waiters.add(completer);
      await completer.future;
    }
  }

  void release() {
    if (_waiters.isNotEmpty) {
      var completer = _waiters.removeAt(0);
      completer.complete();
    } else {
      _availablePermits++;
    }
  }
}
