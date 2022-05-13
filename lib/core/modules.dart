import 'package:flutter/widgets.dart';

import 'controller.dart';

abstract class MxModules {
  final IconData iconData;
  final MxController? mxController;
  final String title;

  MxModules({
    required this.title,
    required this.iconData,
    this.mxController,
  });
}
