import 'package:flutter/widgets.dart';

import 'controller.dart';

abstract class Modules {
  final IconData iconData;
  final MxController? mxController;
  final String title;

  Modules({
    required this.title,
    required this.iconData,
    this.mxController,
  });
}
