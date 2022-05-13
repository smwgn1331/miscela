import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../common/icons.dart';
import '../core/miscela.dart';
import '../services/navigation.dart';

class MxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MxAppBar({
    Key? key,
    required this.titleText,
    this.actions,
    this.stuck = false,
  }) : super(key: key);
  final String titleText;
  final List<Widget>? actions;
  final bool stuck;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: !stuck
            ? IconButton(
                onPressed: Miscela.svc<Navigation>().back,
                icon: Icon(
                  MdiIcons.arrowLeft,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ))
            : null,
        backgroundColor: MxColors.transparent,
        actions: actions,
        title: Text(titleText,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold)));
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
