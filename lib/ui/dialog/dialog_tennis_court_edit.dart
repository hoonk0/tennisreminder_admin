import 'dart:developer' as Utils;
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/value/keys.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../component/button_bottom.dart';
import 'dialog_confirm.dart';

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

  final ValueNotifier<String?> vnImgUrl = ValueNotifier(null);

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
    vnImgUrl.value = (court.imageUrls!.isNotEmpty) ? court.imageUrls!.first : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    urlController.dispose();
    infoController.dispose();
    latController.dispose();
    lngController.dispose();
    vnImgUrl.dispose();
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
              ValueListenableBuilder<String?>(
                valueListenable: vnImgUrl,
                builder: (context, imgUrl, child) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: _pickFile,
                        child: Container(
                          width: 120,
                          height: 160,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: imgUrl == null
                              ? Center(child: Icon(Icons.add, color: Colors.blue, size: 20))
                              : Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.error));
                                  },
                                ),
                        ),
                      ),
                      if (imgUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            Uri.decodeFull(imgUrl.split('%2F').last.split('?').first),
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                    ],
                  );
                },
              ),
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

  void _pickFile() async {
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
            widget.vnIsLoading.value = true;
            final int storageStart = DateTime.now().millisecondsSinceEpoch;

            final Uint8List imageData = reader.result as Uint8List;
            final extension = file.name.split('.').last.toLowerCase();
            final mimeType = file.type;
            final sanitizedFileName = 'court_${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1()}.png';
            String path = 'courts/$sanitizedFileName';


            final TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(path).putData(
              imageData,
              SettableMetadata(contentType: mimeType),
            );

            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            Utils.log('📷 imageUrl: $downloadUrl');
            // Add short delay to allow Firebase Storage caching to complete
            await Future.delayed(const Duration(milliseconds: 500));
            if (!mounted) return;
            vnImgUrl.value = downloadUrl;

            widget.vnIsLoading.value = false;
            Utils.log('[OK] [이미지 업로드 성공]\n소요시간: ${DateTime.now().millisecondsSinceEpoch - storageStart}ms');
          } catch (e, s) {
            widget.vnIsLoading.value = false;
            Utils.log('[ERR] [이미지 업로드 실패]\n$e\n$s');
          }
        });
      } else {
        debugPrint('[ERR] 파일이 비어있거나 없음');
      }
    });
  }
  void _save() async {
    widget.vnIsLoading.value = true;
    try {
      if (vnImgUrl.value == null) {
        debugPrint('[ERR] 이미지가 아직 업로드되지 않았습니다.');
        showDialog(
          context: context,
          builder: (context) => const DialogConfirm(title: '이미지 업로드가 완료될 때까지 기다려주세요.'),
        );
        widget.vnIsLoading.value = false;
        return;
      }

      await FirebaseFirestore.instance.collection(keyCourt).doc(widget.court.uid).update({
        keyCourtName: nameController.text,
        keyCourtAddress: addressController.text,
        keyReservationUrl: urlController.text,
        keyCourtInfo: infoController.text,
        keyLatitude: double.tryParse(latController.text) ?? 0.0,
        keyLongitude: double.tryParse(lngController.text) ?? 0.0,
        keyImageUrls: [vnImgUrl.value!],
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