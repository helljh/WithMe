import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final userAuth = FirebaseAuth.instance;

// final List<TextEditingController> controllers = List.generate(
//   2,
//   (index) => TextEditingController(),
// );

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  String email = userAuth.currentUser!.email.toString();

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController todoController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String date = DateFormat('M월 d일 E요일', 'ko').format(DateTime.now());

  List<Map<String, dynamic>> schedules = [];

  Future<List<Map<String, dynamic>>>? todoListStream;

  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void saveSchedule(data) {
    firestore.collection("schedule").doc(email).set({"email": email});

    firestore
        .collection("schedule")
        .doc(email)
        .collection("date-schedule")
        .add(data);
  }

  void _loadEvents() {
    firestore
        .collection("schedule")
        .doc(email)
        .collection("date-schedule")
        .snapshots()
        .listen((snapshot) {
      Map<DateTime, List<dynamic>> newEvents = {};
      for (var doc in snapshot.docs) {
        DateTime date = (doc.data()['date'] as Timestamp).toDate();
        newEvents[date] = newEvents[date] ?? [];
        newEvents[date]!.add(doc.data()['todo']);
      }
      setState(() {
        _events = newEvents;
      });
    });
  }

  // Stream<void> saveToFirestore(Map<String, dynamic> data) async {
  //   String userEmail = userAuth.currentUser!.email!;

  //   // Firestore에서 해당 이메일을 가진 문서 검색
  //   var querySnapshot = await firestore
  //       .collection('schedule')
  //       .where('email', isEqualTo: userEmail)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     // 이메일이 존재하지 않는 경우, 새 문서 생성
  //     DocumentReference newDoc = firestore.collection('schedule').doc();
  //     await newDoc.set({'email': userEmail});
  //     await newDoc.collection('date-schedule').add(data);
  //   } else {
  //     // 이메일이 존재하는 경우, 기존 문서의 서브컬렉션에 저장
  //     DocumentReference existingDoc = querySnapshot.docs.first.reference;
  //     await existingDoc.collection('date-schedule').add(data);
  //   }
  // }

  Future<void> selectTime(BuildContext context) async {
    // 시간 선택
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String formattedTime = pickedTime.format(context);

      setState(() {
        timeController.text = formattedTime; // 여기서 TextField에 시간을 설정합니다.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        TableCalendar(
          eventLoader: (date) => _events[date] ?? [],
          //rowHeight: MediaQuery.of(context).size.height * 0.1,
          focusedDay: selectedDay,
          firstDay: DateTime.utc(1900, 1, 1),
          lastDay: DateTime.utc(2999, 12, 31),
          locale: "ko-kr",
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            markerDecoration: const BoxDecoration(
              color: Colors.blue, // 여기서 원하는 색상으로 변경
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            setState(
              () {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                date = DateFormat('M월 d일 E요일', 'ko').format(this.selectedDay);
              },
            );
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.black38,
                    ),
                    iconSize: 15,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("일정 생성"),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: todoController,
                                  decoration: const InputDecoration(
                                    labelText: "일정을 입력해주세요",
                                    labelStyle: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: timeController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          labelText: "시간을 지정해주세요",
                                          labelStyle: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      alignment: Alignment.bottomRight,
                                      onPressed: () {
                                        selectTime(context);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (todoController.text.isNotEmpty &&
                                          timeController.text.isNotEmpty) {
                                        Map<String, String> data = {
                                          "date": date,
                                          "todo": todoController.text,
                                          "time": timeController.text,
                                        };
                                        saveSchedule(data);
                                      }
                                      todoController.clear();
                                      timeController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: firestore
                          .collection("schedule")
                          .doc(email)
                          .collection('date-schedule')
                          .where("date", isEqualTo: date)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData) {
                          return const Text(
                              "No data available for the selected date");
                        }

                        final schedules = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            print("확인사항3 : $schedule");
                            final hour =
                                schedule['time'].toString().split(" ")[0];
                            final day =
                                schedule['time'].toString().split(" ")[1] ==
                                        "AM"
                                    ? "오전"
                                    : "오후";
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        hour,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(schedule['todo'])),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
