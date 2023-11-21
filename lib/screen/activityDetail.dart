import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String title;
  const ActivityDetailScreen({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black54;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('activity')
            .doc("tErCr0TRCuIxtrc9cz8b")
            .collection('activity-list')
            .where("title", isEqualTo: title)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData) {
            print("데이터를 불러오지 못했습니다.");
          }

          final activity = snapshot.data!.docs;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                        iconSize: 15,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 100,
                          child: Text(
                            activity[0]['title'],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InformationWidget(
                      textField: "모임장", textValue: activity[0]['nickname']),
                  InformationWidget(
                      textField: "모집인원",
                      textValue: "${activity[0]['memberCount']}명"),
                  InformationWidget(
                      textField: "활동 시간", textValue: activity[0]['dateTime']),
                  InformationWidget(
                      textField: "활동 장소", textValue: activity[0]['location']),
                  if (activity[0]['description'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "상세 설명",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                          Builder(builder: (context) {
                            return Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.black45,
                                )),
                                child: Text(activity[0]['description']));
                          }),
                        ],
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                                onPressed: () {}, child: const Text("채팅"))),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                                onPressed: () {}, child: const Text("추가"))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InformationWidget extends StatelessWidget {
  final String textField;
  final String textValue;

  const InformationWidget({
    super.key,
    required this.textField,
    required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black54;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        children: [
          Text("$textField | ",
              style: TextStyle(color: textColor, fontSize: 20)),
          Text(
            textValue,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
