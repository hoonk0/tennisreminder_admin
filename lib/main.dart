import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tennis_reminder_admin/ui/route/route_root.dart';
import 'package:tennis_reminder_admin/utils/utils.dart';
import 'package:tennisreminder_core/const/model/model_user.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:universal_html/html.dart';
import 'package:url_strategy/url_strategy.dart';

import 'const/static/global.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await _testFirebaseConnection();

  setPathUrlStrategy();

  await initializeDateFormatting();

  await autoLogin();

  runApp(const RouteRoot());
}

Future<void> _testFirebaseConnection() async {
  try {
    await FirebaseFirestore.instance.collection('test_connection').add({'ping': 'pong'});
    debugPrint('✅ Firebase 연결 성공!');
  } catch (e) {
    debugPrint('❌ Firebase 연결 실패: $e');
  }
}

Future<void> autoLogin() async {
  const String appVersion = '1.0.1 (1)';

  String? uid = Global.localStorage[keyUid];
  String password = Global.localStorage[keyPassword] ?? '';

  if (uid != null) {
    await Future.wait([
      FirebaseFirestore.instance.collection(keyUser).where(keyUid, isEqualTo: uid).get(),
   //   FirebaseFirestore.instance.collection(keyVersion).get(),
    ]).then((result) {
      final modelUser = ModelUser.fromJson(result[0].docs.first.data());
     // final modelVersion = ModelVersion.fromJson(result[1].docs.first.data());

      //final String versionOfAdmin = modelVersion.versionOfAdmin;

      /// 로칼 버전
      List<int> localVersionParts = appVersion.split(' ')[0].split('.').map(int.parse).toList();

      int localBuildNumber = int.parse(appVersion.split(' ')[1].replaceAll('(', '').replaceAll(')', ''));

      /// 필요 버전
     // List<int> requiredVersionParts = versionOfAdmin.split(' ')[0].split('.').map(int.parse).toList();

     // int requiredBuildNumber = int.parse(versionOfAdmin.split(' ')[1].replaceAll('(', '').replaceAll(')', ''));

/*      if (Utils.needUpdate(localVersionParts, localBuildNumber, requiredVersionParts, requiredBuildNumber)) {
        Utils.log.d('웹 새로고침');

        window.location.reload();
      }*/

      /// 저장된 패스워드가 비어있거나 서버의 패스워드와 다르면 return => RouteRoot에서 로그인으로 빠짐
      if (password.isEmpty || password != modelUser.pw) {
        return;
      }

      Global.userNotifier.value = modelUser;
    });
  }
}
