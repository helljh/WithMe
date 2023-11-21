import 'package:flutter/material.dart';

class SharedData extends ChangeNotifier {
  String _searchText = '';

  String get searchText => _searchText;

  void setSearchText(String newText) {
    _searchText = newText;
    print("프로바이더 결과는 : $_searchText");
    notifyListeners(); // 데이터가 변경되었음을 알림
  }
}
