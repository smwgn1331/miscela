import 'package:flutter/foundation.dart';
import 'package:miscela/reactive/reactive.dart';

import 'target.dart';

class Rx<T> extends RxEmitter implements RxTarget<T> {
  Rx(this._value);

  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    pokeSubscribers();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class RxEmitter implements Reactive {
  int _count = 0;
  List<VoidCallback?> _listeners = List<VoidCallback?>.filled(0, null);
  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedSubscribers = 0;
  bool _debugDisposed = false;

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_debugDisposed) {
        throw FlutterError(
          'A $runtimeType was used after being disposed.\n'
          'Once you have called dispose() on a $runtimeType, it can no longer be used.',
        );
      }
      return true;
    }());
    return true;
  }

  @protected
  bool get hasSubscribers {
    assert(_debugAssertNotDisposed());
    return _count > 0;
  }

  @override
  void addSubscriber(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_count == _listeners.length) {
      if (_count == 0) {
        _listeners = List<VoidCallback?>.filled(1, null);
      } else {
        final List<VoidCallback?> newSubscribers =
            List<VoidCallback?>.filled(_listeners.length * 2, null);
        for (int i = 0; i < _count; i++) {
          newSubscribers[i] = _listeners[i];
        }
        _listeners = newSubscribers;
      }
    }
    _listeners[_count++] = listener;
  }

  void _removeAt(int index) {
    _count -= 1;
    if (_count * 2 <= _listeners.length) {
      final List<VoidCallback?> newSubscribers =
          List<VoidCallback?>.filled(_count, null);

      for (int i = 0; i < index; i++) {
        newSubscribers[i] = _listeners[i];
      }

      for (int i = index; i < _count; i++) {
        newSubscribers[i] = _listeners[i + 1];
      }

      _listeners = newSubscribers;
    } else {
      for (int i = index; i < _count; i++) {
        _listeners[i] = _listeners[i + 1];
      }
      _listeners[_count] = null;
    }
  }

  @override
  void removeSubscriber(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    for (int i = 0; i < _count; i++) {
      final VoidCallback? _listener = _listeners[i];
      if (_listener == listener) {
        if (_notificationCallStackDepth > 0) {
          _listeners[i] = null;
          _reentrantlyRemovedSubscribers++;
        } else {
          _removeAt(i);
        }
        break;
      }
    }
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    assert(() {
      _debugDisposed = true;
      return true;
    }());
  }

  @protected
  @visibleForTesting
  @pragma('vm:notify-debugger-on-exception')
  void pokeSubscribers() {
    assert(_debugAssertNotDisposed());
    if (_count == 0) return;

    _notificationCallStackDepth++;

    final int end = _count;
    for (int i = 0; i < end; i++) {
      try {
        _listeners[i]?.call();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
              'while dispatching notifications for $runtimeType'),
          informationCollector: () => <DiagnosticsNode>[
            DiagnosticsProperty<RxEmitter>(
              'The $runtimeType sending notification was',
              this,
              style: DiagnosticsTreeStyle.errorProperty,
            ),
          ],
        ));
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 &&
        _reentrantlyRemovedSubscribers > 0) {
      final int newLength = _count - _reentrantlyRemovedSubscribers;
      if (newLength * 2 <= _listeners.length) {
        final List<VoidCallback?> newSubscribers =
            List<VoidCallback?>.filled(newLength, null);

        int newIndex = 0;
        for (int i = 0; i < _count; i++) {
          final VoidCallback? listener = _listeners[i];
          if (listener != null) {
            newSubscribers[newIndex++] = listener;
          }
        }

        _listeners = newSubscribers;
      } else {
        for (int i = 0; i < newLength; i += 1) {
          if (_listeners[i] == null) {
            int swapIndex = i + 1;
            while (_listeners[swapIndex] == null) {
              swapIndex += 1;
            }
            _listeners[i] = _listeners[swapIndex];
            _listeners[swapIndex] = null;
          }
        }
      }

      _reentrantlyRemovedSubscribers = 0;
      _count = newLength;
    }
  }
}
