import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class StreamWidget extends StatelessWidget {
  final String title;

  const StreamWidget({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: colorGray500,
              size: 30,
            ),
            Gaps.v5,
            Text(
              title,
              style: const TS.s20w600(colorGray500),
            ),
          ],
        ),
      ),
    );
  }
}
