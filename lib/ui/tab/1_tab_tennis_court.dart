import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

import '../../utils/utils.dart';

class TabTennisCourt extends StatelessWidget {
  const TabTennisCourt({super.key});

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
                                      builder: (context) {
                                        final TextEditingController nameController =
                                            TextEditingController(text: court.courtName);
                                        final TextEditingController addressController =
                                            TextEditingController(text: court.courtAddress);
                                        final TextEditingController urlController =
                                            TextEditingController(text: court.reservationUrl);
                                        final TextEditingController infoController =
                                            TextEditingController(text: court.courtInfo);
                                        final TextEditingController latController =
                                            TextEditingController(text: court.latitude.toString());
                                        final TextEditingController lngController =
                                            TextEditingController(text: court.longitude.toString());

                                        return AlertDialog(
                                          title: const Text('코트 정보 수정'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: nameController,
                                                  decoration: const InputDecoration(labelText: '코트명'),
                                                ),
                                                TextField(
                                                  controller: addressController,
                                                  decoration: const InputDecoration(labelText: '주소'),
                                                ),
                                                TextField(
                                                  controller: urlController,
                                                  decoration: const InputDecoration(labelText: '예약 링크'),
                                                ),
                                                TextField(
                                                  controller: infoController,
                                                  decoration: const InputDecoration(labelText: '코트 설명'),
                                                ),
                                                TextField(
                                                  controller: latController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: const InputDecoration(labelText: '위도'),
                                                ),
                                                TextField(
                                                  controller: lngController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: const InputDecoration(labelText: '경도'),
                                                ),
                                                const SizedBox(height: 16),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('이미지 업로드'),
                                                    const SizedBox(height: 8),
                                                    GestureDetector(
                                                      onTap: _pickFile,
                                                      child: Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: Colors.grey[100],
                                                        ),
                                                        child: const Center(
                                                          child: Icon(Icons.add, size: 32, color: Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('취소'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection(keyCourt)
                                                    .doc(court.uid)
                                                    .update({
                                                  keyCourtName: nameController.text,
                                                  keyCourtAddress: addressController.text,
                                                  keyReservationUrl: urlController.text,
                                                  keyCourtInfo: infoController.text,
                                                  keyLatitude: double.tryParse(latController.text) ?? 0.0,
                                                  keyLongitude: double.tryParse(lngController.text) ?? 0.0,
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('저장'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('관리'),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection(keyCourt)
                                        .doc(court.uid)
                                        .delete();
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
  // Helper for image file picking and uploading
  static void _pickFile() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = false;
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) async {
          try {
            final int storageStart = DateTime.now().millisecondsSinceEpoch;

            final Uint8List imageData = reader.result as Uint8List;
            final extension = file.name.split('.').last.toLowerCase();
            final mimeType = file.type;
            String path = 'questions/${file.name}_${Utils.formatDate(DateTime.now())}_${const Uuid().v1()}.$extension';

            final TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(path).putData(
              imageData,
              SettableMetadata(contentType: mimeType),
            );

            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

            Utils.log.i('[OK] [이미지 업로드 성공]\n소요시간: ${DateTime.now().millisecondsSinceEpoch - storageStart}ms');
          } catch (e, s) {
            Utils.log.f('[ERR] [이미지 업로드 실패]\n$e\n$s');
          }
        });
      }
    });
  }
}

