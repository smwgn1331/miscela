import 'package:flutter/widgets.dart';

import '../reactive/target.dart';
import '../reactive/types.dart';

class MxWrapper<T> extends StatefulWidget {
  const MxWrapper({
    Key? key,
    required this.rxTarget,
    required this.builder,
  }) : super(key: key);

  final RxTarget<T> rxTarget;

  final RxWidgetBuilder<T> builder;

  @override
  State<StatefulWidget> createState() => _MxWrapperState<T>();
}

class _MxWrapperState<T> extends State<MxWrapper<T>> {
  late T value;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }

  @override
  void initState() {
    super.initState();
    value = widget.rxTarget.value;
    widget.rxTarget.addSubscriber(_valueChanged);
  }

  @override
  void didUpdateWidget(MxWrapper<T> oldWidget) {
    if (oldWidget.rxTarget != widget.rxTarget) {
      oldWidget.rxTarget.removeSubscriber(_valueChanged);
      value = widget.rxTarget.value;
      widget.rxTarget.addSubscriber(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.rxTarget.removeSubscriber(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.rxTarget.value;
    });
  }
}
