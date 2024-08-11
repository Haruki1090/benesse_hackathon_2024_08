import 'package:flutter/material.dart';

class StudyRecordPage extends StatelessWidget {
  const StudyRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Record'),
      ),
      body: const Center(
        child: Text('Track and review your study records here.'),
      ),
    );
  }
}
