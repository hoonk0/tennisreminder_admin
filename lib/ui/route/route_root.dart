import 'dart:developer' as Utils;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:tennis_reminder_admin/ui/route/route_login.dart';
import 'package:tennis_reminder_admin/ui/route/route_main.dart';
import 'package:tennisreminder_core/const/value/colors.dart';

import '../../const/static/global.dart';
import '../../const/value/path.dart';

class RouteRoot extends StatefulWidget {
  const RouteRoot({super.key});

  @override
  State<RouteRoot> createState() => _RouteRootState();
}

class _RouteRootState extends State<RouteRoot> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        title: '관리자',
        routerConfig: _goRouter,
        debugShowCheckedModeBanner: false,
        color: colorWhite,
        theme: ThemeData(
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: colorWhite,
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          breakpoints: [
          //  const Breakpoint(start: 0, end: 480, name: keyMobileSmall),
            const Breakpoint(start: 481, end: 850, name: MOBILE),
            const Breakpoint(start: 851, end: 1080, name: TABLET),
            const Breakpoint(start: 1081, end: double.infinity, name: DESKTOP),
          ],
          child: Builder(
            builder: (context) {
              return ResponsiveScaledBox(
                width: ResponsiveValue<double?>(
                  context,
                  defaultValue: null,
                  conditionalValues: [
                //    const Condition.equals(name: keyMobileSmall, value: 480),
                  ],
                ).value,
                child: ClampingScrollWrapper.builder(
                  context,
                  child!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final GoRouter _goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: pathRouteMain,
      builder: (BuildContext context, GoRouterState state) {
        return const RouteMain();
      },
    ),
    GoRoute(
      path: pathRouteLogin,
      builder: (BuildContext context, GoRouterState state) {
        return const RouteLogin();
      },
    ),
  ],
  redirect: (context, state) {
 //   Utils.log.d("fullPath: ${state.fullPath}");

    if (Global.userNotifier.value == null) {
      return pathRouteLogin;
    } else {
      return null;
    }
  },
  initialLocation: pathRouteMain,
);
