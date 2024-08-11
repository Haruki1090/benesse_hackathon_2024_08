// ignore_for_file: use_build_context_synchronously

import 'package:benesse_hackathon_2024_08/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityHomePage extends StatelessWidget {
  const CommunityHomePage({super.key});

  Future<String?> _getCommunityName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data()?['community'] as String?;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _getCommunityName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!);
            } else {
              return const Text('No Community');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // アカウント設定やログアウトボタンを表示
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Account'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Account Settings'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const AuthGate()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // メンバーリストボタン
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  _showMemberList(context);
                },
                child: const Text('メンバーリスト', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          // 企画ボード
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('企画ボード',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('今週金曜日午後8:00からオンライン単語テストを開催します'),
                    subtitle: const Text('参加表明: 3名、コメント: 5件'),
                    onTap: () {
                      // イベント詳細ページに遷移
                    },
                  ),
                  // 他の企画ボードのアイテムを追加
                ],
              ),
            ),
          ),
          const Divider(thickness: 2),
          // スタディストリーム
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildStreamCard(
                  context,
                  '単語ストリーム',
                  '最後の投稿: ユーザーA',
                  'word_stream',
                ),
                _buildStreamCard(
                  context,
                  '文法ストリーム',
                  '最後の投稿: ユーザーB',
                  'grammar_stream',
                ),
                _buildStreamCard(
                  context,
                  '英文解釈ストリーム',
                  '最後の投稿: ユーザーC',
                  'interpretation_stream',
                ),
                _buildStreamCard(
                  context,
                  '過去問ストリーム',
                  '最後の投稿: ユーザーD',
                  'past_question_stream',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 10, // メンバー数に応じて変更
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('メンバー $index'), // メンバーの名前を表示
              subtitle: const Text('member@example.com'), // メンバーのメールアドレスを表示
            );
          },
        );
      },
    );
  }

  Widget _buildStreamCard(BuildContext context, String streamName,
      String lastPostedUser, String streamId) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(streamName),
        subtitle: Text(lastPostedUser),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // 各ストリームのタイムラインページに遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamTimelinePage(
                  streamName: streamName, streamId: streamId),
            ),
          );
        },
      ),
    );
  }
}

class StreamTimelinePage extends StatelessWidget {
  final String streamName;
  final String streamId;

  const StreamTimelinePage(
      {super.key, required this.streamName, required this.streamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(streamName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 20, // 仮の投稿数
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('ユーザー $index'),
            subtitle: const Text('投稿内容の詳細がここに表示されます'),
          );
        },
      ),
    );
  }
}
