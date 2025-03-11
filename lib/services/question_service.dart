import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<dynamic> incorrectAnswers;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      difficulty: json['difficulty'],
      category: json['category'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: json['incorrect_answers'],
    );
  }
}

class QuestionService {
  Future<List<Question>> fetchQuestions({
    String difficulty = "easy",
    String type = "multiple",
    int amount = 1,
  }) async {
    final String url =
        'https://opentdb.com/api.php?amount=$amount&difficulty=$difficulty&type=$type';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des questions");
    }

    final data = json.decode(response.body);
    if (data['response_code'] != 0) {
      throw Exception("Aucune question trouvée ou erreur dans l'API");
    }

    List<dynamic> results = data['results'];
    List<Question> questions =
        results.map((q) => Question.fromJson(q)).toList();
    return questions;
  }

  static Map<String, String> mapPreferences({
    required String prefDifficulty,
    required String prefQuizType,
  }) {
    String apiDifficulty = 'easy';
    if (prefDifficulty == "Facile") {
      apiDifficulty = 'easy';
    } else if (prefDifficulty == "Intermédiaire") {
      apiDifficulty = 'medium';
    } else if (prefDifficulty == "Difficile") {
      apiDifficulty = 'hard';
    }

    String apiType = prefQuizType == "Vrai/Faux" ? 'boolean' : 'multiple';

    return {
      'difficulty': apiDifficulty,
      'type': apiType,
    };
  }
}
