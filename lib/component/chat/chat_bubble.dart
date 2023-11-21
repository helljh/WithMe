import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final DateTime time;
  final bool isMe;

  const ChatBubble({
    required this.text,
    required this.time,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(time.toString());
    final timeList = time.toString().split(' ');
    final hour = timeList[1].split(':')[0];
    final minute = timeList[1].split(':')[1];
    final timeExp = '$hour:$minute';
    final textKey = GlobalKey();

    _getSize(GlobalKey key) {
      if (key.currentContext != null) {
        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        Size size = renderBox.size;
        return size;
      } else {
        return null;
      }
    }

    final textWidth = _getSize(textKey)?.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: isMe
                ? Text(
                    timeExp,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[200] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft:
                    isMe ? const Radius.circular(10) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            width: textWidth,
            child: Text(
                key: textKey,
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                )),
          ),
          Container(
            child: isMe
                ? null
                : Text(
                    timeExp,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
