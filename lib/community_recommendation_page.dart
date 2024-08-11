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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Communities'),
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          return ListTile(
            title: Text(community),
            onTap: () {
              ref.read(selectionProvider.notifier).setCommunity(community);
              _confirmAndSave(context, ref,
                  ref.read(selectionProvider).purpose!, community);
            },
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
        title: const Text('Confirm your choices'),
        content: Text('Purpose: ${selectionState.purpose}\n'
            'Goal: ${selectionState.goal}\n'
            'Community: ${selectionState.community}'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Firestoreへの保存とコミュニティーへの参加処理を待機
                await _saveToFirestoreAndJoinCommunity(
                    selectionState, purpose, communityId);

                // 成功した場合に画面遷移
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false);
              } catch (e) {
                // エラーハンドリング（Firestoreの操作に失敗した場合）
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                // ダイアログを閉じる
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Join this community'),
          ),
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
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

      // ユーザーの目的、目標、選択されたコミュニティーをFirestoreに保存
      await userDoc.update({
        'purpose': selectionState.purpose,
        'goal': selectionState.goal,
        'community': selectionState.community,
      });

      // コミュニティーにユーザーを追加する処理
      final communityDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(purpose)
          .collection('community_list')
          .doc(communityId);
      final userData = await userDoc.get();

      // コミュニティードキュメントが存在するか確認
      final communitySnapshot = await communityDoc.get();

      if (!communitySnapshot.exists) {
        // コミュニティードキュメントが存在しない場合、新規作成
        await communityDoc.set({
          'name': communityId,
          'members': [],
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        });
      }

      // コミュニティードキュメントを更新（既存のドキュメントも含む）
      await communityDoc.update({
        'members': FieldValue.arrayUnion([user.uid]),
        'updated_at': Timestamp.now(),
      });

      // コミュニティー内のメンバーサブコレクションにユーザー情報を追加
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
