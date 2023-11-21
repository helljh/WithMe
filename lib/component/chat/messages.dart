import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:likelion_last_project/component/chat/chat_bubble.dart';

class Messages extends StatelessWidget {
  final String docId;

  const Messages({
    required this.docId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("채팅방 아이디 $docId");
    final user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance
        .collection('chatting')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('chat-list')
        .doc(docId)
        .collection("chat-room");

    return StreamBuilder(
        stream: collection.orderBy("time", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data!.docs[index];

              return ChatBubble(
                text: chat['text'],
                time: chat['time'].toDate(),
                isMe: chat['userID'] == FirebaseAuth.instance.currentUser!.uid,
              );
            },
          );
        });
  }
}
