import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz Time")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/images/quiz.png", height: 150),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen()));
              },
              child: Text("Commencer"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
