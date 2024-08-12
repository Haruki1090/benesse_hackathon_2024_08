import 'package:benesse_hackathon_2024_08/quiz_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final String community;
  final String eventId;
  final String purpose;

  const RankingPage({
    super.key,
    required this.community,
    required this.eventId,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(purpose)
            .collection('community_list')
            .doc(community)
            .collection('ranking')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ranking = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              final user = ranking[index];
              return ListTile(
                leading: Text('${index + 1}位'),
                title: Text(user['user_name'] ?? '匿名'),
                trailing: Text('${user['score']}ポイント'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                community: community,
                eventId: eventId,
                purpose: purpose,
              ),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
