import 'package:flutter/material.dart';

class TabButtonModel with ChangeNotifier {
  int index = 0;
  bool isTapped = false;
  double maxSize;

  TabButtonModel({required this.maxSize});

  void updateIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  bool canAnimate(int index) {
    return this.index == index;
  }
}