import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:likelion_last_project/screen/map_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final userAuth = FirebaseAuth.instance;

class HomeFloatingActionButton extends StatefulWidget {
  final int selectedIndex;

  const HomeFloatingActionButton({
    required this.selectedIndex,
    super.key,
  });

  @override
  State<HomeFloatingActionButton> createState() =>
      _HomeFloatingActionButtonState();
}

class _HomeFloatingActionButtonState extends State<HomeFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    bool isClicked = false;
    TextEditingController searchController = TextEditingController();
    final List<TextEditingController> controllers = List.generate(
      6,
      (index) => TextEditingController(),
    );

    @override
    void dispose() {
      for (var controller in controllers) {
        controller.dispose();
      }

      super.dispose();
    }

    Color iconBgColor = const Color.fromARGB(255, 255, 255, 255);
    Color iconFgColor = const Color.fromARGB(255, 100, 100, 100);

    List<FaIcon> icons = [
      FaIcon(
        FontAwesomeIcons.pencil,
        color: Colors.orange[300],
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.utensils,
        color: Colors.green[300],
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.gamepad,
        color: Colors.blue[300],
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.globe,
        color: Colors.purple[300],
        size: 15,
      ),
    ];

    List<String> studyCreateQuestion = [
      '1. 방 제목을 정해주세요',
      '2. 무슨 공부를 하실건가요?',
      '3. 최대 인원수를 입력해주세요',
      '4. 모임 시간을 입력해주세요',
      '5. 모임 장소를 입력해주세요',
      '6. 추가 정보를 입력해주세요',
    ];

    List<String> foodCreateQuestion = [
      '1. 방 제목을 입력해주세요',
      '2. 어떤 음식을 드실건가요?',
      '3. 최대 인원수를 입력해주세요',
      '4. 모임 시간을 입력해주세요',
      '5. 모임 장소를 입력해주세요',
      '6. 추가 정보를 입력해주세요',
    ];

    List<String> hobbyCreateQuestion = [
      '1. 방 제목을 입력해주세요',
      '2. 무엇을 하실건가요?',
      '3. 최대 인원수를 입력해주세요',
      '4. 모임 시간을 입력해주세요',
      '5. 모임 장소를 입력해주세요',
      '6. 추가 정보를 입력해주세요',
    ];

    List<String> freeCreateQuestion = [
      '1. 제목을 입력해주세요',
      '2. 질문사항이나 공유사항을 자유롭게 작성해주세요',
    ];

    return SpeedDial(
      overlayOpacity: 0.3,
      icon: Icons.add,
      foregroundColor: iconFgColor,
      backgroundColor: iconBgColor,
      children: [
        customSpeedDialChild(icons[0], '공부', iconBgColor, context,
            studyCreateQuestion, controllers),
        customSpeedDialChild(icons[1], '식사', iconBgColor, context,
            foodCreateQuestion, controllers),
        customSpeedDialChild(icons[2], '취미', iconBgColor, context,
            hobbyCreateQuestion, controllers),
        customSpeedDialChild(icons[3], '자유', iconBgColor, context,
            freeCreateQuestion, controllers),
      ],
    );
  }

  SpeedDialChild customSpeedDialChild(
    FaIcon icon,
    String title,
    Color iconBgColor,
    BuildContext context,
    List<String> questionList,
    List<TextEditingController> controllers,
  ) {
    return SpeedDialChild(
      child: icon,
      backgroundColor: iconBgColor,
      label: title,
      labelStyle: const TextStyle(fontSize: 13),
      onTap: () {
        ShowDialog(
          context,
          questionList,
          title,
          controllers,
        );
      },
    );
  }

  Future<Map<String, dynamic>> searchAddress(String address) async {
    const String clientId = 'YOUR_CLIENT_ID'; // 발급받은 Client ID
    const String clientSecret = 'YOUR_CLIENT_SECRET'; // 발급받은 Client Secret

    final response = await http.get(
      Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address'),
      headers: {
        "X-NCP-APIGW-API-KEY-ID": clientId,
        "X-NCP-APIGW-API-KEY": clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['addresses'].isNotEmpty) {
        final addr = jsonResponse['addresses'][0];
        return {
          "latitude": addr['y'],
          "longitude": addr['x'],
        };
      } else {
        return {};
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

  Future<void> showOnMap(double latitude, double longitude) async {
    const platform = MethodChannel('com.example.likelion_last_project/map');

    try {
      final result = await platform.invokeMethod('showMap', {
        'latitude': latitude,
        'longitude': longitude,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to show map: '${e.message}'.");
    }
  }

  Future<void> saveToFirestore(Map<String, dynamic> data) async {
    // final makeActivityDoc = await firestore.collection('activity').add({
    //   "email": user.currentUser!.email,
    // });
    // final makeListDoc =
    //     await makeActivityDoc.collection('activity-list').add(data);
    final userEmail = userAuth.currentUser!.email;

    var querySnapshot = await firestore
        .collection('activity')
        .where('email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // 이메일이 존재하지 않는 경우, 새 문서 생성
      DocumentReference newDoc = firestore.collection('activity').doc();
      await newDoc.set({'email': userEmail});
      await newDoc.collection('activity-list').add(data);
    } else {
      // 이메일이 존재하는 경우, 기존 문서의 서브컬렉션에 저장
      DocumentReference existingDoc = querySnapshot.docs.first.reference;
      await existingDoc.collection('activity-list').add(data);
    }
  }

  Future<DateTime?> selectDateAndTime(BuildContext context) async {
    // 날짜 선택
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2999),
    );

    if (pickedDate == null) return null;

    // 시간 선택
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    // 선택된 날짜와 시간을 결합
    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);
  }

  Future<dynamic> ShowDialog(BuildContext context, List<String> questionList,
      String title, List<TextEditingController> controllers) {
    TextInputType currentKeyboardType = TextInputType.text;

    List<Widget> textFieldList = [
      TextField(
        controller: controllers[0],
        keyboardType: currentKeyboardType,
        cursorColor: Colors.black54,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      TextField(
        controller: controllers[1],
        keyboardType: currentKeyboardType,
        cursorColor: Colors.black54,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      TextField(
        controller: controllers[2],
        cursorColor: Colors.black54,
        textAlign: TextAlign.end,
        keyboardType: currentKeyboardType,
        decoration: const InputDecoration(
          suffixText: '명',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      TextField(
        controller: controllers[3],

        // 선택된 날짜 표시
        readOnly: true, // 편집 불가능하게 설정
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.calendarDays,
              size: 15,
            ),
            onPressed: () async {
              DateTime? selectedDateTime = await selectDateAndTime(context);
              if (selectedDateTime != null) {
                final date = selectedDateTime.toString().split(" ")[0];
                final time = selectedDateTime.toString().split(" ")[1];
                // 선택된 날짜와 시간 처리
                controllers[3].text = int.parse(time.split(":")[0]) < 12
                    ? "${date.split("-")[1]}/${date.split("-")[2]} 오전 ${time.split(":")[0]}시 ${time.split(":")[1]}분"
                    : "${date.split("-")[1]}/${date.split("-")[2]} 오후 ${int.parse(time.split(":")[0]) - 12}시 ${time.split(":")[1]}분";
              }
            },
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      TextField(
        controller: controllers[4],
        cursorColor: Colors.black54,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 15,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapSearchScreen(),
                ),
              );
            },
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      TextField(
        controller: controllers[5],
        cursorColor: Colors.black54,
        keyboardType: currentKeyboardType,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: '100자 이내로 입력해주세요(필수입력 x)',
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    ];

    List<Widget> freeFieldList = [
      TextField(
        controller: controllers[0],
      ),
      TextField(
        controller: controllers[1],
        cursorColor: Colors.black54,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: '100자 이내로 입력해주세요(필수입력 x)',
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    ];

    int questionIndex = 0;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StatefulBuilder(builder: (context, setState) {
            void updateKeyboardType(int index) {
              if (index == 2) {
                currentKeyboardType = TextInputType.number;
              } else {
                currentKeyboardType = TextInputType.text;
              }
              setState(() {}); // StatefulBuilder의 상태를 업데이트
            }

            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Opacity(
                        opacity: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 15,
                          ),
                          onPressed: null,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 15,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            questionIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(questionList[questionIndex]),
                        questionIndex == 2
                            ? StatefulBuilder(
                                builder: ((context, setState) {
                                  return TextField(
                                    controller: controllers[2],
                                    cursorColor: Colors.black54,
                                    textAlign: TextAlign.end,
                                    keyboardType: currentKeyboardType,
                                    decoration: const InputDecoration(
                                      suffixText: '명',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : title == "자유"
                                ? freeFieldList[questionIndex]
                                : textFieldList[questionIndex],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          color: Colors.black54,
                          onPressed: () {
                            setState(() {
                              if (questionIndex > 0) {
                                questionIndex--;
                                updateKeyboardType(questionIndex);
                              }
                            });
                          },
                          icon: questionIndex > 0
                              ? const Icon(Icons.arrow_back)
                              : const Opacity(
                                  opacity: 0, child: Icon(Icons.arrow_back)),
                        ),
                        IconButton(
                          color: Colors.black54,
                          onPressed: questionIndex < questionList.length - 1
                              ? () {
                                  setState(() {
                                    questionIndex++;
                                    updateKeyboardType(questionIndex);
                                  });
                                }
                              : () {
                                  if (title != "자유") {
                                    Map<String, dynamic> data = {
                                      "title": controllers[0].text,
                                      "subject": controllers[1].text,
                                      "category": title,
                                      "memberCount": controllers[2].text,
                                      "dateTime": controllers[3].text,
                                      "location": controllers[4].text,
                                      "description": controllers[5].text,
                                    };

                                    saveToFirestore(data);
                                  } else {
                                    Map<String, dynamic> data = {
                                      "title": controllers[0].text,
                                      "category": title,
                                      "content": controllers[1].text,
                                      "time": Timestamp.now(),
                                    };

                                    saveToFirestore(data);
                                  }
                                  setState(() {
                                    for (int i = 0;
                                        i < controllers.length;
                                        i++) {
                                      controllers[i].clear();
                                    }

                                    questionIndex = 0;
                                  });
                                  // Dialog 닫기 및 상태 초기화
                                  Navigator.of(context).pop();
                                },
                          icon: questionIndex < questionList.length - 1
                              ? const Icon(
                                  Icons.arrow_forward,
                                )
                              : const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
