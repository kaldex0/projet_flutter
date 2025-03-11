import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/db_preference.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedDifficulty = "Facile";
  String _selectedQuizType = "Vrai/Faux";
  final db_preference _preferences = db_preference();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    String difficulty = await _preferences.getDifficulty();
    String quizType = await _preferences.getQuizType();
    setState(() {
      _selectedDifficulty = difficulty;
      _selectedQuizType = quizType;
    });
  }

  Future<void> _updateDifficulty(String difficulty) async {
    setState(() {
      _selectedDifficulty = difficulty;
    });
    await _preferences.setDifficulty(difficulty);
  }

  Future<void> _updateQuizType(String quizType) async {
    setState(() {
      _selectedQuizType = quizType;
    });
    await _preferences.setQuizType(quizType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Difficulté :", style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: _selectedDifficulty,
              items: ["Facile", "Intermédiaire", "Difficile"]
                  .map(
                    (level) => DropdownMenuItem(
                      value: level,
                      child: Text(
                        level,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (BuildContext context) {
                return ["Facile", "Intermédiaire", "Difficile"]
                    .map(
                      (level) => Center(
                        child: Text(
                          level,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList();
              },
              onChanged: (value) {
                if (value != null) {
                  _updateDifficulty(value);
                }
              },
            ),
            SizedBox(height: 20),
            Text("Type de Quiz :", style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: _selectedQuizType,
              items: ["Vrai/Faux", "Multiple"]
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (BuildContext context) {
                return ["Vrai/Faux", "Multiple"]
                    .map(
                      (type) => Center(
                        child: Text(
                          type,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList();
              },
              onChanged: (value) {
                if (value != null) {
                  _updateQuizType(value);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3, onTap: (index) {}),
    );
  }
}