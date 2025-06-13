import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class CustomDropdown<T> extends DropdownButtonHideUnderline {
  CustomDropdown({
    super.key,
    T? value,
    Widget? hint,
    List<DropdownMenuItem<T>>? items,
    void Function(T?)? onChanged,
  }) : super(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: value,
            hint: hint,
            items: items,
            onChanged: onChanged,
            barrierDismissible: true,
            style: const TS.s16w400(colorGray900),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 10, top: 6, bottom: 6),
              height: 48,
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: colorBlue200),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 0,
              maxHeight: 200,
              openInterval: const Interval(0.1, 0.4),
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: colorBlue200),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        );
}
