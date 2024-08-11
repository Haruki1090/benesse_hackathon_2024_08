// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:benesse_hackathon_2024_08/study_record_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudyRecordPage extends StatefulWidget {
  const StudyRecordPage({super.key});

  @override
  _StudyRecordPageState createState() => _StudyRecordPageState();
}

class _StudyRecordPageState extends State<StudyRecordPage> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedGenre = '単語';
  int _focusLevel = 3;
  int _studyTimeInMinutes = 0;

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
            _buildTotalStudyTime(),
            const SizedBox(height: 20),
            _buildAverageFocusLevel(),
            const SizedBox(height: 20),
            _buildStudyTimeByGenre(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // タイムピッカーを表示して、勉強時間を「分」単位で選択
          final timeOfDay = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 0, minute: 0),
          );

          if (timeOfDay != null) {
            setState(() {
              _studyTimeInMinutes = timeOfDay.hour * 60 + timeOfDay.minute;
            });

            _showStudyRecordDialog(context);
          }
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
              subtitle:
                  Text('${totalStudyTime ~/ 60} 時間 ${totalStudyTime % 60} 分'),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('ログインが必要です'));
    }
  }

  Widget _buildAverageFocusLevel() {
    return const Card(
      child: ListTile(
        title: Text('平均集中度'),
        subtitle: Text('4.5/5'),
      ),
    );
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
          Map<String, int> studyTimeByGenre = {
            '単語': 0,
            '文法': 0,
            '英文解釈': 0,
            '過去問': 0,
          };

          for (var record in records) {
            final genre = record['genre'] as String;
            final studyTime = int.tryParse(record['study_time'] ?? '0') ?? 0;

            if (studyTimeByGenre.containsKey(genre)) {
              studyTimeByGenre[genre] = studyTimeByGenre[genre]! + studyTime;
            }
          }

          return Card(
            child: Column(
              children: studyTimeByGenre.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing:
                      Text('${entry.value ~/ 60} 時間 ${entry.value % 60} 分'),
                  onTap: () {
                    // タップされたジャンルを使って詳細ページに遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyRecordDetailPage(
                          genre: entry.key,
                          userId: user.uid,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('ログインが必要です'));
    }
  }

  void _showStudyRecordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                  decoration: const InputDecoration(labelText: 'どんなことを学びましたか？'),
                  maxLines: 4,
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
                Text(
                    '勉強時間: ${_studyTimeInMinutes ~/ 60} 時間 ${_studyTimeInMinutes % 60} 分'),
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
        });
      },
    );
  }

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
        'study_time': _studyTimeInMinutes.toString(), // 分単位で保存
        'focus_level': _focusLevel,
        'timestamp': Timestamp.now(),
      });

      // 該当するストリームに記録を反映
      // ユーザーのコミュニティを取得
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

      final streamRecord = FirebaseFirestore.instance
          .collection('communities')
          .doc(purpose)
          .collection('community_list')
          .doc(community)
          .collection('study_streams')
          .doc(_selectedGenre)
          .collection('posts')
          .doc();

      // ユーザー名を取得
      final userName = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) => doc.data()?['name']);

      await streamRecord.set({
        'user_id': user.uid,
        'user_name': userName,
        'content': _contentController.text,
        'focus_level': _focusLevel,
        'timestamp': Timestamp.now(),
        'likes': 0, // いいねの初期値を0に設定
      });
    }
  }
}
