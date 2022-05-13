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
      Navigator.of(navigatorKey.currentState!.context).pop(result ?? false);

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
          Color? confirmButtonBackgroundColor,
          Color? confirmButtonColor,
          MxButton? cancelButton,
          String? cancelButtonText,
          TextStyle? cancelButtonTextStyle,
          IconData? cancelButtonIcon,
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
                actions: actions ??
                    [
                      if (!hideCancelButton)
                        cancelButton ??
                            MxButton(
                                label: cancelButtonText ?? "Cancel",
                                style: cancelButtonTextStyle,
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
                                style: confirmButtonTextStyle,
                                backgroundColor: confirmButtonBackgroundColor ??
                                    Theme.of(navigatorKey.currentState!.context)
                                        .colorScheme
                                        .primary,
                                color: confirmButtonColor,
                                prefixIcon: confirmButtonIcon,
                                onPressed: () => back(result: true))
                    ],
              ),
          context: navigatorKey.currentState!.context);

  static parseRoutes(Map<String, dynamic> routes) =>
      routes.map<String, Widget Function(BuildContext)>(
          (key, value) => MapEntry(key, (context) => value));
}
