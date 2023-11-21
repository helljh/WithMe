import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteMessage extends StatefulWidget {
  final String docId;
  const WriteMessage({
    required this.docId,
    super.key,
  });

  @override
  State<WriteMessage> createState() => _WriteMessageState();
}

class _WriteMessageState extends State<WriteMessage> {
  var _userEnterMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection("chatting")
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection("chat-list")
        .doc(widget.docId)
        .collection('chat-room')
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': FirebaseAuth.instance.currentUser!.uid
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              //height: 70,
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
                maxLines: null,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
