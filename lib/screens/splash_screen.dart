import 'dart:async';
import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAC876D),
      body: Center(
        child: Image.asset(
          'assets/images/main_logo.png',
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}