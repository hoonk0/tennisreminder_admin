import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tennis_reminder_admin/const/value/tab.dart';

const List<String> listCategoryMenu = ['코트관리','건의사항'];

List<IconData> listCategoryIcon = [
  Icons.sports_tennis,
  Icons.mail_outline
];

const Map<String, String> mapCategoryMenuTab = {
  tabTennisCourt: '코트관리',
  tabUserOpinion: '건의사항'
  //tabUser:'유저 관리'

 /* tabQuestionWritten: '필기문제 관리',
  tabQuestionPractical: '실기문제 관리',
  tabTestPsychological: '심리테스트 관리',
  tabTestHealth: '건강테스트 관리',
  tabArticle: '좋은몸 기사 관리',*/
};
