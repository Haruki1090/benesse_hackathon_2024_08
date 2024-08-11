import 'package:flutter/material.dart';

class StudyRecordPage extends StatelessWidget {
  const StudyRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('勉強ダッシュボード'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 総勉強時間の表示
            _buildTotalStudyTime(),
            const SizedBox(height: 20),
            // 集中度の平均の表示
            _buildAverageFocusLevel(),
            const SizedBox(height: 20),
            // ジャンル別の勉強時間
            _buildStudyTimeByGenre(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showStudyRecordDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalStudyTime() {
    // Firestoreからデータを取得し、総勉強時間を計算
    // サンプル表示
    return const Card(
      child: ListTile(
        title: Text('総勉強時間'),
        subtitle: Text('50時間'),
      ),
    );
  }

  Widget _buildAverageFocusLevel() {
    // Firestoreからデータを取得し、集中度の平均を計算
    // サンプル表示
    return const Card(
      child: ListTile(
        title: Text('平均集中度'),
        subtitle: Text('4.5/5'),
      ),
    );
  }

  Widget _buildStudyTimeByGenre() {
    // Firestoreからジャンル別の勉強時間を取得
    // サンプル表示
    return const Card(
      child: Column(
        children: [
          ListTile(
            title: Text('単語'),
            trailing: Text('20時間'),
          ),
          ListTile(
            title: Text('文法'),
            trailing: Text('15時間'),
          ),
          ListTile(
            title: Text('英文解釈'),
            trailing: Text('10時間'),
          ),
          ListTile(
            title: Text('過去問'),
            trailing: Text('5時間'),
          ),
        ],
      ),
    );
  }

  void _showStudyRecordDialog(BuildContext context) {
    // 投稿用のダイアログを表示
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('勉強記録を追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: '単語',
                items: ['単語', '文法', '英文解釈', '過去問']
                    .map((genre) => DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        ))
                    .toList(),
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'ジャンル'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'どんなことを学びましたか？'),
                maxLines: 2,
              ),
              const TextField(
                decoration: InputDecoration(labelText: '勉強時間（任意）'),
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('集中度'),
                  Slider(
                    value: 3.0,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '3',
                    onChanged: (value) {},
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // Firestoreにデータを保存
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
