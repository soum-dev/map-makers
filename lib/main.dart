import 'package:flutter/material.dart';
import 'package:map_marker/pages/FavoritePlacesScreen.dart';
import 'package:map_marker/pages/infoScreen.dart';
import 'package:map_marker/pages/mapscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M a p  M a r k e r'), centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MapsScreen(),
          FavoritePlacesScreen(),
          const InfoScreen(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Colors.blueAccent,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blueAccent,
        tabs: const [
          Tab(icon: Icon(Icons.map), text: 'Map'),
          Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          Tab(icon: Icon(Icons.info), text: 'Info'),
        ],
      ),
    );
  }
}