import 'package:flutter/material.dart';
import 'package:likelion_last_project/screen/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RenderTextFormField(
                      text: '아이디',
                      obscureText: false,
                      controller: email,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RenderTextFormField(
                      text: '비밀번호',
                      obscureText: true,
                      controller: password,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            try {
                              await _authentication.signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              // .then(
                              //   (value) => Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const HomeScreen()),
                              //   ),
                              // );
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "아이디와 비밀번호를 다시 확인해주세요",
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.white10,
                                textColor: Colors.black,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('로그인'),
                        ),
                        const Text('|'),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('회원가입'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF7E600),
                  ),
                  onPressed: () {},
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
                        '카카오로 로그인',
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class RenderTextFormField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;

  const RenderTextFormField({
    required this.text,
    required this.obscureText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        hintText: text,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class RenderTextButton extends StatelessWidget {
  final String text;
  final Widget page;

  const RenderTextButton({
    required this.text,
    required this.page,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // String id = '';
    // String password = '';

    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: Text(text),
    );
  }
}
