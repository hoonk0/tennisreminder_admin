import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class ButtonAnimate extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? margin;
  final bool isActive;
  final void Function()? onTap;

  const ButtonAnimate({
    required this.title,
    this.margin =  EdgeInsets.zero,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        height: 48,
        duration: const Duration(milliseconds: 400),
        margin: margin,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: isActive ? colorBlue600 : colorBlue200),
          color: isActive ? colorBlue600 : colorBlue200,
        ),
        child: Center(
          child: Text(
            title,
            style: const TS.s16w600(colorWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
