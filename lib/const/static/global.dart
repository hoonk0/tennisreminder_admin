import 'package:flutter/cupertino.dart';
import 'package:tennisreminder_core/const/model/model_user.dart';
import 'package:universal_html/html.dart' as html;
import '../../ui/component/custom_throttler.dart';
import '../value/tab.dart';

class Global {
  /// 로그인한 유저
  static final ValueNotifier<ModelUser?> userNotifier = ValueNotifier(null);

  /// local storage
  static final localStorage = html.window.localStorage;

  /// category menu 관련 -> 보여줄 tab
  static final ValueNotifier<String> vnRenderTab = ValueNotifier(tabDashBoard);

  /// category menu 보임/숨김
  static final ValueNotifier<bool> vnIsShowMenuBar = ValueNotifier(true);

  /// throttler
  static final CustomThrottler throttler = CustomThrottler(milliseconds: 1000);


/*  static  List<ModelQuestionWritten> vnListModelQuestionWritten = [];
  static  List<ModelQuestionTest> vnListModelQuestionPsychology = [];
  static  List<ModelQuestionTest> vnListModelQuestionHealth = [];
  static  List<ModelQuestionPractical> vnListModelQuestionPractical = [];*/
}
