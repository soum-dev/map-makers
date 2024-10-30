import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritePlacesScreen extends StatefulWidget {
  @override
  _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  List<Map<String, dynamic>> _favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  // Charger les lieux favoris depuis SharedPreferences
  Future<void> _loadFavoritePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedPlaces = prefs.getString('favoritePlaces');

    if (savedPlaces != null) {
      final List<dynamic> placesList = jsonDecode(savedPlaces);
      setState(() {
        _favoritePlaces = List<Map<String, dynamic>>.from(placesList);
      });
    }
  }

  // Supprimer un lieu favori
  Future<void> _removeFavoritePlace(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _favoritePlaces.removeAt(index); // Supprime le lieu de la liste

    // Sauvegarder la liste mise à jour dans SharedPreferences
    await prefs.setString('favoritePlaces', jsonEncode(_favoritePlaces));

    setState(() {}); // Met à jour l'interface utilisateur
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
      ),
      body: _favoritePlaces.isEmpty
          ? Center(child: Text('No favorite places found.'))
          : ListView.builder(
              itemCount: _favoritePlaces.length,
              itemBuilder: (context, index) {
                final place = _favoritePlaces[index];
                return ListTile(
                  title: Text(
                    place['address'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Lat: ${place['lat']}, Lng: ${place['lng']}'),
                  onLongPress: () {
                    _removeFavoritePlace(index);
                  },
                );
              },
            ),
    );
  }
}
