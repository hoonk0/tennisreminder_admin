import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';
import '../../const/static/global.dart';
import '../../const/value/data.dart';
import '../../const/value/tab.dart';
import '../component/custom_drawer.dart';
import '../component/logout_bar.dart';
import '../component/menu_category_bar.dart';
import '../tab/0_tab_dash_board.dart';
import '../tab/1_tab_tennis_court.dart';

class RouteMain extends StatefulWidget {
  const RouteMain({super.key});

  @override
  State<RouteMain> createState() => _RouteMainState();
}

class _RouteMainState extends State<RouteMain> {
  final ValueNotifier<bool> vnIsLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

   _getInitialValue();
  }

  @override
  void dispose() {
    vnIsLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SelectionArea(
          child: Scaffold(
            drawer: const CustomDrawer(),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveVisibility(
                  visible: false, //false시 열리지않음
                  visibleConditions: const [Condition.largerThan(name: TABLET)],
                  child: MenuCategoryBar(),
                ),
                Expanded(
                  flex: 4,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          //LogoutBar(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Gaps.v30,
                                      ValueListenableBuilder(
                                        valueListenable: Global.vnRenderTab,
                                        builder: (context, renderTab, child) {
                                          debugPrint('현재 renderTab: $renderTab');
                                          /// 대시보드
                                          if (renderTab == mapCategoryMenuTab[tabDashBoard]) {
                                            return const TabDashBoard();
                                          }

                                          ///테니스코트 관리
                                         else if (renderTab == mapCategoryMenuTab[tabTennisCourt]) {
                                            return const TabTennisCourt();
                                          }

                                          /*
                                          /// 실기문제 관리
                                          else if (renderTab == mapCategoryMenuTab[tabQuestionPractical]) {
                                            return TabQuestionPractical(
                                              vnIsLoading: vnIsLoading,
                                            );
                                          }
                                          /// 심리테스트 관리
                                          else if (renderTab == mapCategoryMenuTab[tabTestPsychological]) {
                                            return TabQuestionPsychology(
                                              vnIsLoading: vnIsLoading,
                                            );
                                          }

                                          /// 건강테스트 관리
                                          else if (renderTab == mapCategoryMenuTab[tabTestHealth]) {
                                            return TabQuestionHealth(
                                              vnIsLoading: vnIsLoading,
                                            );
                                          }

                                          /// 좋은몸 기사 관리
                                          else if (renderTab == mapCategoryMenuTab[tabArticle]) {
                                            return TabArticle(
                                              vnIsLoading: vnIsLoading,
                                            );
                                          }*/

                                          /// 대시보드
                                          else {
                                            return const TabDashBoard();
                                          }
                                        },
                                      ),
                                      Gaps.v30,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: vnIsLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Opacity(
                opacity: 0.7,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        ValueListenableBuilder(
          valueListenable: vnIsLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        '처리 중입니다...',
                        style: TS.s28w700(colorBlue600),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Future<void> _getInitialValue() async {
    final renderTab = Global.localStorage[keyRenderTab];
    final isShowMenuBar = Global.localStorage[keyIsShowMenuBar];

    // Always start on the "코트 관리" (tabTennisCourt) tab
    Global.vnRenderTab.value = tabTennisCourt;

    final isShow = isShowMenuBar != null ? bool.parse(isShowMenuBar) : true;
    Global.vnIsShowMenuBar.value = isShow;
  }
}
