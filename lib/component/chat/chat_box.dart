import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final String title;
  //final String email;
  final String nickname;
  final String lastChat;
  final DateTime date;

  const ChatBox({
    required this.title,
    //required this.email,
    required this.nickname,
    required this.lastChat,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade500),
            bottom: BorderSide(color: Colors.grey.shade500),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.1,
              child: SizedBox(
                  width: 10,
                  height: 10,
                  child: Image.asset("assets/image/outline_person.png")),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                              fontSize: 20,
                            )),
                        //Text(email),
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Text(nickname),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(lastChat),
                        ),
                        Text(
                            '${date.toString().split(' ')[0].split('-')[1]}월 ${date.toString().split(' ')[0].split('-')[2]}일'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
