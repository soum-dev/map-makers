import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(45.521563, 122.677433);
  LatLng? _currentPosition;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  Future<void> _loadFavoritePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedPlaces = prefs.getString('favoritePlaces');

    if (savedPlaces != null) {
      final List<dynamic> placesList = jsonDecode(savedPlaces);
      for (var place in placesList) {
        final marker = Marker(
          markerId: MarkerId(place['id']),
          position: LatLng(place['lat'], place['lng']),
          infoWindow: InfoWindow(
            title: place['placeName'],
            snippet: place['address'],
          ),
        );
        _markers.add(marker);
      }
      setState(() {});
    }
  }

  Future<void> _saveFavoritePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> placesToSave = _markers.map((marker) {
      return {
        'id': marker.markerId.value,
        'lat': marker.position.latitude,
        'lng': marker.position.longitude,
        'placeName': marker.infoWindow.title,
        'address': marker.infoWindow.snippet,
      };
    }).toList();
    await prefs.setString('favoritePlaces', jsonEncode(placesToSave));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
        'https://us1.locationiq.com/v1/search?key=pk.327d3d8eda254e0ea7b6b060d1ffd68f&q=$query&format=json',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body);
      });
    } else {
      print('Erreur lors de la recherche des lieux: ${response.statusCode}');
    }
  }

  void _selectPlace(Map<String, dynamic> place) {
    double lat = double.parse(place['lat']);
    double lng = double.parse(place['lon']);
    String title = place['display_name'];

    LatLng position = LatLng(lat, lng);
    _markPos(position, title, title);

    setState(() {
      _searchResults.clear();
      _searchController.clear();
    });

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15.0),
      ),
    );
  }

  void _addMarker(LatLng position, String title, String address) {
    final marker = Marker(
      markerId: MarkerId(DateTime.now().toIso8601String()),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: address,
        onTap: () => _showMarkerInfoDialog(title, address),
      ),
    );

    setState(() {
      _markers.add(marker);
    });

    _saveFavoritePlaces();
  }

  void _markPos(LatLng position, String title, String address) {
    final marker = Marker(
      markerId: MarkerId(DateTime.now().toIso8601String()),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: address,
        onTap: () => _showMarkerInfoDialog(title, address),
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 11.0,
            ),
            markers: _markers,
            onTap: (LatLng position) {
              _getPlaceInfo(position);
            },
          ),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un lieu...',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _searchPlaces(value);
                  },
                ),
                if (_searchResults.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          title: Text(place['display_name']),
                          onTap: () => _selectPlace(place),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 56,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

    Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 15.0,
          ),
        ),
      );

      _markPos(_currentPosition!, "Votre emplacement", "Vous êtes ici");
    });
  }
  
  void _showMarkerInfoDialog(String title, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails du lieu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom: $title'),
              SizedBox(height: 8),
              Text('Adresse: $address'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _getPlaceInfo(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String title = place.name ?? '';
        if (title.isEmpty) {
          title = place.street ?? 'Lieu inconnu';
        }

        List<String> addressParts = [
          place.street ?? '',
          place.locality ?? '',
          place.postalCode ?? '',
          place.country ?? '',
        ].where((part) => part.isNotEmpty).toList();
        
        String address = addressParts.join(', ');

        _addMarker(position, title, address);
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations de lieu: $e');
      // _showErrorDialog();
    }
  }
}
