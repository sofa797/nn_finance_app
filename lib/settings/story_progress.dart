import 'package:flutter/foundation.dart';

class StoryProgress extends ChangeNotifier {
  final Map<String, int> _progress = {};

  int getIndex(String storyId) => _progress[storyId] ?? 0;

  void next(String storyId, int length) {
    if (_progress[storyId] == null) _progress[storyId] = 0;

    if (_progress[storyId]! < length) {
      _progress[storyId] = _progress[storyId]! + 1;
      notifyListeners();
    }
  }

  void reset(String storyId) {
    _progress[storyId] = 0;
    notifyListeners();
  }

  bool isCompleted(String storyId, int length) {
    return getIndex(storyId) >= length;
  }
}