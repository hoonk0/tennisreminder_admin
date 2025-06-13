import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tennisreminder_core/const/value/colors.dart' show colorBlack, colorWhite;
import 'package:tennisreminder_core/const/value/text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/component/custom_toast.dart';

class Utils {
  /// 로그 찍기
  static final log = Logger(printer: PrettyPrinter(methodCount: 1));

  /// 숫자 쉼표 포맷
  static final number = NumberFormat("#,###");

  static void toast({
    required BuildContext context,
    required String desc,
    int duration = 1200,
    ToastGravity toastGravity = ToastGravity.CENTER,
  }) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
      decoration: const BoxDecoration(
        color: colorBlack,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        desc,
        style: const TS.s16w500(colorWhite),
        textAlign: TextAlign.center,
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: toastGravity,
      isDismissable: true,
      toastDuration: Duration(milliseconds: duration),
    );
  }

  /// 년월일만 반환
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// 년월만 반환
  static DateTime dateMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// 핸드폰번호에 '-' 넣기
  static String formatPhoneNumber(String phoneNumber) {
    // 길이가 11이고, 숫자만 포함된 경우에만 형식을 변경
    if (RegExp(r'^\d{11}$').hasMatch(phoneNumber)) {
      // 예: 01012345678 => 010-1234-5678
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
    } else {
      // 그 외의 경우, 입력값 그대로 반환
      return phoneNumber;
    }
  }

  /// padLeft 3자리
  static String padLeftThree(int number) {
    String result = '$number';

    if (number < 100) {
      result = number.toString().padLeft(3, '0');
    }

    return result;
  }

  /// 날짜 포맷 .
  static String formatDateDot(DateTime dateTime) {
    return DateFormat('yyyy. MM. dd.').format(dateTime);
  }

  /// 날짜 포맷
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyMMdd').format(dateTime);
  }

  /// 날짜 포맷(주문)
  static String formatDateOrder(DateTime dateTime) {
    return DateFormat('yy.MM.dd HH:mm').format(dateTime);
  }

  /// 어플 업데이트 여부
  static bool needUpdate(
    List<int> localVersionParts,
    int localBuildNumber,
    List<int> requiredVersionParts,
    int requiredBuildNumber,
  ) {
    Utils.log.d("localVersionParts : $localVersionParts\n"
        "localBuildNumber : $localBuildNumber\n"
        "requiredVersionParts : $requiredVersionParts\n"
        "requiredBuildNumber : $requiredBuildNumber\n");

    for (int i = 0; i < requiredVersionParts.length; i++) {
      if (localVersionParts[i] < requiredVersionParts[i]) {
        return true; // 로컬 버전이 필요한 버전보다 낮음
      } else if (localVersionParts[i] > requiredVersionParts[i]) {
        return false; // 로컬 버전이 필요한 버전보다 높음
      }
    }

    // 메이저, 마이너, 패치 버전이 모두 동일하다면 빌드 번호를 확인
    if (localBuildNumber < requiredBuildNumber) {
      return true; // 로컬 빌드 번호가 필요한 빌드 번호보다 낮음
    }

    return false; // 로컬 버전이 필요한 버전과 동일하거나 높음
  }

  /// 사진 이미지 로드
  static void viewImg({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        webOnlyWindowName: '_blank',
      );
    } else {
      throw 'Could not launch $url';
    }
  }

}
