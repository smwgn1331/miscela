import 'package:flutter/material.dart';

import '../common/icons.dart';

class MxCheckBox extends StatelessWidget {
  const MxCheckBox({
    Key? key,
    required this.label,
    this.value,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final dynamic value;
  final bool selected;
  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!selected);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 8),
                width: 24,
                height: 24,
                child: selected
                    ? Center(
                        child: Icon(
                        MdiIcons.check,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: 18,
                      ))
                    : null,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8))),
            Opacity(
              opacity: 1,
              child: Text(
                "Pengeluaran",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
