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
    this.fluid = false,
    this.style,
  }) : super(key: key);
  final String label;
  final TextStyle? style;
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
    return InkWell(
      child: Opacity(
        opacity: widget.disabled?.value == true ? 0.65 : 1,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: widget.fluid ? MainAxisSize.max : MainAxisSize.min,
            children: [
              loadingIcon
                  ? Container(
                      margin: const EdgeInsets.only(right: 7),
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: widget.color ??
                              Theme.of(context).colorScheme.onPrimary))
                  : widget.prefixIcon != null
                      ? Container(
                          child: Icon(widget.prefixIcon,
                              size: 13,
                              color: widget.color ??
                                  Theme.of(context).colorScheme.onPrimary),
                          width: 13,
                          height: 13,
                          margin: const EdgeInsets.only(right: 7))
                      : Container(),
              Text(widget.label,
                  style: widget.style ??
                      TextStyle(
                          color: widget.color ??
                              Theme.of(context).colorScheme.onPrimary)),
              if (widget.fluid)
                Container(
                    width: 13,
                    height: 13,
                    margin: const EdgeInsets.only(left: 7))
            ],
          ),
        ),
      ),
      onTap: widget.disabled?.value == true ? null : widget.onPressed,
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
