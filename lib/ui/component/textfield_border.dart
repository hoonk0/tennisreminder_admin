import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class TextFieldBorder extends TextField {
  TextFieldBorder({
    super.onChanged,
    super.controller,
    super.inputFormatters,
    super.focusNode,
    super.keyboardType,
    super.obscureText,
    super.expands,
    super.maxLines,
    super.maxLength,
    super.onSubmitted,
    super.onEditingComplete,
    super.textAlign = TextAlign.left,
    super.textInputAction,
    bool super.enabled = true,
    String? hintText,
    Widget? suffix,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Color fillColor = colorWhite,
    String? errorText,
    TextStyle? textStyle = const TS.s16w400(colorGray900),
    TextStyle? hintStyle = const TS.s16w400(colorBlue900),
    String? suffixText,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    TextAlignVertical super.textAlignVertical = TextAlignVertical.center,
    Color colorBorder = colorBlue200,
    super.key,
  }) : super(
          style: textStyle,
          cursorColor: colorBlue600,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            suffix: suffix,
            hintText: hintText,
            hintStyle: hintStyle,
            isDense: true,
            filled: true,
            counterStyle: const TS.s12w400(colorGray500),
            fillColor: fillColor,
            errorText: errorText,
            suffixText: suffixText,
            suffixStyle: const TS.s16w500(colorBlack),
            contentPadding: contentPadding,
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
}
