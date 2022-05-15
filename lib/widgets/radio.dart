import 'package:flutter/material.dart';
import 'package:miscela/miscela.dart';

class MxRadio extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool selected;
  final ValueChanged onChanged;
  const MxRadio({
    Key? key,
    required this.value,
    required this.label,
    this.selected = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MxLog.info("Radio Tap: $value");
        onChanged(value);
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
              decoration: BoxDecoration(
                  color: MxColors.transparent,
                  border: Border.all(
                    width: selected ? 8 : 1,
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12)),
            ),
            Opacity(
              opacity: selected ? 1 : 0.65,
              child: Text(
                label,
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
