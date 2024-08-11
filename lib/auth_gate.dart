// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

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
      body: SafeArea(
        child: Center(
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
                child: const Text('アカウント登録'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final universityController = TextEditingController();
  final facultyController = TextEditingController();
  final gradeController = TextEditingController();
  final effortController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント登録'),
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
              decoration: InputDecoration(
                labelText: 'パスワード',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'パスワード確認',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: _obscureConfirmPassword,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ユーザー名'),
            ),
            TextField(
              controller: universityController,
              decoration: const InputDecoration(labelText: '大学'),
            ),
            TextField(
              controller: facultyController,
              decoration: const InputDecoration(labelText: '学部'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: '年次'),
            ),
            TextField(
              controller: effortController,
              decoration: const InputDecoration(labelText: '好きなこと'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  // パスワードと確認用パスワードが一致しない場合
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('パスワードが一致しません')),
                  );
                  return;
                }

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

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
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
              decoration: InputDecoration(
                labelText: 'パスワード',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
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
