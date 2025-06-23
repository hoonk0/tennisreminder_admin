import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tennisreminder_core/const/model/model_opinion.dart';
import 'package:tennisreminder_core/const/value/keys.dart';

class TabUserOpinion extends StatefulWidget {
  final ValueNotifier<bool> vnIsLoading;
  const TabUserOpinion({super.key, required this.vnIsLoading});

  @override
  State<TabUserOpinion> createState() => _TabUserOpinionState();
}

class _TabUserOpinionState extends State<TabUserOpinion> {
  final bool vnShow = true;

  @override
  Widget build(BuildContext context) {
    final headers = ['작성일자', '제목', '내용'];
    final flexes = [2, 3, 7];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(keyUserOpinion)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('의견을 불러오는 중 오류 발생'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            debugPrint('[DEBUG] snapshot.hasData: ${snapshot.hasData}');
            debugPrint('[DEBUG] docs count: ${snapshot.data?.docs.length}');
            if (snapshot.data != null) {
              for (final doc in snapshot.data!.docs) {
                debugPrint('[DEBUG] raw doc: ${doc.data()}');
              }
            }
            final opinions = docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ModelUserOpinion.fromJson({...data, keyOpinionUid: doc.id});
            }).toList();

            opinions.sort((a, b) => b.dateCreate.compareTo(a.dateCreate));
            debugPrint('[DATA] 불러온 의견 수: ${opinions.length}');

            if (opinions.isEmpty) {
              return const Center(child: Text('등록된 의견이 없습니다.'));
            }

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
                ...opinions.map((opinion) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(opinion.title),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('작성일자: ${opinion.dateCreate.toDate().toString().split(' ').first}'),
                              const SizedBox(height: 8),
                              Text(opinion.content),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('닫기'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: flexes[0],
                            child: Text(opinion.dateCreate.toDate().toString().split(' ').first),
                          ),
                          Expanded(
                            flex: flexes[1],
                            child: Text(opinion.title),
                          ),
                          Expanded(
                            flex: flexes[2],
                            child: Text(opinion.content),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
