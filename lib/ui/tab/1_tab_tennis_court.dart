import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/model/model_court_reservation.dart';
import 'package:tennisreminder_core/const/value/enum.dart';
import 'package:tennisreminder_core/const/value/keys.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

import '../../utils/utils.dart';
import '../component/button_bottom.dart';
import '../component/column_title_child.dart';
import '../dialog/dialog_cancel_confirm.dart';
import '../dialog/dialog_tennis_court_edit.dart';




class TabTennisCourt extends StatefulWidget {
  final ValueNotifier<bool> vnIsLoading;

  const TabTennisCourt({super.key, required this.vnIsLoading});

  @override
  State<TabTennisCourt> createState() => _TabTennisCourtState();
}

class _TabTennisCourtState extends State<TabTennisCourt> {
  // Removed vnImgUrl from here to avoid shared state between multiple dialogs

  @override
  Widget build(BuildContext context) {
    final headers = ['작성일자', '코트명', '주소', '예약 링크', '관리'];
    final flexes = [3, 3, 5, 5, 2];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _uploadCourtExcel,
              child: const Text('엑셀 업로드'),
            ),
          ),
          SizedBox(height: 8),
/*          ElevatedButton(
            onPressed: () async {
              final newDoc = {
                keyCourtName: '샘플 코트1111',
                keyCourtAddress: '서울특별시 강남구 역삼동',
                keyCourtInfo: '테스트용 코트입니다.',
                keyReservationUrl: 'https://samplecourt.com',
                keyLatitude: 37.498095,
                keyLongitude: 127.027610,
                keyDateCreate: Timestamp.now(),
                keyLikedUserUids: [],
                keyImageUrls: [],
              };
              final docRef = await FirebaseFirestore.instance.collection(keyCout).add(newDoc);
            },
            child: const Text('샘플 코트 등록'),
          ),*/
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(keyCourt)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('등록된 코트가 없습니다.'));
              }


              final docs = snapshot.data!.docs;
              final courts = docs.map((doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  return ModelCourt.fromJson({
                    ...data,
                    keyUid: doc.id,
                  });
                } catch (e, stack) {
                  final data = doc.data() as Map<String, dynamic>;
                  return null;
                }
              }).whereType<ModelCourt>().toList();
              // Sort courts by courtName before displaying
              courts.sort((a, b) => a.courtName.compareTo(b.courtName));


              return Column(
                children: [
                  Row(
                    children: List.generate(headers.length, (index) {
                      return Expanded(
                        flex: flexes[index],
                        child: Text(
                          headers[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),
                  const Divider(),
                  ...courts.map((court) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: flexes[0],
                              child: Text(
                                court.dateCreate.toDate().toString().split(' ').first,
                              )),
                          Expanded(flex: flexes[1], child: Text(court.courtName)),
                          Expanded(flex: flexes[2], child: Text(court.courtAddress)),
                          Expanded(
                              flex: flexes[3], child: Text(court.reservationUrl)),
                          Expanded(
                            flex: flexes[4],
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => DialogTennisCourtEdit(
                                        court: court,
                                        vnIsLoading: widget.vnIsLoading,
                                      ),
                                    );
                                  },
                                  child: const Text('관리'),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  tooltip: '코트 삭제',
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance.collection(keyCourt).doc(court.uid).delete();
                                      Utils.log.i('[OK] [코트 삭제 완료]');
                                    } catch (e, s) {
                                      Utils.log.f('[ERR] [코트 삭제 실패]\n$e\n$s');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('코트 삭제 중 오류가 발생했습니다.')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadCourtExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null) return;

      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        try {
          debugPrint('🚀 row[$i] raw values: ${row.map((e) => e?.value).toList()}');

          // Excel columns: A-P (0-15)
          final uuid = const Uuid();
          final uid = row.length > 0 ? row[0]?.value?.toString().trim() : null;
          final dateCreate = row.length > 1 ? row[1]?.value : null;
          final latitude = row.length > 2 ? double.tryParse(row[2]?.value?.toString() ?? '0') ?? 0.0 : 0.0;
          final longitude = row.length > 3 ? double.tryParse(row[3]?.value?.toString() ?? '0') ?? 0.0 : 0.0;
          final courtName = row.length > 4 ? row[4]?.value?.toString().trim() : '';
          final courtAddress = row.length > 5 ? row[5]?.value?.toString().trim() : '';
          final courtInfo1 = row.length > 6 ? row[6]?.value?.toString().trim() : null;
          final courtInfo2 = row.length > 7 ? row[7]?.value?.toString().trim() : null;
          final courtInfo3 = row.length > 8 ? row[8]?.value?.toString().trim() : null;
          final courtInfo4 = row.length > 9 ? row[9]?.value?.toString().trim() : null;
          final reservationSchedule = row.length > 10 ? row[10]?.value?.toString().trim() : null;
          final reservationRuleTypeIndex = row.length > 11 ? int.tryParse(row[11]?.value?.toString() ?? '') : null;
          final reservationHour = row.length > 12 ? int.tryParse(row[12]?.value?.toString() ?? '') : null;
          final reservationDay = row.length > 13 ? int.tryParse(row[13]?.value?.toString() ?? '') : null;
          final daysBeforePlay = row.length > 14 ? int.tryParse(row[14]?.value?.toString() ?? '') : null;
          final reservationUrl = row.length > 15 ? row[15]?.value?.toString().trim() : '';

          final reservation = ModelCourtReservation(
            uid: uuid.v4(),
            reservationRuleType: ReservationRuleType.values[reservationRuleTypeIndex ?? 0],
            reservationHour: reservationHour,
            reservationDay: reservationDay,
            daysBeforePlay: daysBeforePlay,
            dateCreated: Timestamp.now(),
          );

          final model = ModelCourt(
            uid: (uid != null && uid.isNotEmpty) ? uid : uuid.v4(),
            dateCreate: dateCreate != null
                ? Timestamp.fromMillisecondsSinceEpoch(int.tryParse(dateCreate.toString()) ?? 0)
                : Timestamp.now(),
            latitude: latitude,
            longitude: longitude,
            courtName: courtName ?? '',
            courtAddress: courtAddress ?? '',
            courtInfo: '',
            courtInfo1: courtInfo1,
            courtInfo2: courtInfo2,
            courtInfo3: courtInfo3,
            courtInfo4: courtInfo4,
            reservationSchedule: reservationSchedule,
            reservationUrl: reservationUrl ?? '',
            likedUserUids: [],
            imageUrls: [],
            courtDistrict: (courtAddress?.split(' ').length ?? 0) > 1
                ? courtAddress?.split(' ')[1]
                : '',
            courtAlarms: null,
            weatherInfo: null,
            reservationInfo: reservation,
          );
          debugPrint('✅ ModelCourt[$i]: ${model.toJson()}');

          final docRef = await FirebaseFirestore.instance.collection(keyCourt).add(model.toJson());
          final autoUid = docRef.id;
          await docRef.update({keyUid: autoUid});
          debugPrint('📦 Firestore 저장 완료: $autoUid');
        } catch (e, s) {
          debugPrint('❌ Error on row $i: $e');
          debugPrint('🔍 Stack: $s');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('업로드 완료')));
    }
  }

  void _pickFile(ValueNotifier<String?> vnImgUrl) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = false;
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        Utils.log.i('[선택된 파일]: ${file.name}');
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) async {
          try {
            widget.vnIsLoading.value = true;
            final int storageStart = DateTime.now().millisecondsSinceEpoch;

            final Uint8List imageData = reader.result as Uint8List;
            final extension = file.name.split('.').last.toLowerCase();
            final mimeType = file.type;
            String path = 'questions/${file.name}_${Utils.formatDate(DateTime.now())}_${const Uuid().v1()}.$extension';

            Utils.log.i('[파일 업로드 시작]: ${file.name}, MIME: $mimeType');

            final TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(path).putData(
              imageData,
              SettableMetadata(contentType: mimeType),
            );

            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            vnImgUrl.value = downloadUrl;
            Utils.log.i('[이미지 다운로드 URL 저장 완료]: ${vnImgUrl.value}');
            Utils.log.i('[업로드된 이미지 URL]: $downloadUrl');

            widget.vnIsLoading.value = false;
            Utils.log.i('[OK] [이미지 업로드 성공]\n소요시간: ${DateTime.now().millisecondsSinceEpoch - storageStart}ms');
          } catch (e, s) {
            widget.vnIsLoading.value = false;
            Utils.log.f('[ERR] [이미지 업로드 실패]\n$e\n$s');
          }
        });
      }
    });
  }
  void _save({
    required ModelCourt court,
    required TextEditingController nameController,
    required TextEditingController addressController,
    required TextEditingController urlController,
    required TextEditingController infoController,
    required TextEditingController latController,
    required TextEditingController lngController,
    required ValueNotifier<String?> vnImgUrl,
  }) async {
    if (vnImgUrl.value == null) {
      Utils.log.w('[경고] 이미지가 선택되지 않았습니다. 빈 이미지 리스트로 저장합니다.');
    } else {
      Utils.log.i('[정보] 이미지 URL: ${vnImgUrl.value}');
    }

    try {
      final courtData = {
        keyCourtName: nameController.text,
        keyCourtAddress: addressController.text,
        keyReservationUrl: urlController.text,
        keyCourtInfo: infoController.text,
        keyLatitude: double.tryParse(latController.text) ?? 0.0,
        keyLongitude: double.tryParse(lngController.text) ?? 0.0,
        keyImageUrls: vnImgUrl.value != null ? [vnImgUrl.value!] : [],
      };

      await FirebaseFirestore.instance
          .collection(keyCourt)
          .doc(court.uid)
          .update(courtData);

      Utils.log.i('[OK] [코트 등록 성공]');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('코트가 등록되었습니다.')),
      );
      Navigator.of(context).pop();
    } catch (e, s) {
      Utils.log.f('[ERR] [코트 등록 실패]\n$e\n$s');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('코트 등록 중 오류가 발생했습니다.')),
      );
    }
  }
}
