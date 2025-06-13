import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennisreminder_core/const/model/model_user.dart';
import 'package:tennisreminder_core/const/value/enum.dart';
import 'package:tennisreminder_core/const/value/gaps.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:universal_html/html.dart' as html;

import '../../const/static/global.dart';
import '../../const/value/path.dart';
import '../../utils/utils.dart';
import '../component/button_animate.dart';
import '../component/textfield_border.dart';
import '../dialog/dialog_confirm.dart';

class RouteLogin extends StatefulWidget {
  const RouteLogin({super.key});

  @override
  State<RouteLogin> createState() => _RouteLoginState();
}

class _RouteLoginState extends State<RouteLogin> {
  final ValueNotifier<bool> vnSetState = ValueNotifier(false);
  final TextEditingController tecId = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();

  @override
  void dispose() {
    vnSetState.dispose();
    tecId.dispose();
    tecPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ResponsiveConstraints(
          constraint: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
/*                Image.asset(
                  'assets/logos/logo.png',
                  width: 150,
                ),*/
                Gaps.v64,
                SizedBox(
                  height: 48,
                  child: TextFieldBorder(
                    controller: tecId,
                    textInputAction: TextInputAction.go,
                    hintText: '아이디',
                    onChanged: (_) {
                      vnSetState.value = !vnSetState.value;
                    },
                    onSubmitted: (_) {
                      _login();
                    },
                  ),
                ),
                Gaps.v10,
                SizedBox(
                  height: 48,
                  child: TextFieldBorder(
                    controller: tecPassword,
                    textInputAction: TextInputAction.go,
                    hintText: '비밀번호',
                    obscureText: true,
                    onChanged: (_) {
                      vnSetState.value = !vnSetState.value;
                    },
                    onSubmitted: (_) {
                      _login();
                    },
                  ),
                ),
                Gaps.v24,
                ValueListenableBuilder(
                  valueListenable: vnSetState,
                  builder: (context, _, child) => ButtonAnimate(
                    title: '로그인',
                    isActive: tecId.text.isNotEmpty && tecPassword.text.isNotEmpty,
                    onTap: _login,
                  ),
                ),
                Gaps.v24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (tecId.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          title: '아이디를 입력해주세요.',
        ),
      );
      return;
    }

    if (tecPassword.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          title: '비밀번호를 입력해주세요',
        ),
      );
      return;
    }

    final passwordHash = tecPassword.text;

    FirebaseFirestore.instance
        .collection(keyUser)
        .where(keyEmail, isEqualTo: tecId.text)
        .where(keyPassword, isEqualTo: passwordHash)
        .get()
        .then((result) {
      /// 아이디 혹은 비민번호가 틀렸을 경우 return
      if (result.docs.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => const DialogConfirm(
            title: '아이디 혹은 비밀번호를 확인해주세요',
          ),
        );
        return;
      }

      /// 로그인 Go
      else {
        final ModelUser modelUser = ModelUser.fromJson(result.docs.first.data());

        /// admin 이 아닐 경우 return
        if (modelUser.userType != UserType.admin) {
          showDialog(
            context: context,
            builder: (context) => const DialogConfirm(
              title: '관리자로 등록된 아이디만\n로그인이 가능합니다.',
            ),
          );
          return;
        }

        /// 로그인 Go(route_main으로)
        else {
          Global.userNotifier.value = modelUser;
          Utils.toast(context: context, desc: '관리자님 반갑습니다.');

          final localStorage = html.window.localStorage;
          localStorage[keyUid] = modelUser.uid;
          localStorage[keyPassword] = passwordHash;

          context.go(pathRouteMain);
        }
      }
    });
  }
}
