import 'reactive.dart';

abstract class RxTarget<T> extends Reactive {
  const RxTarget();

  T get value;
}
