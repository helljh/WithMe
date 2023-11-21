import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:likelion_last_project/screen/login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController pwdCheck = TextEditingController();
  final TextEditingController nickname = TextEditingController();
  final _authentication = FirebaseAuth.instance;

  void flutterToast() {
    Fluttertoast.showToast(
      msg: '회원가입을 축하합니다!',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.white10,
      textColor: Colors.black,
      gravity: ToastGravity.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  RenderTextFormField(
                    text: '이메일',
                    icon: Icons.mail,
                    controller: email,
                    valueKey: 1,
                  ),
                  RenderTextFormField(
                    text: '비밀번호',
                    icon: Icons.lock,
                    controller: pwd,
                    valueKey: 2,
                  ),
                  RenderTextFormField(
                    text: '비밀번호 확인',
                    icon: Icons.lock,
                    controller: pwdCheck,
                    valueKey: 3,
                  ),
                  RenderTextFormField(
                    text: '닉네임',
                    icon: Icons.account_circle,
                    controller: nickname,
                    valueKey: 4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    focusNode: FocusNode(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('취소'),
                  ),
                  const Text('|'),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () async {
                        if (showToastMessage()) {
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: pwd.text,
                            );
                            await FirebaseFirestore.instance
                                .collection("user")
                                .doc(newUser.user!.uid)
                                .set({
                              'nickname': nickname.text,
                              'email': email.text,
                            });
                            if (newUser.user != null) {
                              flutterToast();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                        //
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('가입'),
                    );
                  }),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF7E600),
                  ),
                  onPressed: flutterToast,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/image/chat_fill.png',
                        width: 15,
                        height: 15,
                        color: const Color(0xff3A1D1D),
                      ),
                      const Text(
                        '카카오로 1초 회원가입',
                        style: TextStyle(
                          color: Color(0xff3A1D1D),
                        ),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Image.asset(
                          'assets/image/chat_fill.png',
                          width: 5,
                          height: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setFlutterToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  bool showToastMessage() {
    if (email.text.isEmpty) {
      setFlutterToast("이메일을 입력해주세요");
      return false;
    } else if (pwd.text.isEmpty) {
      setFlutterToast("비밀번호를 입력해주세요");
      return false;
    } else if (pwdCheck.text.isEmpty) {
      setFlutterToast("비밀번호를 한번 더 입력해주세요");
      return false;
    } else if (pwd.text != pwdCheck.text) {
      setFlutterToast("비밀번호가 일치하지 않습니다");
      return false;
    } else if (nickname.text.isEmpty) {
      setFlutterToast("닉네임을 입력해주세요");
      return false;
    } else {
      return true;
    }
  }
}

class RenderTextFormField extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;
  final int valueKey;

  const RenderTextFormField({
    required this.text,
    required this.icon,
    required this.controller,
    required this.valueKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: ValueKey(valueKey),
          controller: controller,
          keyboardType:
              text == "이메일" ? TextInputType.emailAddress : TextInputType.text,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 1),
              prefixIcon: Icon(icon),
              isDense: true,
              suffix: text == "이메일"
                  ? SizedBox(
                      height: 30,
                      child: ElevatedButton(

                        onPressed: () {},
                        child: const Text("인증"),
                      ),
                    )
                  : text == "닉네임"
                      ? SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text("중복확인")),
                        )
                      : null,
              prefixIconColor: Colors.black54,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              labelText: text,
              labelStyle: const TextStyle(
                color: Colors.black54,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
