// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudyRecordPage extends StatefulWidget {
  const StudyRecordPage({super.key});

  @override
  State<StudyRecordPage> createState() => _StudyRecordPageState();
}

class _StudyRecordPageState extends State<StudyRecordPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _selectedGenre = '単語';
  int _focusLevel = 3;

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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('study_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data!.docs;
          int totalStudyTime = 0;

          for (var record in records) {
            final studyTime = int.tryParse(record['study_time'] ?? '0') ?? 0;
            totalStudyTime += studyTime;
          }

          return Card(
            child: ListTile(
              title: const Text('総勉強時間'),
              subtitle: Text('$totalStudyTime 時間'),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('ログインが必要です'));
    }
  }

  Widget _buildAverageFocusLevel() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('study_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data!.docs;
          double totalFocusLevel = 0;

          for (var record in records) {
            final focusLevel = record['focus_level'] ?? 0;
            totalFocusLevel += focusLevel;
          }

          final averageFocusLevel = totalFocusLevel / records.length;

          return Card(
            child: ListTile(
              title: const Text('集中度の平均'),
              subtitle: Text(averageFocusLevel.toStringAsFixed(1)),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('ログインが必要です'));
    }
  }

  Widget _buildStudyTimeByGenre() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('study_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data!.docs;
          final studyTimeByGenre = <String, int>{};

          for (var record in records) {
            final genre = record['genre'] ?? 'その他';
            final studyTime = int.tryParse(record['study_time'] ?? '0') ?? 0;

            if (studyTimeByGenre.containsKey(genre)) {
              studyTimeByGenre[genre] = studyTimeByGenre[genre]! + studyTime;
            } else {
              studyTimeByGenre[genre] = studyTime;
            }
          }

          return Card(
            child: Column(
              children: studyTimeByGenre.entries
                  .map((entry) => ListTile(
                        title: Text(entry.key),
                        subtitle: Text('${entry.value} 時間'),
                      ))
                  .toList(),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('ログインが必要です'));
    }
  }

  void _showStudyRecordDialog(BuildContext context) {
    // 投稿用のダイアログを表示
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'ジャンル'),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration:
                        const InputDecoration(labelText: 'どんなことを学びましたか？'),
                    maxLines: 4,
                  ),
                  TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: '勉強時間（任意）'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('集中度'),
                      Slider(
                        value: _focusLevel.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: '$_focusLevel',
                        onChanged: (value) {
                          setState(() {
                            _focusLevel = value.toInt();
                          });
                        },
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
                ElevatedButton(
                  onPressed: () async {
                    await _saveStudyRecord();
                    Navigator.pop(context);
                  },
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 勉強記録を保存
  Future<void> _saveStudyRecord() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRecord = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('study_records')
          .doc();

      // 勉強記録をユーザーのstudy_recordsに保存
      await userRecord.set({
        'genre': _selectedGenre,
        'content': _contentController.text,
        'study_time': _timeController.text,
        'focus_level': _focusLevel,
        'timestamp': Timestamp.now(),
      });

      // 該当するストリームに記録を反映
      // ユーザーのコミュニティ名を取得
      final community = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) => doc.data()?['community']);
      // ユーザーの目的を取得
      final purpose = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) => doc.data()?['purpose']);

      // if (kDebugMode) {
      //   print(community);
      //   print(purpose);
      // }

      // コミュニティのストリームに記録を保存
      final streamRecord = FirebaseFirestore.instance
          .collection('communities')
          .doc(purpose)
          .collection('community_list')
          .doc(community)
          .collection('study_streams')
          .doc(_selectedGenre)
          .collection('posts')
          .doc();

      final name = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) => doc.data()?['name']);

      await streamRecord.set({
        'user_id': user.uid,
        'user_name': name,
        'content': _contentController.text,
        'focus_level': _focusLevel,
        'timestamp': Timestamp.now(),
      });
    }
  }
}
