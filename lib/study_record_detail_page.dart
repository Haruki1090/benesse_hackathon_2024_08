import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudyRecordDetailPage extends StatelessWidget {
  final String genre;
  final String userId;

  const StudyRecordDetailPage(
      {super.key, required this.genre, required this.userId});

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   print('genre: $genre, userId: $userId');
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre の記録'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('study_records')
            .where('genre', isEqualTo: genre)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data!.docs;

          if (records.isEmpty) {
            return const Center(child: Text('まだ記録がありません'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text('勉強内容: ${record['content']}'),
                subtitle: Text(
                    '勉強時間: ${record['study_time']} 分\n集中度: ${record['focus_level']}/5'),
                trailing: Text(
                  '日時: ${(record['timestamp'] as Timestamp).toDate().toString()}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
