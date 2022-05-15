import 'package:flutter/material.dart';
import 'package:miscela/common/all.dart';

import '../reactive/target.dart';
import 'text.dart';

class MxPickerButton extends StatefulWidget {
  const MxPickerButton({
    Key? key,
    required this.iconData,
    required this.label,
    required this.errorText,
    this.disabled,
    required this.value,
    this.onTap,
    this.onClear,
  }) : super(key: key);
  final String label;
  final RxTarget<String?> value;
  final RxTarget<IconData> iconData;
  final RxTarget<String> errorText;
  final RxTarget<bool>? disabled;
  final VoidCallback? onTap, onClear;

  @override
  State<StatefulWidget> createState() => _MxPickerButtonState();
}

class _MxPickerButtonState extends State<MxPickerButton> {
  late bool _disabled;
  late IconData _iconData;
  late String _errorText;

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
              subtitle: MxText(widget.value, ifNull: "Pilih Ikon"),
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
    _errorText = widget.errorText.value;
    widget.errorText.addSubscriber(_errorTextChanged);

    _disabled = widget.disabled?.value ?? false;

    if (widget.disabled != null) {
      widget.disabled?.addSubscriber(_disabledChanged);
    }

    _iconData = widget.iconData.value;
    widget.iconData.addSubscriber(_iconDataChanged);
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
    if (oldWidget.iconData != widget.iconData) {
      oldWidget.iconData.removeSubscriber(_iconDataChanged);
      _iconData = widget.iconData.value;
      widget.iconData.addSubscriber(_iconDataChanged);
    }
    if (oldWidget.errorText != widget.errorText) {
      oldWidget.errorText.removeSubscriber(_errorTextChanged);
      _errorText = widget.errorText.value;
      widget.errorText.addSubscriber(_errorTextChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.disabled != null) {
      widget.disabled?.removeSubscriber(_disabledChanged);
    }
    widget.iconData.removeSubscriber(_iconDataChanged);
    widget.errorText.removeSubscriber(_errorTextChanged);
    super.dispose();
  }

  void _errorTextChanged() {
    setState(() => _errorText = widget.errorText.value);
  }

  void _disabledChanged() =>
      setState(() => _disabled = widget.disabled?.value ?? false);

  void _iconDataChanged() => setState(() => _iconData = widget.iconData.value);
}
