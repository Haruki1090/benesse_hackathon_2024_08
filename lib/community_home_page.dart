import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityHomePage extends StatelessWidget {
  const CommunityHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Name'),
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
                          Navigator.of(context).pop();
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
      body: const Center(
        child: Text('Welcome to your Community!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Knowledge Share',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Study Record',
          ),
        ],
        onTap: (index) {
          // BottomNavigationBarのインデックスに基づいて画面を切り替える
          // 各機能の画面は後ほど具体的に実装
        },
      ),
    );
  }
}
