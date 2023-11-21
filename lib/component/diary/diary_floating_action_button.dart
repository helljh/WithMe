import 'package:flutter/material.dart';

class DiaryFloatingActionButton extends StatelessWidget {
  const DiaryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.black54,
      backgroundColor: Colors.white,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: StatefulBuilder(builder: (context, setState) {
                return const AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('일정 생성'),
                    ],
                  ),
                );
              }),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
