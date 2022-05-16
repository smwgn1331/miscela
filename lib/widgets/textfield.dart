import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../common/string.capital.ext.dart';
import '../common/colors.dart';
import '../reactive/target.dart';
import 'wrapper.dart';

class MxTextField extends StatefulWidget {
  const MxTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.toggleVisible,
    this.textInputType,
    this.textInputAction,
    this.disabled,
    this.prefixIcon,
    this.autofocus = false,
  }) : super(key: key);
  final RxTarget<String>? errorText;
  final RxTarget<bool>? disabled;
  final ValueSetter? onChanged, onSubmitted;
  final ValueSetter? toggleVisible;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? label;
  final bool obscureText, autofocus;
  final IconData? prefixIcon;

  @override
  State<StatefulWidget> createState() => _MxTextFieldState();
}

class _MxTextFieldState extends State<MxTextField> {
  late String errorText;
  late bool masked, disabled;

  @override
  build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.65 : 1,
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: MxColors.slate[500]),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: widget.errorText?.value.isNotEmpty == true
                          ? (MxColors.red[600])!
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    if (widget.errorText?.value.isEmpty == true)
                      const BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 0,
                          blurStyle: BlurStyle.outer,
                          color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ]),
              child: TextField(
                autofocus: widget.autofocus,
                controller: widget.controller,
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                obscureText: masked,
                enabled: !disabled,
                cursorColor: errorText.isNotEmpty ? MxColors.red[600] : null,
                decoration: InputDecoration(
                  enabled: widget.disabled?.value != true,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.errorText?.value.isNotEmpty == true)
                        Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(
                                right: 10), // button width and height
                            child: ClipOval(
                                child: Material(
                                    child: Icon(MdiIcons.alertCircle,
                                        color: MxColors.red[600])))),
                      if (widget.obscureText)
                        Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(
                                right: 10), // button width and height
                            child: ClipOval(
                                child: Material(
                                    child: InkWell(
                              onTap: () => setState(
                                  () => masked = !masked), // button pressed
                              child: Icon(
                                  masked != true
                                      ? MdiIcons.eyeOff
                                      : MdiIcons.eye,
                                  color: widget.errorText?.value.isNotEmpty ==
                                          true
                                      ? MxColors.red[600]
                                      : Theme.of(context).colorScheme.primary),
                            )))),
                      Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(
                              right: 10), // button width and height
                          child: ClipOval(
                              child: Material(
                                  child: InkWell(
                            onTap: () {
                              widget.controller.clear();
                              if (widget.onChanged != null) {
                                widget.onChanged!(widget.controller.text);
                              }
                            }, // button pressed
                            child: Icon(MdiIcons.close,
                                color: widget.errorText?.value.isNotEmpty ==
                                        true
                                    ? MxColors.red[600]
                                    : Theme.of(context).colorScheme.primary),
                          )))),
                    ],
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon,
                          color: widget.errorText?.value.isEmpty == true
                              ? Theme.of(context).colorScheme.primary
                              : MxColors.red[600])
                      : null,
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                ),
              ),
            ),
            if (widget.errorText != null)
              MxWrapper(
                rxTarget: widget.errorText!,
                builder: (context, val) => Text(errorText.capitalizeFirst,
                    style: TextStyle(
                        color: MxColors.red[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.errorText != null) {
      errorText = widget.errorText!.value;
      widget.errorText!.addSubscriber(_errorTextChanged);
    }
    disabled = widget.disabled?.value ?? false;
    masked = widget.obscureText;
    widget.disabled?.addSubscriber(_disabledChanged);
  }

  @override
  void didUpdateWidget(MxTextField oldWidget) {
    if (widget.errorText != null) {
      if (oldWidget.errorText != widget.errorText) {
        oldWidget.errorText!.removeSubscriber(_errorTextChanged);
        errorText = widget.errorText!.value;
        widget.errorText!.addSubscriber(_errorTextChanged);
      }
    }
    if (oldWidget.disabled != widget.disabled) {
      oldWidget.disabled?.removeSubscriber(_disabledChanged);
      disabled = widget.disabled?.value ?? false;
      widget.disabled?.addSubscriber(_errorTextChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.errorText != null) {
      widget.errorText!.removeSubscriber(_errorTextChanged);
    }
    widget.disabled?.removeSubscriber(_disabledChanged);
    super.dispose();
  }

  void _errorTextChanged() {
    if (widget.errorText != null) {
      setState(() => errorText = widget.errorText!.value);
    }
  }

  void _disabledChanged() =>
      setState(() => disabled = widget.disabled?.value ?? false);
}
