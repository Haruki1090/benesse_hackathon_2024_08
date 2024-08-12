import 'package:flutter/material.dart';

class MemberDetailPage extends StatelessWidget {
  final String name;
  final String email;
  final String university;
  final String faculty;
  final String purpose;
  final String goal;
  final String grade;
  final String Effort;

  const MemberDetailPage({
    super.key,
    required this.name,
    required this.email,
    required this.university,
    required this.faculty,
    required this.purpose,
    required this.goal,
    required this.grade,
    required this.Effort,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メンバー詳細'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '名前: $name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            Text(
              'メール: $email',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '大学: $university',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '学部: $faculty',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '目的: $purpose',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '目標: $goal',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '学年: $grade',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              '努力: $Effort',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
