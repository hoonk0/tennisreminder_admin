import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class BoxBorderAll extends StatelessWidget {
  final String title;
  final Color colorTitle;
  final void Function()? onTap;
  final bool isExpanded;

  const BoxBorderAll({
    required this.title,
    required this.colorTitle,
    required this.onTap,
    this.isExpanded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: colorBlue900),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TS.s16w400(colorTitle),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
