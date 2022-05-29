import 'package:flutter/material.dart';
import 'package:miscela/common/string.capital.ext.dart';

import '../reactive/all.dart';
import 'radio.dart';

class MxRadioGroup extends StatefulWidget {
  const MxRadioGroup({
    Key? key,
    required this.selected,
    required this.options,
    required this.label,
    this.errorText,
    required this.onChanged,
    this.disabled,
    this.direction = Axis.vertical,
  }) : super(key: key);

  final RxTarget selected;
  final List<Map<String, dynamic>> options;
  final String label;
  final RxTarget<String>? errorText;
  final ValueChanged onChanged;
  final Rx<bool>? disabled;
  final Axis direction;

  @override
  State<MxRadioGroup> createState() => _MxRadioGroupState();
}

class _MxRadioGroupState extends State<MxRadioGroup> {
  late dynamic _selected;
  String _errorText = "";
  late bool _disabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _disabled == true ? 0.65 : 1,
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label.capitalize,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                direction: widget.direction,
                children: widget.options
                    .map((e) => MxRadio(
                          label: e['label'],
                          value: e['value'],
                          selected:
                              _selected.toString() == e['value'].toString(),
                          onChanged: (value) => _disabled == true
                              ? widget.onChanged(value)
                              : null,
                        ))
                    .toList(),
              ),
            ),
            Text(
              _errorText.capitalizeFirst,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _disabled = widget.disabled?.value ?? false;
    if (widget.disabled != null) {
      widget.disabled?.addSubscriber(_disabledChanged);
    }

    if (widget.errorText != null) {
      _errorText = widget.errorText!.value;
      widget.errorText!.addSubscriber(_errorTextChanged);
    }

    _selected = widget.selected.value;
    widget.selected.addSubscriber(_selectedChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MxRadioGroup oldWidget) {
    if (oldWidget.disabled != widget.disabled) {
      oldWidget.disabled?.removeSubscriber(_disabledChanged);
      _disabled = widget.disabled!.value;
      widget.disabled?.addSubscriber(_disabledChanged);
    }

    if (widget.errorText != null) {
      if (oldWidget.errorText != widget.errorText) {
        oldWidget.errorText!.removeSubscriber(_errorTextChanged);
        _errorText = widget.errorText!.value;
        widget.errorText!.addSubscriber(_errorTextChanged);
      }
    }
    if (oldWidget.selected != widget.selected) {
      oldWidget.selected.removeSubscriber(_selectedChanged);
      _selected = widget.selected.value;
      widget.selected.addSubscriber(_selectedChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.disabled != null) {
      widget.disabled?.removeSubscriber(_disabledChanged);
    }

    if (widget.errorText != null) {
      widget.errorText!.removeSubscriber(_errorTextChanged);
    }

    widget.selected.removeSubscriber(_selectedChanged);
    super.dispose();
  }

  void _errorTextChanged() {
    if (widget.errorText != null) {
      setState(() => _errorText = widget.errorText!.value);
    }
  }

  void _selectedChanged() => setState(() => _selected = widget.selected.value);
  void _disabledChanged() =>
      setState(() => _disabled = widget.disabled?.value ?? false);
}
