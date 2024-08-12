import 'package:benesse_hackathon_2024_08/community_recommendation_page.dart';
import 'package:benesse_hackathon_2024_08/selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalSettingPage extends ConsumerWidget {
  final List<String> communities;
  const GoalSettingPage({super.key, required this.communities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController scoreController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('目標を設定しよう',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ListTile(
              title: Text(
                '目標期間を選択',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text('3ヶ月以内'),
              onTap: () {
                ref.read(selectionProvider.notifier).setGoal('3 Months');
                _showScoreDialog(context, ref, scoreController);
              },
            ),
            ListTile(
              title: const Text('6ヶ月以内'),
              onTap: () {
                ref.read(selectionProvider.notifier).setGoal('6 Months');
                _showScoreDialog(context, ref, scoreController);
              },
            ),
            // 他のゴールを追加
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(
      BuildContext context, WidgetRef ref, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('目標点数を入力してください'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '例: 700',
              labelText: '点数',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final goalWithScore =
                      '${ref.read(selectionProvider).goal} に ${controller.text}点';
                  ref.read(selectionProvider.notifier).setGoal(goalWithScore);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CommunityRecommendationPage(communities: communities),
                    ),
                  );
                }
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }
}
