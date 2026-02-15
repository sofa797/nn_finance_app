import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_menu.dart';
import 'story_screen.dart';
import 'map_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _mapKey = GlobalKey();

  final List<Widget> _pages = const [
    MainMenu(),
    StoryScreen(),
    MapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenBottomTutorial') ?? false;

    if (!seen) {
      _showTutorial();
      await prefs.setBool('seenBottomTutorial', true);
    }
  }

  void _showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "menu",
          keyTarget: _menuKey,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Главный экран приложения",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "history",
          keyTarget: _historyKey,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Раздел с историей финансовой архитектуры",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "map",
          keyTarget: _mapKey,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Интерактивная карта объектов",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black,
      textSkip: "Пропустить",
      paddingFocus: 6,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, key: _menuKey),
            label: "Меню",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, key: _historyKey),
            label: "История",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, key: _mapKey),
            label: "Карта",
          ),
        ],
      ),
    );
  }
}