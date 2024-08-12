// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page.dart';
import 'selection_state.dart';

class CommunityRecommendationPage extends ConsumerWidget {
  final List<String> communities;
  const CommunityRecommendationPage({super.key, required this.communities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionProvider);

    final communityDescriptions = {
      'とりあえず一週間頑張ろう': '単語テストを全員で行い、みんなで協力して勉強習慣をつけよう！',
      '1ヶ月ガッツリ': '1ヶ月間、集中して学習に取り組むためのコミュニティーです。共に目標達成を目指しましょう！',
      // 他のコミュニティーの説明を追加
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('おすすめのコミュニティー',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo[300],
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          final description = communityDescriptions[community] ?? '詳細情報がありません';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                community,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              onTap: () {
                ref.read(selectionProvider.notifier).setCommunity(community);
                _confirmAndSave(context, ref,
                    ref.read(selectionProvider).purpose!, community);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmAndSave(BuildContext context, WidgetRef ref,
      String purpose, String communityId) async {
    final selectionState = ref.read(selectionProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'このコミュニティーに参加しますか？',
        ),
        content: Text('Purpose: ${selectionState.purpose}\n'
            'Goal: ${selectionState.goal}\n'
            'Community: ${selectionState.community}'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _saveToFirestoreAndJoinCommunity(
                    selectionState, purpose, communityId);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('参加します'),
          ),
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToFirestoreAndJoinCommunity(
      SelectionState selectionState, String purpose, String communityId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.update({
        'purpose': selectionState.purpose,
        'goal': selectionState.goal,
        'community': selectionState.community,
      });

      final communityDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(purpose)
          .collection('community_list')
          .doc(communityId);
      final userData = await userDoc.get();

      final communitySnapshot = await communityDoc.get();

      if (!communitySnapshot.exists) {
        await communityDoc.set({
          'name': communityId,
          'members': [],
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        });
      }

      await communityDoc.update({
        'members': FieldValue.arrayUnion([user.uid]),
        'updated_at': Timestamp.now(),
      });

      await communityDoc.collection('members').doc(user.uid).set({
        'user_id': user.uid,
        'joined_at': Timestamp.now(),
        'last_active': Timestamp.now(),
        'role': 'member',
        'name': userData['name'],
        'email': userData['email'],
      });

      await userDoc.update({
        'joined_communities': FieldValue.arrayUnion([communityId]),
      });
    }
  }
}
