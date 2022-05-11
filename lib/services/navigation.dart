import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../widgets/widgets.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future to(String path, {Object? arguments}) async =>
      Navigator.of(navigatorKey.currentState!.context)
          .pushNamed(path, arguments: arguments);

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
          bool backgroundDismiss = true}) async =>
      showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) =>
              dialog ??
              AlertDialog(
                title: title,
                content: content,
                actions: actions ??
                    [
                      confirmButton ??
                          MxButton(
                            label: "Ok",
                            fluid: false,
                            backgroundColor: MxColors.indigo[500],
                            color: MxColors.white,
                            onPressed: back,
                          )
                    ],
              ));
}
