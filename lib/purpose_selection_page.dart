import 'package:benesse_hackathon_2024_08/goal_setting_page.dart';
import 'package:benesse_hackathon_2024_08/selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PurposeSelectionPage extends ConsumerWidget {
  const PurposeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Purpose'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('TOEIC'),
            onTap: () {
              ref.read(selectionProvider.notifier).setPurpose('TOEIC');
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GoalSettingPage()));
            },
          ),
          ListTile(
            title: const Text('日商簿記検定'),
            onTap: () {
              ref.read(selectionProvider.notifier).setPurpose('日商簿記検定');
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GoalSettingPage()));
            },
          ),
          // 他の目的もリストアップ
        ],
      ),
    );
  }
}
