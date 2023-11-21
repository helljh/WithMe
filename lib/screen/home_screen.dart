import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:likelion_last_project/screen/activityDetail.dart';
import 'package:likelion_last_project/screen/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance;

  Stream<List<String>> getActivityTitlesStream() {
    // 'activity' 컬렉션에 대한 스트림 생성
    return firestore
        .collection('activity')
        .snapshots()
        .asyncMap((snapshot) async {
      List<String> titles = [];

      // 각 문서에 대한 'activity-list' 서브컬렉션 접근
      for (var doc in snapshot.docs) {
        var activityListSnapshot =
            await doc.reference.collection('activity-list').get();

        // 각 서브컬렉션 문서에서 'title' 필드 추출
        for (var listDoc in activityListSnapshot.docs) {
          var title = listDoc.data()['title'] as String?; // 'title' 필드 값
          if (title != null) {
            titles.add(title);
          }
        }
      }

      return titles;
    });
  }

  String subject = "공부";

  void getCategory(String category) {
    setState(() {
      subject = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color iconBgColor = const Color.fromARGB(255, 255, 255, 255);
    Color iconFgColor = const Color.fromARGB(150, 0, 0, 0);

    List<FaIcon> icons = [
      FaIcon(
        FontAwesomeIcons.pencil,
        color: iconFgColor,
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.utensils,
        color: iconFgColor,
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.gamepad,
        color: iconFgColor,
        size: 15,
      ),
      FaIcon(
        FontAwesomeIcons.globe,
        color: iconFgColor,
        size: 15,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const MapScreen(),
            DraggableScrollableSheet(
              initialChildSize: 0.05, // 시작 시 Sheet의 높이 (전체 높이의 10%)
              minChildSize: 0.05, // 최소 Sheet 높이
              maxChildSize: 0.8, // 최대 Sheet 높이
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: const Offset(0, -2), // 그림자의 방향 조정
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        // 여기에 원하는 내용 추가
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: Colors.black54,
                                  ),
                                  Text(
                                    '글 목록으로 보기',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomElevatedButton(
                                      color: Colors.orange[50],
                                      icon: icons[0],
                                      category: '공부',
                                      getCategory: getCategory),
                                  CustomElevatedButton(
                                      color: Colors.green[50],
                                      icon: icons[1],
                                      category: '식사',
                                      getCategory: getCategory),
                                  CustomElevatedButton(
                                      color: Colors.blue[50],
                                      icon: icons[2],
                                      category: '취미',
                                      getCategory: getCategory),
                                  CustomElevatedButton(
                                      color: Colors.purple[50],
                                      icon: icons[3],
                                      category: '자유',
                                      getCategory: getCategory),
                                ],
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("activity")
                                  .doc("tErCr0TRCuIxtrc9cz8b")
                                  .collection("activity-list")
                                  .where("category", isEqualTo: subject)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (!snapshot.hasData) {
                                  return const Text('No titles found');
                                }

                                final activity = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: activity.length,
                                  itemBuilder: (context, index) {
                                    if (activity[index]['category'] != "자유") {
                                      return ActivityWidget(
                                        title: activity[index]['title'],
                                        member: activity[index]['memberCount'],
                                        time: activity[index]['dateTime'],
                                        place: activity[index]['location'],
                                        category: activity[index]['category'],
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color:
                                                      Colors.purple.shade100),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 5,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      activity[index]['title'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Text(activity[index]
                                                        ['content']),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),

                            // const ActivityWidget(
                            //   title: "도서관 스터디룸에서 같이 공부하실 분",
                            //   member: "2/6",
                            //   time: "오후 3시",
                            //   place: "유담관 8층",
                            // ),
                            // const ActivityWidget(
                            //   title: "매주 수요일 토익 스터디 부원 모집중",
                            //   member: "3/5",
                            //   time: "오후 5시",
                            //   place: "듀드롭",
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityWidget extends StatelessWidget {
  final String title;
  final String member;
  final String time;
  final String place;
  final String category;

  const ActivityWidget({
    required this.title,
    required this.member,
    required this.time,
    required this.place,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: category == "공부"
                ? BorderSide(color: Colors.orange.shade100)
                : category == "식사"
                    ? BorderSide(color: Colors.green.shade100)
                    : category == "취미"
                        ? BorderSide(color: Colors.blue.shade100)
                        : BorderSide(color: Colors.purple.shade100),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(title: title)));
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 5,
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.user,
                            size: 10,
                          ),
                        ),
                        Text(member),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.clock,
                            size: 10,
                          ),
                        ),
                        Text(time),
                      ]),
                    ),
                    Row(children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 5,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 10,
                        ),
                      ),
                      Text(place),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatefulWidget {
  final dynamic color;
  final FaIcon icon;
  final String category;
  final Function getCategory;

  const CustomElevatedButton({
    super.key,
    required this.color,
    required this.icon,
    required this.category,
    required this.getCategory,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          widget.getCategory(widget.category);
        });
      },
      child: Row(
        children: [
          widget.icon,
          Container(
            margin: const EdgeInsets.only(
              left: 5,
            ),
            child: Text(widget.category),
          ),
        ],
      ),
    );
  }
}
