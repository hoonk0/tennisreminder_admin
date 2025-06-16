import 'dart:typed_data';

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
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('삭제 확인'),
                                        content: const Text('이 코트를 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('삭제'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await FirebaseFirestore.instance.collection(keyCourt).doc(court.uid).delete();
                                        Utils.log.i('[OK] [코트 삭제 완료]');
                                      } catch (e, s) {
                                        Utils.log.f('[ERR] [코트 삭제 실패]\n$e\n$s');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('코트 삭제 중 오류가 발생했습니다.')),
                                        );
                                      }
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
