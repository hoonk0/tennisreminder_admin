import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisreminder_core/const/model/model_court.dart';
import 'package:tennisreminder_core/const/value/keys.dart';

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
                                    // 관리 버튼 동작 (비워둠)
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
}
