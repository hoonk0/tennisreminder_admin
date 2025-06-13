import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class ColumnTitleChild extends StatelessWidget {
  final String title;
  final String? desc;
  final Widget child;

  const ColumnTitleChild({
    required this.title,
    required this.child,
    super.key, this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TS.s16w400(colorGray800),
        ),
        if (desc != null) ...[
          Text(
            desc!,
            style: const TS.s14w400(colorGray500),
          ),
          Gaps.v6,
        ],
        Gaps.v6,
        child,
      ],
    );
  }
}
