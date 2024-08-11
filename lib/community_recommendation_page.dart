import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page.dart';
import 'selection_state.dart';

class CommunityRecommendationPage extends ConsumerWidget {
  const CommunityRecommendationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Communities'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('とりあえず一週間頑張ろう'),
            subtitle: const Text('TOEIC対策用のコミュニティー'),
            onTap: () {
              ref.read(selectionProvider.notifier).setCommunity('とりあえず一週間頑張ろう');
              _confirmAndSave(context, ref, 'とりあえず一週間頑張ろう');
            },
          ),
          ListTile(
            title: const Text('1ヶ月ガッツリ'),
            subtitle: const Text('日商簿記検定対策用のコミュニティー'),
            onTap: () {
              ref.read(selectionProvider.notifier).setCommunity('1ヶ月ガッツリ');
              _confirmAndSave(context, ref, '1ヶ月ガッツリ');
            },
          ),
          // 他のコミュニティーを追加
        ],
      ),
    );
  }

  Future<void> _confirmAndSave(
      BuildContext context, WidgetRef ref, String communityId) async {
    final selectionState = ref.read(selectionProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm your choices'),
        content: Text('Purpose: ${selectionState.purpose}\n'
            'Goal: ${selectionState.goal}\n'
            'Community: ${selectionState.community}'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // ダイアログを閉じる
              await _saveToFirestoreAndJoinCommunity(
                  selectionState, communityId);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: const Text('Join this community'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToFirestoreAndJoinCommunity(
      SelectionState selectionState, String communityId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // ユーザーの目的、目標、選択されたコミュニティーをFirestoreに保存
      await userDoc.update({
        'purpose': selectionState.purpose,
        'goal': selectionState.goal,
        'community': selectionState.community,
      });

      // コミュニティーにユーザーを追加する処理
      final communityDoc =
          FirebaseFirestore.instance.collection('communities').doc(communityId);
      final userData = await userDoc.get();

      await communityDoc.collection('members').doc(user.uid).set({
        'user_id': user.uid,
        'joined_at': Timestamp.now(),
        'last_active': Timestamp.now(),
        'role': 'member', // メンバーとして追加
        'name': userData['name'],
        'email': userData['email'],
        // 必要な他のフィールドも追加
      });

      // ユーザードキュメントに参加したコミュニティーIDを追加
      await userDoc.update({
        'joined_communities': FieldValue.arrayUnion([communityId]),
      });
    }
  }
}
