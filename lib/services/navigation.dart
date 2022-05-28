import 'package:flutter/material.dart';

import '../widgets/all.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future to(String path, {Object? arguments}) async =>
      Navigator.of(navigatorKey.currentState!.context)
          .pushNamed(path, arguments: arguments);

  Future toPage(Widget page) async =>
      Navigator.of(navigatorKey.currentState!.context)
          .push(MaterialPageRoute(builder: (context) => page));

  back({dynamic result}) =>
      Navigator.of(navigatorKey.currentState!.context).pop(result);

  Future replaceWith(String path, {Object? arguments}) async =>
      Navigator.of(navigatorKey.currentState!.context)
          .pushReplacementNamed(path, arguments: arguments);

  Future replaceAllWith(String path, {Object? arguments}) async =>
      Navigator.of(navigatorKey.currentState!.context).pushNamedAndRemoveUntil(
          path, (route) => false,
          arguments: arguments);
  Future showModal(
          {Text? title,
          AlertDialog? dialog,
          Widget? content,
          List<Widget>? actions,
          MxButton? confirmButton,
          String? confirmButtonText,
          TextStyle? confirmButtonTextStyle,
          IconData? confirmButtonIcon,
          Color? confirmButtonIconColor,
          Color? confirmButtonBackgroundColor,
          Color? confirmButtonColor,
          MxButton? cancelButton,
          String? cancelButtonText,
          TextStyle? cancelButtonTextStyle,
          IconData? cancelButtonIcon,
          Color? cancelButtonIconColor,
          Color? cancelButtonBackgroundColor,
          Color? cancelButtonColor,
          bool hideCancelButton = false,
          bool hideConfirmButton = false,
          bool backgroundDismiss = true}) async =>
      showDialog(
          builder: (ctx) =>
              dialog ??
              AlertDialog(
                title: title,
                content: content,
                contentPadding: const EdgeInsets.all(0.0),
                actions: actions ??
                    [
                      if (!hideCancelButton)
                        cancelButton ??
                            MxButton(
                                label: cancelButtonText ?? "Cancel",
                                textStyle: cancelButtonTextStyle,
                                backgroundColor: cancelButtonBackgroundColor ??
                                    Theme.of(navigatorKey.currentState!.context)
                                        .colorScheme
                                        .secondary,
                                color: cancelButtonColor,
                                prefixIcon: cancelButtonIcon,
                                onPressed: () => back(result: false)),
                      if (!hideConfirmButton)
                        confirmButton ??
                            MxButton(
                                label: confirmButtonText ?? "Confirm",
                                textStyle: confirmButtonTextStyle,
                                backgroundColor: confirmButtonBackgroundColor ??
                                    Theme.of(navigatorKey.currentState!.context)
                                        .colorScheme
                                        .primary,
                                color: confirmButtonColor,
                                iconColor: confirmButtonIconColor,
                                prefixIcon: confirmButtonIcon,
                                onPressed: () => back(result: true))
                    ],
              ),
          context: navigatorKey.currentState!.context);

  ScaffoldFeatureController snackBar(
    Widget content, {
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    return ScaffoldMessenger.of(navigatorKey.currentState!.context)
        .showSnackBar(SnackBar(
      content: content,
      action: action,
      backgroundColor: backgroundColor,
    ));
  }

  static parseRoutes(Map<String, dynamic> routes) =>
      routes.map<String, Widget Function(BuildContext)>(
          (key, value) => MapEntry(key, (context) => value));
}
