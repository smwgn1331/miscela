import 'package:flutter/material.dart';
import 'package:miscela/common/all.dart';

import '../reactive/target.dart';

class MxPickerButton<T extends Object> extends StatefulWidget {
  const MxPickerButton({
    Key? key,
    this.disabled,
    this.rxIconData,
    this.iconData,
    required this.label,
    required this.placeholder,
    this.errorText,
    this.display,
    required this.value,
    this.onTap,
    this.onClear,
  }) : super(key: key);
  final String label, placeholder;
  final RxTarget<dynamic> value;
  final RxTarget<String?>? display;
  final RxTarget<IconData>? rxIconData;
  final IconData? iconData;
  final RxTarget<String>? errorText;
  final RxTarget<bool>? disabled;
  final VoidCallback? onTap, onClear;

  @override
  State<StatefulWidget> createState() => _MxPickerButtonState();
}

class _MxPickerButtonState extends State<MxPickerButton> {
  late bool _disabled;
  late IconData _iconData;
  late String _errorText;
  dynamic _value;
  String? _display;

  @override
  build(BuildContext context) {
    return Opacity(
      opacity: _disabled ? 0.65 : 1,
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.all(0),
              leading: CircleAvatar(
                child: Icon(
                  _iconData,
                ),
                backgroundColor: _errorText.isNotEmpty
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                widget.label.capitalize,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: MxColors.slate[500]),
              ),
              subtitle: Text(
                _display ?? _value ?? widget.placeholder,
              ),
              trailing: _errorText.isNotEmpty
                  ? Icon(
                      MdiIcons.alertCircle,
                      color: Theme.of(context).colorScheme.error,
                    )
                  : widget.value.value == null
                      ? Icon(
                          MdiIcons.arrowDownDropCircle,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : IconButton(
                          onPressed: widget.onClear,
                          icon: const Icon(MdiIcons.close)),
              onTap: !_disabled ? widget.onTap : null,
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
    super.initState();
    _errorText = widget.errorText?.value ?? "";
    if (widget.errorText != null) {
      widget.errorText?.addSubscriber(_errorTextChanged);
    }

    _value = widget.value.value;
    widget.value.addSubscriber(_valueChanged);

    _display = widget.display?.value;
    if (widget.display != null) {
      widget.value.addSubscriber(_displayTextChanged);
    }

    _disabled = widget.disabled?.value ?? false;
    if (widget.disabled != null) {
      widget.disabled?.addSubscriber(_disabledChanged);
    }

    _iconData =
        widget.rxIconData?.value ?? widget.iconData ?? MdiIcons.formDropdown;
    if (widget.rxIconData != null) {
      widget.rxIconData?.addSubscriber(_iconDataChanged);
    }
  }

  @override
  void didUpdateWidget(MxPickerButton oldWidget) {
    if (widget.disabled != null) {
      if (oldWidget.disabled != widget.disabled) {
        oldWidget.disabled?.removeSubscriber(_disabledChanged);
        _disabled = widget.disabled!.value;
        widget.disabled?.addSubscriber(_disabledChanged);
      }
    }

    if (widget.rxIconData != null) {
      if (oldWidget.rxIconData != widget.rxIconData) {
        oldWidget.rxIconData?.removeSubscriber(_iconDataChanged);
        _iconData = widget.rxIconData!.value;
        widget.rxIconData?.addSubscriber(_iconDataChanged);
      }
    }

    if (oldWidget.value != widget.value) {
      oldWidget.value.removeSubscriber(_valueChanged);
      _value = widget.value.value;
      widget.value.addSubscriber(_valueChanged);
    }

    if (widget.display != null) {
      if (oldWidget.display != widget.display) {
        oldWidget.display?.removeSubscriber(_displayTextChanged);
        _display = widget.display!.value;
        widget.display?.addSubscriber(_displayTextChanged);
      }
    }

    if (widget.errorText != null) {
      if (oldWidget.errorText != widget.errorText) {
        oldWidget.errorText?.removeSubscriber(_errorTextChanged);
        _errorText = widget.errorText!.value;
        widget.errorText?.addSubscriber(_errorTextChanged);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.value.removeSubscriber(_valueChanged);

    if (widget.display != null) {
      widget.display?.removeSubscriber(_displayTextChanged);
    }

    if (widget.disabled != null) {
      widget.disabled?.removeSubscriber(_disabledChanged);
    }
    if (widget.disabled != null) {
      widget.rxIconData?.removeSubscriber(_iconDataChanged);
    }
    if (widget.errorText != null) {
      widget.errorText?.removeSubscriber(_errorTextChanged);
    }
    super.dispose();
  }

  void _valueChanged() => setState(() => _value = widget.value.value);

  void _displayTextChanged() {
    if (widget.display != null) {
      setState(() => _display = widget.display?.value ?? "");
    }
  }

  void _errorTextChanged() {
    if (widget.errorText != null) {
      setState(() => _errorText = widget.errorText?.value ?? "");
    }
  }

  void _disabledChanged() =>
      setState(() => _disabled = widget.disabled?.value ?? false);

  void _iconDataChanged() => setState(() => _iconData =
      widget.rxIconData?.value ?? widget.iconData ?? MdiIcons.formDropdown);
}
