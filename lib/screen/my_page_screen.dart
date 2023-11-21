import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = FirebaseAuth.instance;

    return SafeArea(
      child: Column(
        children: [
          Container(
              height: 150,
              width: 300,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[350],
              ),
              child: const Center(child: Text("프로필 정보"))),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: const Row(
              children: [
                Text(
                  "계정 설정",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: const Row(
              children: [
                Text(
                  "모임 관리",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    authentication.signOut();
                  },
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
