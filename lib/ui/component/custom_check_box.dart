import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tennisreminder_core/const/value/colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isSelected;

  const CustomCheckBox({
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 20,
      height: 20,
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isSelected ? colorBlue300 : colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: isSelected ? colorBlue300 : colorBlue300),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1 : 0,
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.check,
            color: colorWhite,
            size: 12,
          ),
        ),
      ),
    );
  }
}
