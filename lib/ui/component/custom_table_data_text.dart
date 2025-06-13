import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class CustomTableDataText extends StatelessWidget {
  final String content;
  final int flex;
  final String? questionUid; // Firestore UID는 String이므로 String?로 수정
  final bool isRowLast;
  final double height;
  final TextOverflow textOverflow;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? padding;
  final TextStyle textStyle;

  const CustomTableDataText({
    required this.content,
    required this.flex,
    this.questionUid, // 선택적 매개변수로 변경
    this.isRowLast = false,
    this.height = 48,
    this.textOverflow = TextOverflow.visible,
    this.alignment = Alignment.center,
    this.textAlign = TextAlign.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 2),
    this.textStyle = const TS.s14w400(colorGray900),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: padding,
        height: height,
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border(
            right: isRowLast ? BorderSide.none : const BorderSide(color: colorBlue200),
            bottom: const BorderSide(color: colorBlue200),
          ),
        ),
        child: Align(
          alignment: alignment,
          child: Text(
            content,
            style: textStyle,
            overflow: textOverflow,
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}