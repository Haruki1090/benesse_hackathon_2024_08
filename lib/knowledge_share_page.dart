import 'package:flutter/material.dart';

class KnowledgeSharePage extends StatelessWidget {
  const KnowledgeSharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Share'),
      ),
      body: const Center(
        child: Text('Here you can share and explore knowledge.'),
      ),
    );
  }
}
