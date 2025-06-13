import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';
import 'package:universal_html/html.dart' as html;
import '../../const/static/global.dart';
import '../../const/value/path.dart';
import '../../const/value/tab.dart';
import '../dialog/dialog_cancel_confirm.dart';

class LogoutBar extends StatelessWidget {
  const LogoutBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorGray200)),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
          //  onTap: () => onMenuTap(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              color: Colors.transparent,
              child: const Icon(
                Icons.menu,
                color: colorBlack,
                size: 28,
              ),
            ),
          ),
          Spacer(),

          /// 로그아웃
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => DialogCancelConfirm(
                  title: '로그아웃 하시겠습니까?',
                  onTap: () {
                    Navigator.of(context).pop();

  /*                  Global.localStorage.remove(keyUid);
                    Global.localStorage.remove(keyRenderTab);
                    Global.localStorage.remove(keyIsShowMenuBar);*/

                    Global.userNotifier.value = null;
                    Global.vnRenderTab.value = tabDashBoard;
                    Global.vnIsShowMenuBar.value = true;

                    context.go(pathRouteLogin);
                  },
                ),
              );
            },
            child: ResponsiveVisibility(
              visible: false,
              visibleConditions: const [Condition.largerThan(name: TABLET)],
              replacement: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: colorGray300),
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout,
                    color: colorBlue900,
                    size: 20,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: colorGray300),
                ),
                child: Center(
                  child: Text(
                    '로그아웃',
                    style: TS.s16w400(colorBlue900),
                  ),
                ),
              ),
            ),
          ),
          Gaps.h20,
        ],
      ),
    );
  }
/*
  void onMenuTap(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1080) {
      Scaffold.of(context).openDrawer();
    } else {
      final localStorage = html.window.localStorage;
      localStorage[keyIsShowMenuBar] = (!Global.vnIsShowMenuBar.value).toString();
      Global.vnIsShowMenuBar.value = !Global.vnIsShowMenuBar.value;
    }
  }*/
}
