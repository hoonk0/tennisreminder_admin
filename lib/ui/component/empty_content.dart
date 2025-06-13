import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class EmptyContent extends StatelessWidget {
  final String title;

  const EmptyContent({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: colorGray300)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: colorGray500,
              size: 25,
            ),
            Gaps.v5,
            Text(
              title,
              style: const TS.s16w500(colorGray500),
            ),
          ],
        ),
      ),
    );
  }
}
