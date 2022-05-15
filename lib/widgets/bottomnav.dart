import 'package:flutter/material.dart';
import 'package:miscela/miscela.dart';

class MxBottomNavigationBar extends StatelessWidget {
  const MxBottomNavigationBar({
    Key? key,
    required this.routes,
    required PageController controller,
    required Rx<int> currentIndex,
  })  : _controller = controller,
        _currentIndex = currentIndex,
        super(key: key);

  final List<MxModules> routes;
  final PageController _controller;
  final Rx<int> _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: routes.map((i) {
              int itemIndex = routes.indexWhere((e) => e == i);
              return Material(
                  child: InkWell(
                      onTap: () => _controller.jumpToPage(itemIndex),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(i.iconData,
                            color: itemIndex == _currentIndex.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary),
                        Text(i.title,
                            style: TextStyle(
                                color: itemIndex == _currentIndex.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                                fontWeight: itemIndex == _currentIndex.value
                                    ? FontWeight.bold
                                    : FontWeight.w500))
                      ])));
            }).toList()));
  }
}
