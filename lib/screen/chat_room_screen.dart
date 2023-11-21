import 'package:flutter/material.dart';
import 'package:likelion_last_project/component/chat/messages.dart';
import 'package:likelion_last_project/component/chat/write_message.dart';

class ChatRoomScreen extends StatefulWidget {
  final String docId;
  const ChatRoomScreen({
    required this.docId,
    super.key,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  bool isSearch = false;
  final _textController = TextEditingController();
  List<String> searchList = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          isSearch = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: isSearch
              ? TextField(
                  controller: _textController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: '검색어를 입력하세요',
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                  ),
                )
              : const Text('도서관에서 공부해요'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSearch = true;
                });
                final searchMessage = _textController.text;
                if (searchMessage.isNotEmpty) {}
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Messages(docId: widget.docId),
            ),
          ),
          WriteMessage(docId: widget.docId),
        ]),
      ),
    );
  }
}
