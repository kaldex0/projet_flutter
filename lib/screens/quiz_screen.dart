import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'scores_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/db_preference.dart';
import '../services/question_service.dart';
import '../services/stats_service.dart';
import '../services/db_fav_stat.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final int _selectedIndex = 1;
  String _quizType = "Vrai/Faux";
  final db_preference _preferences = db_preference();
  Question? _currentQuestion;
  List<String> _answerOptions = [];
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuizType().then((_) {
      _loadQuestion();
    });
  }

  Future<void> _loadQuizType() async {
    String quizType = await _preferences.getQuizType();
    setState(() {
      _quizType = quizType;
    });
  }

  Future<void> _loadQuestion() async {
    String difficulty = await _preferences.getDifficulty();
    Map<String, String> params = QuestionService.mapPreferences(
      prefDifficulty: difficulty,
      prefQuizType: _quizType,
    );

    try {
      List<Question> questions = await QuestionService().fetchQuestions(
        difficulty: params['difficulty']!,
        type: params['type']!,
        amount: 1,
      );
      if (questions.isNotEmpty) {
        Question question = questions.first;
        List<String> options;
        if (question.type.toLowerCase() == 'boolean') {
          options = ["True", "False"];
        } else {
          options = [];
          options.add(question.correctAnswer);
          options.addAll(List<String>.from(question.incorrectAnswers));
          options.shuffle();
        }

        setState(() {
          _currentQuestion = question;
          _answerOptions = options;
          _selectedAnswer = null;
        });
      }
    } catch (e) {
      print("Erreur lors du chargement de la question: $e");
    }
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ScoresScreen()),
      );
    }
  }

  Widget _buildAnswerButton(String answer, double width, Color defaultColor) {
    bool answered = _selectedAnswer != null;
    bool isCorrect = answer == _currentQuestion!.correctAnswer;
    bool selected = answer == _selectedAnswer;

    Widget? icon;
    if (answered) {
      if (isCorrect) {
        icon = Icon(Icons.check, color: Colors.white);
      } else if (selected && !isCorrect) {
        icon = Icon(Icons.close, color: Colors.white);
      }
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => defaultColor,
          ),
        ),
        onPressed: _selectedAnswer == null
            ? () async {
                setState(() {
                  _selectedAnswer = answer;
                });
                bool isCorrect = answer == _currentQuestion!.correctAnswer;
                await StatsService().updateAfterAnswer(isCorrect: isCorrect);
                await StatsService().updateAnswerForDifficulty(
                    isCorrect: isCorrect, difficultyEnglish: _currentQuestion!.difficulty);
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                HtmlUnescape().convert(answer),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 8),
              icon,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double buttonSpacing = 20;
          double buttonWidth;
          if (_currentQuestion == null) {
            return CircularProgressIndicator();
          }
          if (_currentQuestion!.type.toLowerCase() == 'boolean') {
            buttonWidth = (constraints.maxWidth - buttonSpacing) / 2;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnswerButton(_answerOptions[0], buttonWidth, Colors.green),
                SizedBox(width: buttonSpacing),
                _buildAnswerButton(_answerOptions[1], buttonWidth, Colors.red),
              ],
            );
          } else {
            buttonWidth = (constraints.maxWidth - buttonSpacing) / 2;
            List<Color> colors = [Colors.red, Colors.blue, Colors.amber, Colors.green];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildAnswerButton(_answerOptions[0], buttonWidth, colors[0]),
                    SizedBox(width: buttonSpacing),
                    _buildAnswerButton(_answerOptions[1], buttonWidth, colors[1]),
                  ],
                ),
                SizedBox(height: buttonSpacing),
                Row(
                  children: [
                    _buildAnswerButton(_answerOptions[2], buttonWidth, colors[2]),
                    SizedBox(width: buttonSpacing),
                    _buildAnswerButton(_answerOptions[3], buttonWidth, colors[3]),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String decodedQuestion = _currentQuestion != null
        ? HtmlUnescape().convert(_currentQuestion!.question)
        : '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.leaderboard),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScoresScreen()),
            );
          },
        ),
        title: Text("Quiz"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () async {
              if (_currentQuestion != null) {
                await DbFavStat.instance.addFavorite(_currentQuestion!.question);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Favori ajouté")),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _currentQuestion == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("lib/assets/images/question.png", height: 150),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        decodedQuestion,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildAnswerButtons(),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex, onTap: _onItemTapped),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _loadQuestion();
        },
        child: Text(
          _selectedAnswer != null ? "Suivant" : "Skip",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
