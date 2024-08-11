import 'package:benesse_hackathon_2024_08/community_recommendation_page.dart';
import 'package:benesse_hackathon_2024_08/selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalSettingPage extends ConsumerWidget {
  const GoalSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Final Goal'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            items: const [
              DropdownMenuItem(value: '1 Month', child: Text('〜1ヶ月')),
              DropdownMenuItem(value: '3 Months', child: Text('〜3ヶ月')),
              DropdownMenuItem(value: '6 Months', child: Text('〜6ヶ月')),
              DropdownMenuItem(value: '1 Year', child: Text('〜1年')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(selectionProvider.notifier).setGoal(value);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CommunityRecommendationPage()),
                    (route) => false);
              }
            },
          ),
          // 適切な選択肢を追加
        ],
      ),
    );
  }
}
