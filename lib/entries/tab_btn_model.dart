import 'package:flutter/material.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class TabButtonModel with ChangeNotifier {
  int index = 0;
  bool isTapped = false;

  void updateIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  Color animateColor(int index, Color matched, Color unmatched) {
    return this.index == index ? matched : unmatched;
  }

  double animateSize(int index) {
    return this.index == index ? globals.tabBoxSize : 34;
  }

  double translateX(int index) {
    if (this.index == 0) {
      return globals.tabBoxSize;
    }
    else if (this.index == 1) {
      return 0;
    }
    else {
      return -globals.tabBoxSize;
    }
  }
  double animateMargin(int index) {
    return this.index == index ? 20 : 0;
  }
}