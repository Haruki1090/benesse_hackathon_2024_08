// ignore_for_file: library_private_types_in_public_api

import 'package:benesse_hackathon_2024_08/community_home_page.dart';
import 'package:benesse_hackathon_2024_08/knowledge_share_page.dart';
import 'package:benesse_hackathon_2024_08/study_record_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _selectedPages = [
    const CommunityHomePage(),
    const KnowledgeSharePage(),
    const StudyRecordPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Community',
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
