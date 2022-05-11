import 'package:flutter/material.dart';

import '../reactive/target.dart';

class MxButton extends StatefulWidget {
  const MxButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loadingIcon,
    this.disabled,
    this.backgroundColor,
    this.prefixIcon,
    this.spinnerActiveColor,
    this.spinnerBackgroundColor,
    this.prefixIconColor,
    this.color,
    this.fluid = true,
  }) : super(key: key);
  final String label;
  final RxTarget<bool>? disabled, loadingIcon;
  final VoidCallback onPressed;
  final Color? backgroundColor,
      spinnerActiveColor,
      spinnerBackgroundColor,
      prefixIconColor,
      color;
  final IconData? prefixIcon;
  final bool fluid;

  @override
  State<MxButton> createState() => _MxButtonState();
}

class _MxButtonState extends State<MxButton> {
  late bool disabled, loadingIcon;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: widget.fluid ? MainAxisSize.max : MainAxisSize.min,
        children: [
          loadingIcon
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator())
              : widget.prefixIcon != null
                  ? Icon(widget.prefixIcon)
                  : const SizedBox(),
          Text(widget.label),
          const SizedBox()
        ],
      ),
      onPressed: widget.onPressed,
    );
  }

  @override
  void initState() {
    disabled = widget.disabled?.value ?? false;
    loadingIcon = widget.loadingIcon?.value ?? false;
    widget.disabled?.addSubscriber(_disabledChanged);
    widget.loadingIcon?.addSubscriber(_loadingIconChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MxButton oldWidget) {
    if (oldWidget.disabled != widget.disabled) {
      oldWidget.disabled?.removeSubscriber(_disabledChanged);
      disabled = widget.disabled?.value ?? false;
      widget.disabled?.addSubscriber(_disabledChanged);
    }
    if (oldWidget.loadingIcon != widget.loadingIcon) {
      oldWidget.loadingIcon?.removeSubscriber(_disabledChanged);
      loadingIcon = widget.loadingIcon?.value ?? true;
      widget.loadingIcon?.addSubscriber(_loadingIconChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.disabled?.removeSubscriber(_disabledChanged);
    widget.loadingIcon?.removeSubscriber(_loadingIconChanged);
    super.dispose();
  }

  void _disabledChanged() =>
      setState(() => disabled = widget.disabled?.value ?? false);
  void _loadingIconChanged() =>
      setState(() => loadingIcon = widget.loadingIcon?.value ?? false);
}
