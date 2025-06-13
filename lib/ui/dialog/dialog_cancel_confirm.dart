import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class DialogCancelConfirm extends StatelessWidget {
  final String title;
  final String? desc;
  final void Function()? onTap;

  const DialogCancelConfirm({
    required this.title,
    this.desc,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: colorBlack.withValues(alpha: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ResponsiveConstraints(
        constraint: const BoxConstraints(maxWidth: 700),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: colorWhite,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.v40,
              Text(
                title,
                style: const TS.s16w600(colorBlack),
                textAlign: TextAlign.center,
              ),
              Builder(
                builder: (context) {
                  if (desc != null) {
                    return Column(
                      children: [
                        Gaps.v10,
                        Text(
                          desc!,
                          style: const TS.s15w400(colorGray600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Gaps.v35,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Button(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: '취소',
                    colorTitle: colorGray600,
                    colorBg: colorWhite,
                    colorBorder: colorBlue200,
                  ),
                  Gaps.h10,
                  _Button(
                    onTap: onTap,
                    title: '확인',
                    colorTitle: colorWhite,
                    colorBg: colorBlue600,
                    colorBorder: colorBlue600,
                    isConfirm: true,
                  ),
                ],
              ),
              Gaps.v30,
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String title;
  final Color colorTitle;
  final Color colorBg;
  final Color colorBorder;
  final void Function()? onTap;
  final bool isConfirm;

  const _Button({
    required this.title,
    required this.colorTitle,
    required this.colorBg,
    required this.colorBorder,
    required this.onTap,
    this.isConfirm = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isConfirm) {
      return Focus(
        child: KeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              if (onTap != null) {
                onTap!();
              }
            }
          },
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                color: colorBg,
                border: Border.all(color: colorBorder),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TS.s16w600(colorTitle),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: colorBg,
            border: Border.all(color: colorBorder),
          ),
          child: Center(
            child: Text(
              title,
              style: TS.s16w600(colorTitle),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
