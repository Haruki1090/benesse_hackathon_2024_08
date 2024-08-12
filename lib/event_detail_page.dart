// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatefulWidget {
  final String community;
  final String eventId;
  final String purpose;

  const EventDetailPage({
    super.key,
    required this.community,
    required this.eventId,
    required this.purpose,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isParticipating = false;

  @override
  void initState() {
    super.initState();
    _checkParticipationStatus();
  }

  Future<void> _checkParticipationStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final participantDoc = await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('events')
          .doc(widget.eventId)
          .collection('participants')
          .doc(user.uid)
          .get();

      setState(() {
        _isParticipating = participantDoc.exists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント詳細'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(widget.purpose)
            .collection('community_list')
            .doc(widget.community)
            .collection('events')
            .doc(widget.eventId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final event = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 16.0),
                Text(event['description'],
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black54)),
                const SizedBox(height: 16.0),
                Text(
                  '日時: ${DateFormat('yyyy年MM月dd日 HH:mm').format((event['date_time'] as Timestamp).toDate())}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.indigo[900]),
                ),
                const SizedBox(height: 16.0),
                _buildParticipationButton(),
                const SizedBox(height: 24.0),
                Text('コメント', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8.0),
                Expanded(child: _buildCommentsSection()),
                const SizedBox(height: 8.0),
                _buildCommentInputField(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticipationButton() {
    if (_isParticipating) {
      return ElevatedButton(
        onPressed: () {
          _cancelParticipation();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            '参加をキャンセルする',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          _joinEvent();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            '参加する',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> _joinEvent() async {
    final user = FirebaseAuth.instance.currentUser;

    // ユーザー名を取得
    final userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) => doc.data()?['name']);

    if (user != null) {
      final eventDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('events')
          .doc(widget.eventId);

      await eventDoc.update({
        'participants': FieldValue.increment(1),
      });

      await eventDoc.collection('participants').doc(user.uid).set({
        'user_id': user.uid,
        'user_name': userName,
        'joined_at': Timestamp.now(),
      });

      setState(() {
        _isParticipating = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('イベントに参加しました！')),
      );
    }
  }

  Future<void> _cancelParticipation() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final eventDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('events')
          .doc(widget.eventId);

      await eventDoc.update({
        'participants': FieldValue.increment(-1),
      });

      await eventDoc.collection('participants').doc(user.uid).delete();

      setState(() {
        _isParticipating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('イベントの参加をキャンセルしました。')),
      );
    }
  }

  Widget _buildCommentsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('events')
          .doc(widget.eventId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final comments = snapshot.data!.docs;

        if (comments.isEmpty) {
          return const Center(child: Text('まだコメントがありません'));
        }

        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(comment['user_name'] ?? '匿名',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(comment['comment']),
                trailing: Text(
                  DateFormat('yyyy/MM/dd HH:mm').format(
                    (comment['timestamp'] as Timestamp).toDate(),
                  ),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'コメントを入力...',
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.blueAccent),
          onPressed: () {
            _postComment();
          },
        ),
      ],
    );
  }

  Future<void> _postComment() async {
    final user = FirebaseAuth.instance.currentUser;

    // ユーザー名を取得
    final userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) => doc.data()?['name']);

    if (user != null && _commentController.text.isNotEmpty) {
      final commentText = _commentController.text.trim();

      final eventDoc = FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.purpose)
          .collection('community_list')
          .doc(widget.community)
          .collection('events')
          .doc(widget.eventId);

      await eventDoc.collection('comments').add({
        'user_id': user.uid,
        'user_name': userName,
        'comment': commentText,
        'timestamp': Timestamp.now(),
      });

      await eventDoc.update({
        'comments_count': FieldValue.increment(1),
      });

      _commentController.clear();
    }
  }
}
