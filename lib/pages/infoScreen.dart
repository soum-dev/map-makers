import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: InfoPage(),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Information')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Authors: ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('soum-dev (Mouhamed Soumare)\nmouhamedsoumare70@gmail.com'),
              SizedBox(height: 16),
              Text("App Description:",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold ),),
              SizedBox(height: 16),
              Text(
                'This app allows users to save and manage their favorite places on a map. '
                'Users can search for locations, mark them as favorites, and view them later.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
