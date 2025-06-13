/*
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContainerUploadExcel extends StatefulWidget {
  final String uid;
  final void Function(List<ModelQuestionWritten>)? onUploadComplete;
  final ValueNotifier<List<ModelQuestionWritten>> vnQuestionsNotifier;

 ContainerUploadExcel({
    Key? key,
    required this.uid,
    this.onUploadComplete,
    List<ModelQuestionWritten>? initialQuestions,
  })  : vnQuestionsNotifier = ValueNotifier(initialQuestions ?? []),
        super(key: key);

  @override
  _ContainerUploadExcelState createState() => _ContainerUploadExcelState();
}

class _ContainerUploadExcelState extends State<ContainerUploadExcel> {
  // 엑셀 파일을 선택하고 데이터 처리 후 Firestore에 저장하는 함수
  Future<void> uploadExcelToFirestore(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result == null || result.files.single.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 선택이 취소되었습니다.')),
      );
      return;
    }

    final Uint8List fileBytes = result.files.single.bytes!;
    final excel = Excel.decodeBytes(fileBytes);
    final sheet = excel.tables.keys.first;
    final rows = excel.tables[sheet]!.rows;

    final List<ModelQuestionWritten> loadedQuestions = [];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      final uid = FirebaseFirestore.instance.collection(keyQuestionWritten).doc().id;

      int parsedYear = DateTime.now().year; // 기본값: 현재 연도
      final yearStr = row[1]?.value?.toString() ?? '';
      final tempYear = int.tryParse(yearStr);
      if (tempYear != null) {
        parsedYear = tempYear;
      }

      final subjectName = row[0]?.value?.toString() ?? '';
      Subject subject;
      try {
        subject = UtilsEnum.getSubjectFromName(subjectName);
      } catch (e) {
        debugPrint('Invalid subject name: $subjectName, defaulting to sports_education');
        subject = Subject.sports_education;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('잘못된 과목: $subjectName, 스포츠교육학으로 대체')),
        );
      }

      final question = ModelQuestionWritten(
        uid: uid,
        dateCreate: Timestamp.now(),
        dateUpdate: Timestamp.now(),
        year: parsedYear,
        subject: subject,
        questionType: QuestionType.square,
        index: i,
        title: row[2]?.value?.toString() ?? '',
        listModelChoice: [
          for (int j = 3; j <= 7; j++)
            ModelChoiceHasAnswer(
              index: j - 3,
              desc: row[j]?.value?.toString() ?? '',
              isAnswer: row[8]?.value.toString() == (j - 2).toString(),
            )
        ],
        imgUrl: null,
        desc: null,
        explainCorrect: row[9]?.value?.toString() ?? '',
        isCorrect: true,
        selectedIndex: null,
      );

      loadedQuestions.add(question);
    }

    if (loadedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 문제가 없습니다.')),
      );
      return;
    }

    // Firestore에 배치 쓰기로 저장
    final batch = FirebaseFirestore.instance.batch();
    for (final question in loadedQuestions) {
      batch.set(
        FirebaseFirestore.instance.collection(keyQuestionWritten).doc(question.uid),
        question.toJson(),
      );
    }

    try {
      await batch.commit();
      widget.vnQuestionsNotifier.value = loadedQuestions; // UI에 반영

      // 상위 위젯에 데이터 전달
      widget.onUploadComplete?.call(loadedQuestions);

      // 업로드 성공 메시지 표시 (다이얼로그 대신 Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('엑셀 파일이 성공적으로 저장되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  void _onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 문제 목록을 표시하는 부분 (ValueListenableBuilder)
        Text('엑셀 불러오기'),
        // 엑셀 업로드 버튼
        Row(
          children: [
            _Button(
              onTap: () => uploadExcelToFirestore(context),
              title: '엑셀 불러오기',
            ),
            Gaps.h4,
            _Button(
              onTap: () => _onCancelTap(context),
              title: '저장하기',
            ),
          ],
        ),
      ],
    );
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
*/
