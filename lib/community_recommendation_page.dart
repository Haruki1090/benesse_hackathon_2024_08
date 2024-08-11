// ignore_for_file: use_build_context_synchronously

import 'package:benesse_hackathon_2024_08/home_page.dart';
import 'package:benesse_hackathon_2024_08/selection_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              _confirmAndSave(context, ref);
            },
          ),
          ListTile(
            title: const Text('1ヶ月ガッツリ'),
            subtitle: const Text('日商簿記検定対策用のコミュニティー'),
            onTap: () {
              ref.read(selectionProvider.notifier).setCommunity('1ヶ月ガッツリ');
              _confirmAndSave(context, ref);
            },
          ),
          // 他のコミュニティーを追加
        ],
      ),
    );
  }

  Future<void> _confirmAndSave(BuildContext context, WidgetRef ref) async {
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
              await _saveToFirestore(selectionState);
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

  Future<void> _saveToFirestore(SelectionState selectionState) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'purpose': selectionState.purpose,
        'goal': selectionState.goal,
        'community': selectionState.community,
      });
    }
  }
}
