import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';

class StreamLoading extends StatelessWidget {
  const StreamLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 4,
      child: Center(
        child: CircularProgressIndicator(
          color: colorBlue600,
        ),
      ),
    );
  }
}
