import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class ButtonBottom extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final Color colorBg;
  final TextStyle textStyle;

  const ButtonBottom({
    required this.title,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.colorBg = colorBlue600,
    this.textStyle = const TS.s16w600(colorWhite),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: 48,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: colorBg,
        ),
        child: Center(
          child: Text(
            title,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
