// SharedPreferences : Gestion paramètres utilisateur 

import 'package:shared_preferences/shared_preferences.dart';

class db_preference {
  static const String _difficultyKey = 'difficulty';
  static const String _quizTypeKey = 'quiz_type';

  Future<void> setDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty);
  }

  Future<String> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_difficultyKey) ?? 'Facile';
  }

  Future<void> setQuizType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quizTypeKey, type);
  }

  Future<String> getQuizType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_quizTypeKey) ?? 'Vrai/Faux';
  }
}
