import 'db_fav_stat.dart';

class StatsService {
  final DbFavStat _dbFavStat = DbFavStat.instance;

  Future<void> updateAfterAnswer({required bool isCorrect}) async {
    final stats = await _dbFavStat.getStats();
    int currentSeries = stats?['current_series'] ?? 0;
    int maxSeries = stats?['max_series_win'] ?? 0;

    if (isCorrect) {
      currentSeries++;
      if (currentSeries > maxSeries) {
        maxSeries = currentSeries;
      }
    } else {
      currentSeries = 0;
    }

    await _dbFavStat.updateStats(currentSeries, maxSeries);
  }

  Future<void> updateAnswerForDifficulty({required bool isCorrect, required String difficultyEnglish}) async {
    String difficultyFrench;
    switch (difficultyEnglish.toLowerCase()) {
      case 'easy':
        difficultyFrench = 'Facile';
        break;
      case 'medium':
        difficultyFrench = 'Intermédiaire';
        break;
      case 'hard':
        difficultyFrench = 'Difficile';
        break;
      default:
        difficultyFrench = difficultyEnglish;
    }
    await _dbFavStat.updateDifficultyStat(difficultyFrench, isCorrect: isCorrect);
  }
}
