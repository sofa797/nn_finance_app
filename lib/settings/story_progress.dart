import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoryProgress extends ChangeNotifier {
  final Map<String, int> _progress = {};
  final Set<String> _metCharacters = {};
  final Map<String, Map<String, String>> _storyChoices = {};


  int getIndex(String storyId) => _progress[storyId] ?? 0; 


  void setChoice(String storyId, String sceneId, String choiceId) {
    _storyChoices.putIfAbsent(storyId, () => {});
    _storyChoices[storyId]![sceneId] = choiceId;
    _saveToPrefs();
    notifyListeners();
  }

  String? getChoice(String storyId, String sceneId) {
    return _storyChoices[storyId]?[sceneId];
  }

  void resetChoices(String storyId) {
    _storyChoices.remove(storyId);
    _saveToPrefs();
    notifyListeners();
  }

  void setIndex(String storyId, int index) {
    _progress[storyId] = index;
    _saveToPrefs();
    notifyListeners();
  }


  final Map<String, int> _goldEarned = {};
  final Map<String, int> _silverEarned = {};



  void next(String storyId, int length) {
    if (_progress[storyId] == null) _progress[storyId] = 0;
    if (_progress[storyId]! < length) {
      _progress[storyId] = _progress[storyId]! + 1;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void reset(String storyId) {
    _progress[storyId] = 0;
    _goldEarned[storyId] = 0;
    _silverEarned[storyId] = 0;
    notifyListeners();
  }

  bool isCompleted(String storyId, int length) {
    return getIndex(storyId) >= length;
  }

  void markCharacterAsMet(String characterId) {
    if (_metCharacters.add(characterId)) {
      notifyListeners(); 
      _saveToPrefs();
    }
  }

  bool hasMetCharacter(String characterId) => _metCharacters.contains(characterId);
  Set<String> getMetCharacters() => _metCharacters;

  void addGold(String storyId, int amount) {
    _goldEarned[storyId] = (_goldEarned[storyId] ?? 0) + amount;
    notifyListeners();
  }

  void addSilver(String storyId, int amount) {
    _silverEarned[storyId] = (_silverEarned[storyId] ?? 0) + amount;
    notifyListeners();
  }

  int getGoldEarned(String storyId) => _goldEarned[storyId] ?? 0;
  int getSilverEarned(String storyId) => _silverEarned[storyId] ?? 0;

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'progress': _progress,
      'metCharacters': _metCharacters.toList(),
      'goldEarned': _goldEarned,
      'silverEarned': _silverEarned,
      'storyChoices': _storyChoices,
    };
    await prefs.setString('story_progress', jsonEncode(data));
  }
}