import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
    final int currentIndex;
    final Function(int) onTap;

    const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

    @override
    _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
    int _currentIndex = 0;

    @override
    void initState() {
        super.initState();
        _currentIndex = widget.currentIndex;
    }

    void _onItemTapped(int index) {
        setState(() {
            _currentIndex = index;
        });
        switch(index) {
            case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                break;
            case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizScreen()));
                break;
            case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FavoritesScreen()));
                break;
            case 3:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
                break;
        }
    }

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            backgroundColor: Color(0xFF372041),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
                BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quiz"),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favoris"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
            ],
        );
    }
}
