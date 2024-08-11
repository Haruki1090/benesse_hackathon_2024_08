// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class StudyRecordPage extends StatefulWidget {
  const StudyRecordPage({super.key});

  @override
  _StudyRecordPageState createState() => _StudyRecordPageState();
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
        title: const Text('勉強記録'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedGenre,
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveStudyRecord();
              },
              child: const Text('記録を保存'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveStudyRecord() async {
    // Firestoreに保存し、同時にスタディストリームに反映する処理を実装
  }
}
