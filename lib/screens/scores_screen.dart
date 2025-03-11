import 'package:flutter/material.dart';
import '../services/db_fav_stat.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  Future<Map<String, dynamic>> _fetchStats() async {
    Map<String, dynamic>? stats = await DbFavStat.instance.getStats();
    int favoritesCount = await DbFavStat.instance.countFavorites();
    if (stats == null) {
      stats = {'max_series_win': 0, 'current_series': 0};
    }
    Map<String, Map<String, int>> difficultyStats = await DbFavStat.instance.getAllDifficultyStats();

    return {
      'global': stats,
      'favoritesCount': favoritesCount,
      'difficulty': difficultyStats,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scores")),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur: ${snapshot.error}"));
            } else {
              final globalStats = snapshot.data!['global'];
              final int favoritesCount = snapshot.data!['favoritesCount'];
              final difficultyStats = snapshot.data!['difficulty'] as Map<String, Map<String, int>>;
              int maxSeriesWin = globalStats['max_series_win'];
              
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Max séries gagnées: $maxSeriesWin",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Nombre de favoris: $favoritesCount",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Vos réponses par difficulté",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            "Difficulté",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Vrai",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Faux",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: difficultyStats.entries.map((entry) {
                        final difficulty = entry.key;
                        final correct = entry.value['correct'];
                        final incorrect = entry.value['incorrect'];
                        return DataRow(cells: [
                          DataCell(Text(difficulty, style: TextStyle(fontSize: 16))),
                          DataCell(Text("$correct", style: TextStyle(fontSize: 16))),
                          DataCell(Text("$incorrect", style: TextStyle(fontSize: 16))),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
