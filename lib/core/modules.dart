import 'package:flutter/widgets.dart';

abstract class MxModules {
  final IconData iconData;
  final String title;

  MxModules({
    required this.title,
    required this.iconData,
  });
}
