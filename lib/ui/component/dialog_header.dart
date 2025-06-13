import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart' show colorGray900, colorWhite;
import 'package:tennisreminder_core/const/value/text_style.dart';

class DialogHeader extends StatelessWidget {
  final String title;

  const DialogHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.close,
            color: colorWhite,
          ),
          Text(
            title,
            style: const TS.s18w600(colorGray900),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              color: colorGray900,
            ),
          ),
        ],
      ),
    );
  }
}
