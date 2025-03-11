import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'assets/style/style.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}