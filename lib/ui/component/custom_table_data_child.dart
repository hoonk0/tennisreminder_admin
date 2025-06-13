import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';

class CustomTableDataChild extends StatelessWidget {
  final int flex;
  final bool isRowLast;
  final double height;
  final Widget child;

  const CustomTableDataChild({
    required this.flex,
    this.isRowLast = false,
    this.height = 48,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        height: height,
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border(
            right: isRowLast ? BorderSide.none : const BorderSide(color: colorBlue200),
            bottom: const BorderSide(color: colorBlue200),
          ),
        ),
        child: child,
      ),
    );
  }
}
