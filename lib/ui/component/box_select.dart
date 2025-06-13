import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class BoxSelect extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function()? onTap;

  const BoxSelect({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? colorBlue300 : colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: isSelected ? colorBlue300 : colorBlue200),
        ),
        child: Center(
          child: Text(
            title,
            style: TS.s16w500(isSelected ? colorWhite : colorGray600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
