import 'package:flutter/material.dart';

enum ColorSchemeOption { standard, blackWhite, dark, beige }

extension ColorSchemeName on ColorSchemeOption {
  String get name {
    switch (this) {
      case ColorSchemeOption.standard:
        return 'Стандартная';
      case ColorSchemeOption.blackWhite:
        return 'Ч/Б';
      case ColorSchemeOption.dark:
        return 'Тёмная';
      case ColorSchemeOption.beige:
        return 'Бежевая';
    }
  }
}

class AppSettings extends ChangeNotifier {
  bool darkTheme = false;
  bool soundEnabled = true;
  bool highContrast = false;

  double textScale = 1.0;

  ColorSchemeOption colorScheme = ColorSchemeOption.standard;
  bool imagesEnabled = true;
  bool effectsEnabled = true;

  void toggleTheme(bool value) {
    darkTheme = value;
    if (value) {
      colorScheme = ColorSchemeOption.dark;
    } else {
      colorScheme = ColorSchemeOption.standard;
    }
    notifyListeners();
  }

  void toggleSound(bool value) {
    soundEnabled = value;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
  }

  void setTextScale(double value) {
    textScale = value;
    notifyListeners();
  }

  void setColorScheme(ColorSchemeOption option) {
    colorScheme = option;
    effectsEnabled = false;
    notifyListeners();
  }

  void toggleImages(bool value) {
    imagesEnabled = value;
    notifyListeners();
  }

  void toggleEffects(bool value) {
    effectsEnabled = value;
    notifyListeners();
  }

  Color get textColor {
    switch (colorScheme) {
      case ColorSchemeOption.standard:
      case ColorSchemeOption.blackWhite:
        return Colors.black;
      case ColorSchemeOption.dark:
        return Colors.white;
      case ColorSchemeOption.beige:
        return Colors.black87;
    }
  }

  Color get backgroundColor {
    switch (colorScheme) {
      case ColorSchemeOption.standard:
      case ColorSchemeOption.blackWhite:
        return Colors.white;
      case ColorSchemeOption.dark:
        return Colors.black;
      case ColorSchemeOption.beige:
        return const Color(0xFFAC876D);
    }
  }

  Color get buttonColor {
    switch (colorScheme) {
      case ColorSchemeOption.standard:
        return Colors.blue.shade600;
      case ColorSchemeOption.blackWhite:
        return Colors.grey.shade800;
      case ColorSchemeOption.dark:
        return Colors.grey.shade700;
      case ColorSchemeOption.beige:
        return const Color(0xFFD8C2A0);
    }
  }

  Color get highlightColor {
    switch (colorScheme) {
      case ColorSchemeOption.standard:
        return Colors.yellow.shade100;
      case ColorSchemeOption.blackWhite:
        return Colors.grey.shade300;
      case ColorSchemeOption.dark:
        return Colors.grey.shade800;
      case ColorSchemeOption.beige:
        return const Color(0xFFEAD8B0);
    }
  }

  Color get borderColor {
    switch (colorScheme) {
      case ColorSchemeOption.standard:
        return Colors.grey.shade300;
      case ColorSchemeOption.blackWhite:
        return Colors.black;
      case ColorSchemeOption.dark:
        return Colors.grey.shade700;
      case ColorSchemeOption.beige:
        return Colors.brown.shade200;
    }
  }
}