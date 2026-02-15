import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_menu.dart';
import 'screens/story_screen.dart';
import 'settings/app_settings.dart';
import 'settings/story_progress.dart';
import 'screens/splash_screen.dart';
import 'services/user_location_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => StoryProgress()),
        ChangeNotifierProvider(create: (_) => UserLocationService()),
      ],
      child: const NNFinanceApp(),
    ),
  );
}

class NNFinanceApp extends StatelessWidget {
  const NNFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Финансовый Нижний',
      theme: ThemeData(
        brightness: settings.colorScheme == ColorSchemeOption.dark
            ? Brightness.dark
            : Brightness.light,
        scaffoldBackgroundColor: settings.backgroundColor,
        primaryColor: settings.buttonColor,
        appBarTheme: AppBarTheme(
          backgroundColor: settings.backgroundColor,
          foregroundColor: settings.textColor,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: settings.textColor),
          bodyMedium: TextStyle(color: settings.textColor),
          titleLarge: TextStyle(color: settings.textColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: settings.buttonColor,
            foregroundColor: settings.textColor,
          ),
        ),
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: settings.textScale,
          ),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}