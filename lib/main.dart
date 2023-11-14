import 'package:flutter/material.dart';
import 'views/list_view_screen.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Playing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/listViewScreen': (context) => ListViewScreen(videos: [],),
        // You can add more named routes if needed
      },
    );
  }
}
