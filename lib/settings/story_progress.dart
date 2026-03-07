import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoryProgress extends ChangeNotifier {
  final Map<String, int> _progress = {};
  final Set<String> _metCharacters = {};

  int getIndex(String storyId) => _progress[storyId] ?? 0;

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
    _saveToPrefs(); 
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

  bool hasMetCharacter(String characterId) {
    return _metCharacters.contains(characterId);
  }

  Set<String> getMetCharacters() => _metCharacters;

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'progress': _progress,
      'metCharacters': _metCharacters.toList(),
    };
    await prefs.setString('story_progress', jsonEncode(data));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('story_progress');
    
    if (dataString != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(dataString);
        
        if (data['progress'] != null) {
          _progress.clear();
          (data['progress'] as Map).forEach((key, value) {
            _progress[key.toString()] = value as int;
          });
        }
        
        if (data['metCharacters'] != null) {
          _metCharacters.clear();
          _metCharacters.addAll(List<String>.from(data['metCharacters']));
        }
        
        notifyListeners();
      } catch (e) {
        debugPrint('Ошибка загрузки прогресса: $e');
      }
    }
  }


  void load(Map<String, dynamic> data) {
    if (data['progress'] != null) {
      _progress.clear();
      _progress.addAll(Map<String, int>.from(data['progress']));
    }
    if (data['metCharacters'] != null) {
      _metCharacters.clear();
      _metCharacters.addAll(List<String>.from(data['metCharacters']));
    }
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'progress': _progress,
      'metCharacters': _metCharacters.toList(),
    };
  }
}