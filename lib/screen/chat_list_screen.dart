import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:likelion_last_project/component/chat/chat_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:likelion_last_project/screen/chat_room_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference chatList = FirebaseFirestore.instance
      .collection('chatting')
      .doc('${FirebaseAuth.instance.currentUser!.email}')
      .collection('chat-list');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const TextField(
                    cursorColor: Color.fromARGB(255, 27, 27, 27),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      suffixIconColor: Color.fromARGB(255, 27, 27, 27),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 27, 27, 27),
                        ),
                      ),
                    ),
                  ),
                ),
                //IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: chatList.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot chat =
                            snapshot.data!.docs[index];

                        print(chat.id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatRoomScreen(docId: chat.id.toString()),
                              ),
                            );
                          },
                          child: ChatBox(
                            title: chat['title'],
                            nickname: chat['nickname'],
                            lastChat: chat['lastChat'],
                            date: chat['date'].toDate(),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
