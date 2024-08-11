import 'package:benesse_hackathon_2024_08/community_recommendation_page.dart';
import 'package:benesse_hackathon_2024_08/selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalSettingPage extends ConsumerWidget {
  final List<String> communities;
  const GoalSettingPage({super.key, required this.communities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目標を設定しよう'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('3ヶ月以内'),
            onTap: () {
              ref.read(selectionProvider.notifier).setGoal('3 Months');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommunityRecommendationPage(
                          communities: communities)));
            },
          ),
          ListTile(
            title: const Text('6ヶ月以内'),
            onTap: () {
              ref.read(selectionProvider.notifier).setGoal('6 Months');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommunityRecommendationPage(
                          communities: communities)));
            },
          ),
          // 他のゴールを追加
        ],
      ),
    );
  }
}
