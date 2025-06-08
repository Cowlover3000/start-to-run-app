import 'package:flutter/material.dart';
// TODO: Uncomment these imports when implementing features
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const StartToRunApp());
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start to Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Start to Run'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Start to Run!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
