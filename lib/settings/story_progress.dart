import 'package:flutter/material.dart';

class StoryProgress extends ChangeNotifier {
  int index = 0;

  void next(int storyLength) {
    if (index < storyLength) {
      index++;
      notifyListeners();
    }
  }

  void reset() {
    index = 0;
    notifyListeners();
  }
}