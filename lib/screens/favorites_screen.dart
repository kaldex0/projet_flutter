import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/db_fav_stat.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchFavorites() async {
    return await DbFavStat.instance.getFavorites();
  }

  void _removeFavorite(int id) async {
    await DbFavStat.instance.removeFavorite(id);
    setState(() {}); // Actualiser la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoris")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { // En attente
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { // Erreur
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Pas de données
            return Center(child: Text("Aucun favori"));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final fav = favorites[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      HtmlUnescape().convert(fav['question'] as String? ?? ''),
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.star, color: Colors.yellow),
                      onPressed: () {
                        _removeFavorite(fav['id'] as int);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {},
      ),
    );
  }
}