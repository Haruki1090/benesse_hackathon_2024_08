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
      body: const Center(
        child: Text('Welcome to your Community!'),
      ),
    );
  }
}
