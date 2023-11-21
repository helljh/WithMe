import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? title;
  String? email;
  String? nickname;
  String? lastChat;
  String? chatImageUrl;
  String? date;
}

getAllList() async {
  return await FirebaseFirestore.instance
      .collection('chat-list')
      .get()
      .then((value) => value.docs);
}

addList(Chat chat) async {
  await FirebaseFirestore.instance.collection('chat-list').add({
    'title': chat.title,
    'email': chat.email,
    'nickname': chat.nickname,
    'lastChat': chat.lastChat,
    'chatImageUrl': chat.chatImageUrl,
    'data': Timestamp.now()
  });
}
