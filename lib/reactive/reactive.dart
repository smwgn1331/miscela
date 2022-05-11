import 'types.dart';

class _MergingReactive extends Reactive {
  _MergingReactive(this._children);

  final List<Reactive?> _children;

  @override
  void addSubscriber(VoidCallback subscriber) {
    for (final Reactive? child in _children) {
      child?.addSubscriber(subscriber);
    }
  }

  @override
  void removeSubscriber(VoidCallback subscriber) {
    for (final Reactive? child in _children) {
      child?.removeSubscriber(subscriber);
    }
  }

  @override
  String toString() {
    return 'Reactive.merge([${_children.join(", ")}])';
  }
}

abstract class Reactive {
  const Reactive();

  factory Reactive.merge(List<Reactive?> reactives) = _MergingReactive;

  void addSubscriber(VoidCallback subscriber);

  void removeSubscriber(VoidCallback subscriber);
}
