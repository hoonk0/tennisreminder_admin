import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String? desc;

  const DialogConfirm({
    required this.title,
    this.desc,
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
                style: const TS.s18w600(colorBlack),
                textAlign: TextAlign.center,
              ),
              Builder(
                builder: (context) {
                  if (desc != null) {
                    return Column(
                      children: [
                        Gaps.v6,
                        Text(
                          desc!,
                          style: const TS.s14w500(colorGray600),
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
              _Button(
                onTap: () => _onCancelTap(context),
                title: '확인',
              ),
              Gaps.v30,
            ],
          ),
        ),
      ),
    );
  }

  void _onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _Button extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const _Button({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: colorBlue500,
            ),
            child: Center(
              child: Text(
                title,
                style: const TS.s16w600(colorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
