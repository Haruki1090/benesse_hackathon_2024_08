// ignore_for_file: use_build_context_synchronously

import 'package:benesse_hackathon_2024_08/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const HomePage(); // ログイン済みの場合はホームページへ
        } else {
          return const LoginPage(); // ログインしていない場合はログインページへ
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

// ログイン状態を管理するProvider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ログインページ
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login or Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

// サインアップページ
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final universityController = TextEditingController();
    final facultyController = TextEditingController();
    final gradeController = TextEditingController();
    final effortController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name (Required)'),
            ),
            TextField(
              controller: universityController,
              decoration:
                  const InputDecoration(labelText: 'University (Required)'),
            ),
            TextField(
              controller: facultyController,
              decoration:
                  const InputDecoration(labelText: 'Faculty (Required)'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade (Required)'),
            ),
            TextField(
              controller: effortController,
              decoration:
                  const InputDecoration(labelText: 'Recent Effort (Optional)'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // FirebaseAuthでユーザー作成
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // Firestoreにユーザー情報を保存
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'email': emailController.text,
                    'name': nameController.text,
                    'university': universityController.text,
                    'faculty': facultyController.text,
                    'grade': gradeController.text,
                    'effort': effortController.text,
                  });

                  // プロフィール設定ページへ遷移
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print('Error: $e');
                  }
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// サインインページ
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print('Error: $e');
                  }
                }
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
