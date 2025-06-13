import 'package:flutter/material.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';
import '../../const/static/global.dart';
import '../../const/value/data.dart';
import '../../const/value/tab.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorPoint,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Global.vnRenderTab.value = tabDashBoard;
           //   Global.localStorage[keyRenderTab] = tabDashBoard;

              Scaffold.of(context).closeDrawer();
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: colorPoint,
              ),
              child: Row(
                children: [
                  InkWell(
                    child: Image.asset(
                      'assets/logos/logo.png',
                      height: 25,
                    ),
                  ),
                  Gaps.h10,
                  Text(
                    '관리자',
                    style: TS.s18w600(colorBlack),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: Global.vnRenderTab,
            builder: (context, renderTab, child) => Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listCategoryMenu.length,
                itemBuilder: (context, index) {
                  String nameOfCategoryMenu = listCategoryMenu[index];
                  IconData iconOfCategoryMenu = listCategoryIcon[index];

                  return _MenuItem(
                    nameOfMenu: nameOfCategoryMenu,
                    iconData: iconOfCategoryMenu,
                    isSelected: renderTab == nameOfCategoryMenu,
                    onTap: () {
                      Global.vnRenderTab.value = listCategoryMenu[index];
                  //    Global.localStorage[keyRenderTab] = listCategoryMenu[index];

                      Scaffold.of(context).closeDrawer();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String nameOfMenu;
  final IconData iconData;
  final bool isSelected;
  final void Function() onTap;

  const _MenuItem({
    required this.nameOfMenu,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 56,
        color: isSelected ? colorBlue600 : Colors.transparent,
        child: Row(
          children: [
            Icon(
              iconData,
              color: isSelected ? colorWhite : colorBlue900,
            ),
            Gaps.h12,
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TS.s16w600(isSelected ? colorWhite : colorBlue900),
              child: Text(nameOfMenu),
            ),
          ],
        ),
      ),
    );
  }
}
