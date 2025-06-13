import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class CustomTableHeader extends StatelessWidget {
  final String title;
  final int flex;
  final bool isLast;
  final TextOverflow textOverflow;
  final double height;

  const CustomTableHeader({
    required this.title,
    required this.flex,
    this.textOverflow = TextOverflow.visible,
    this.isLast = false,
    this.height = 48,
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
          color: colorBlue50,
          border: Border(
            right: isLast ? BorderSide.none : const BorderSide(color: colorBlue200),
            bottom:  const BorderSide(color: colorBlue200),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TS.s14w500(colorBlue900),
            overflow: textOverflow,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
