import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EmotionApp());
}

class EmotionApp extends StatelessWidget {
  const EmotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        primaryColor: const Color(0xFF6C63FF),
      ),
      home: const SplashScreen(),
    );
  }
}