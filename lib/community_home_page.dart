// ignore_for_file: use_build_context_synchronously

import 'package:benesse_hackathon_2024_08/auth_gate.dart';
import 'package:benesse_hackathon_2024_08/event_detail_page.dart';
import 'package:benesse_hackathon_2024_08/ranking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityHomePage extends StatelessWidget {
  const CommunityHomePage({super.key});

  Future<Map<String, String?>> _getCommunityData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return {
          'community': doc.data()?['community'] as String?,
          'purpose': doc.data()?['purpose'] as String?,
        };
      }
    }
    return {
      'community': null,
      'purpose': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, String?>>(
          future: _getCommunityData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error');
            } else if (snapshot.hasData &&
                snapshot.data?['community'] != null) {
              return Text(snapshot.data!['community']!);
            } else {
              return const Text('No Community');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
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
      body: FutureBuilder<Map<String, String?>>(
        future: _getCommunityData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading community.'));
          } else if (snapshot.data?['community'] == null ||
              snapshot.data?['purpose'] == null) {
            return const Center(child: Text('No community found.'));
          } else {
            final community = snapshot.data!['community']!;
            final purpose = snapshot.data!['purpose']!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        _showMemberList(context, purpose, community);
                      },
                      child:
                          const Text('メンバーリスト', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
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
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('communities')
                              .doc(purpose)
                              .collection('community_list')
                              .doc(community)
                              .collection('events')
                              .orderBy('date_time', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final events = snapshot.data!.docs;

                            if (events.isEmpty) {
                              return const ListTile(
                                title: Text('現在、予定されているイベントはありません。'),
                              );
                            }

                            return Column(
                              children: events.map((event) {
                                final eventId = event.id;
                                final title = event['title'];

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(title),
                                      subtitle: Text(
                                        '参加表明: ${event['participants']}名, コメント: ${event['comments_count'] ?? 0}件',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailPage(
                                              community: community,
                                              eventId: eventId,
                                              purpose: purpose,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text('$title ランキング'),
                                      subtitle: const Text('ランキングを確認しよう！'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RankingPage(
                                              community: community,
                                              eventId: eventId,
                                              purpose: purpose,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 2),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('communities')
                        .doc(purpose)
                        .collection('community_list')
                        .doc(community)
                        .collection('study_streams')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final streams = [
                        '単語',
                        '文法',
                        '英文解釈',
                        '過去問',
                      ];

                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: streams.length,
                        itemBuilder: (context, index) {
                          final streamId = streams[index];
                          // if (kDebugMode) {
                          //   print('Stream ID: $streamId');
                          // }
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('communities')
                                .doc(purpose)
                                .collection('community_list')
                                .doc(community)
                                .collection('study_streams')
                                .doc(streamId)
                                .collection('posts')
                                .orderBy('timestamp', descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, postSnapshot) {
                              if (postSnapshot.hasError) {
                                // if (kDebugMode) {
                                //   print(
                                //       'Error loading posts for stream $streamId: ${postSnapshot.error}');
                                // }
                                return const Text('Error loading posts');
                              }
                              if (!postSnapshot.hasData ||
                                  postSnapshot.data!.docs.isEmpty) {
                                // if (kDebugMode) {
                                //   print(purpose);
                                //   print(community);
                                //   print('No posts found for stream: $streamId');
                                // }
                                return _buildStreamCard(
                                  context,
                                  streamId,
                                  'まだ投稿はありません',
                                  purpose,
                                  community,
                                  streamId,
                                );
                              } else {
                                final latestPost =
                                    postSnapshot.data!.docs.first;
                                final lastPostedUser =
                                    latestPost['user_name'] ?? '匿名';

                                // if (kDebugMode) {
                                //   print(
                                //       'Last post user for stream $streamId: $lastPostedUser');
                                // }
                                return _buildStreamCard(
                                  context,
                                  streamId,
                                  '最後の投稿: $lastPostedUser',
                                  purpose,
                                  community,
                                  streamId,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showMemberList(BuildContext context, String purpose, String community) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('communities')
              .doc(purpose)
              .collection('community_list')
              .doc(community)
              .collection('members')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final members = snapshot.data!.docs;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(member['name'] ?? 'Unknown'),
                  subtitle: Text(member['email'] ?? 'No Email'),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStreamCard(
    BuildContext context,
    String streamName,
    String lastPostedUser,
    String purpose,
    String community,
    String streamId,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(streamName),
        subtitle: Text(lastPostedUser),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamTimelinePage(
                streamName: streamName,
                purpose: purpose,
                community: community,
              ),
            ),
          );
        },
      ),
    );
  }
}

class StreamTimelinePage extends StatelessWidget {
  final String streamName;
  final String purpose;
  final String community;

  const StreamTimelinePage({
    super.key,
    required this.streamName,
    required this.purpose,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(streamName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(purpose)
            .collection('community_list')
            .doc(community)
            .collection('study_streams')
            .doc(streamName)
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(post['user_name'] ?? '匿名'),
                  subtitle: Text(post['content']),
                  trailing: Text('集中度: ${post['focus_level']}/5'),
                  onTap: () {
                    _showPostDetails(context, post.id, post);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPostDetails(
      BuildContext context, String postId, DocumentSnapshot post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.thumb_up),
              title: Text('いいね (${post['likes'] ?? 0})'),
              onTap: () async {
                // いいねのカウントを増やす処理
                final postRef = FirebaseFirestore.instance
                    .collection('communities')
                    .doc(purpose)
                    .collection('community_list')
                    .doc(community)
                    .collection('study_streams')
                    .doc(streamName)
                    .collection('posts')
                    .doc(postId);

                await postRef.update({
                  'likes': FieldValue.increment(1),
                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('コメントを追加'),
              onTap: () {
                Navigator.pop(context);
                _showAddCommentDialog(context, postId);
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('communities')
                    .doc(purpose)
                    .collection('community_list')
                    .doc(community)
                    .collection('study_streams')
                    .doc(streamName)
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        title: Text(comment['user_name'] ?? '匿名'),
                        subtitle: Text(comment['comment']),
                        trailing: Text(
                          DateFormat('yyyy年MM月dd日 HH:mm').format(
                            (comment['timestamp'] as Timestamp).toDate(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddCommentDialog(BuildContext context, String postId) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('コメントを追加'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(labelText: 'コメント'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                // ユーザー名を取得
                final userName = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get()
                    .then((doc) => doc.data()?['name']);

                if (user != null) {
                  final commentRef = FirebaseFirestore.instance
                      .collection('communities')
                      .doc(purpose)
                      .collection('community_list')
                      .doc(community)
                      .collection('study_streams')
                      .doc(streamName)
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .doc();

                  await commentRef.set({
                    'user_id': user.uid,
                    'user_name': userName,
                    'comment': commentController.text,
                    'timestamp': Timestamp.now(),
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }
}
