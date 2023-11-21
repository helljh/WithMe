import 'package:flutter/material.dart';
import 'package:likelion_last_project/component/home/home_floating_action_button.dart';
import 'package:likelion_last_project/screen/chat_list_screen.dart';
import 'package:likelion_last_project/screen/diary_screen.dart';
import 'package:likelion_last_project/screen/home_screen.dart';
import 'package:likelion_last_project/screen/my_page_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;
  final GlobalKey key = GlobalKey();
  late double navigationBarHeight;

  _getPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      print('높이: ${position.dy}');
      return position.dy;
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderChildren() {
      return [
        const HomeScreen(),
        const ChatScreen(),
        const DiaryScreen(),
        const MyPageScreen(),
      ];
    }

    return Scaffold(
      body: renderChildren().elementAt(selectedIndex),
      floatingActionButton: (selectedIndex == 0)
          ? HomeFloatingActionButton(selectedIndex: selectedIndex)
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              key: key,
              'assets/image/outline_house.png',
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            activeIcon: Image.asset(
              'assets/image/fill_house.png',
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/image/outline_chat.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            activeIcon: Image.asset(
              "assets/image/fill_chat.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/image/outline_calendar.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            activeIcon: Image.asset(
              "assets/image/fill_calendar.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/image/outline_person.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            activeIcon: Image.asset(
              "assets/image/fill_person.png",
              width: 20,
              height: 20,
              color: const Color.fromARGB(255, 27, 27, 27),
            ),
            label: '마이페이지',
          ),
        ],
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }
}
