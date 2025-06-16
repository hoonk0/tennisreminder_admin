import 'dart:developer' as Utils;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/value/keys.dart';

import '../component/button_bottom.dart';

// 테니스 코트 정보 수정 다이얼로그
class DialogTennisCourtEdit extends StatefulWidget {
  final ModelCourt court;
  final ValueNotifier<bool> vnIsLoading;

  const DialogTennisCourtEdit({super.key, required this.court, required this.vnIsLoading});

  @override
  State<DialogTennisCourtEdit> createState() => _DialogTennisCourtEditState();
}

class _DialogTennisCourtEditState extends State<DialogTennisCourtEdit> {
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController urlController;
  late final TextEditingController infoController;
  late final TextEditingController latController;
  late final TextEditingController lngController;

  @override
  void initState() {
    super.initState();
    final court = widget.court;
    nameController = TextEditingController(text: court.courtName);
    addressController = TextEditingController(text: court.courtAddress);
    urlController = TextEditingController(text: court.reservationUrl);
    infoController = TextEditingController(text: court.courtInfo);
    latController = TextEditingController(text: court.latitude.toString());
    lngController = TextEditingController(text: court.longitude.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    urlController.dispose();
    infoController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('코트 정보 수정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: '코트명')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: '주소')),
              TextField(controller: urlController, decoration: const InputDecoration(labelText: '예약 링크')),
              TextField(controller: infoController, decoration: const InputDecoration(labelText: '코트 설명')),
              TextField(controller: latController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '위도')),
              TextField(controller: lngController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '경도')),
              const SizedBox(height: 24),
              ButtonBottom(
                title: '저장',
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    widget.vnIsLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection(keyCourt).doc(widget.court.uid).update({
        keyCourtName: nameController.text,
        keyCourtAddress: addressController.text,
        keyReservationUrl: urlController.text,
        keyCourtInfo: infoController.text,
        keyLatitude: double.tryParse(latController.text) ?? 0.0,
        keyLongitude: double.tryParse(lngController.text) ?? 0.0,
      });
      if (mounted) Navigator.of(context).pop();
      Utils.log('[OK] [코트 정보 수정 완료]');
    } catch (e, s) {
      Utils.log('[ERR] [코트 정보 수정 실패]\n$e\n$s');
    } finally {
      widget.vnIsLoading.value = false;
    }
  }
}