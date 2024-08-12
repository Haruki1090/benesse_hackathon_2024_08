// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String community;
  final String eventId;
  final String purpose;

  const QuizPage({
    super.key,
    required this.community,
    required this.eventId,
    required this.purpose,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  final List<String> _results = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '「appropriate」の意味は？',
      'options': ['不適切な', '適切な', '即時の', '例外的な'],
      'answer': '適切な'
    },
    {
      'question': '「requirement」の意味は？',
      'options': ['規制', '要件', '要求', '条件'],
      'answer': '要件'
    },
    {
      'question': '「beneficial」の意味は？',
      'options': ['有害な', '有益な', '必要な', '義務的な'],
      'answer': '有益な'
    },
    {
      'question': '「resign」の意味は？',
      'options': ['応募する', '辞任する', '同意する', '抵抗する'],
      'answer': '辞任する'
    },
    {
      'question': '「anticipate」の意味は？',
      'options': ['避ける', '予測する', '反対する', '支持する'],
      'answer': '予測する'
    },
    {
      'question': '「substantial」の意味は？',
      'options': ['少量の', '基本的な', '重要な', 'わずかな'],
      'answer': '重要な'
    },
    {
      'question': '「negotiate」の意味は？',
      'options': ['拒否する', '承認する', '交渉する', '購入する'],
      'answer': '交渉する'
    },
    {
      'question': '「implement」の意味は？',
      'options': ['延期する', '導入する', '実施する', '準備する'],
      'answer': '実施する'
    },
    {
      'question': '「comprehensive」の意味は？',
      'options': ['包括的な', '具体的な', '限定的な', '部分的な'],
      'answer': '包括的な'
    },
    {
      'question': '「compensation」の意味は？',
      'options': ['報酬', '貢献', '保護', '費用'],
      'answer': '報酬'
    },
  ];

  void _checkAnswer(String selectedOption) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = selectedOption == currentQuestion['answer'];
    if (isCorrect) {
      _score += 10; // 正解ごとに10ポイント加算
      _results.add('正解: ${currentQuestion['question']} → $selectedOption');
    } else {
      _results.add(
          '不正解: ${currentQuestion['question']} → あなたの回答: $selectedOption / 正解: ${currentQuestion['answer']}');
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final user = FirebaseAuth.instance.currentUser;

    final userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((snapshot) => snapshot.data()?['name'] as String);

    if (user != null) {
      final rankingDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('ranking')
          .doc(user.uid);

      final currentRanking = await rankingDoc.get();

      // 現在のスコアを取得し、新しいスコアを加算する
      final currentScore = currentRanking.data()?['score'] ?? 0;

      await rankingDoc.set({
        'user_id': user.uid,
        'user_name': userName,
        'score': currentScore + _score, // 新しいスコアを加算
        'timestamp': Timestamp.now(),
      });

      // クイズ終了画面に遷移
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultPage(
            score: _score,
            results: _results,
            community: widget.community,
            purpose: widget.purpose,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語クイズ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '問題 ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ..._questions[_currentQuestionIndex]['options']
                .map<Widget>((option) {
              return ElevatedButton(
                onPressed: () => _checkAnswer(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class QuizResultPage extends StatelessWidget {
  final int score;
  final List<String> results;
  final String community;
  final String purpose;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.results,
    required this.community,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'あなたの点数は合計 $score 点でした！',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final isCorrect = results[index].startsWith('正解');
                  return Card(
                    color: isCorrect ? Colors.green[50] : Colors.red[50],
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isCorrect ? Icons.check_circle : Icons.error,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        results[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'ランキングページに戻る',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
