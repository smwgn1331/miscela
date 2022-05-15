import 'package:flutter/material.dart';

import '../reactive/all.dart';

class MxText extends StatefulWidget {
  const MxText(
    this.data, {
    Key? key,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
    this.ifNull,
  }) : super(key: key);
  final RxTarget<String?> data;
  final String? ifNull;
  final TextStyle? textStyle;
  final TextOverflow textOverflow;

  @override
  State<MxText> createState() => _MxTextState();
}

class _MxTextState extends State<MxText> {
  late String data;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: widget.textStyle,
      overflow: widget.textOverflow,
    );
  }

  @override
  void initState() {
    data = widget.data.value ?? widget.ifNull ?? "";
    widget.data.addSubscriber(_dataChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MxText oldWidget) {
    if (oldWidget.data != widget.data) {
      oldWidget.data.removeSubscriber(_dataChanged);
      data = widget.data.value ?? widget.ifNull ?? "";
      widget.data.addSubscriber(_dataChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.data.removeSubscriber(_dataChanged);
    super.dispose();
  }

  void _dataChanged() {
    setState(() => data = widget.data.value ?? widget.ifNull ?? "");
  }
}
