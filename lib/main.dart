// main.dart
import 'package:flutter/material.dart';
import 'gamescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triangle Wars',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme base
        primarySwatch: Colors.green, // Green color as primary
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 11, 39, 13), // Dark green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // AppBar with green color
          foregroundColor: Colors.white, // Text color in AppBar
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Default text is white
          headlineSmall: TextStyle(color: Colors.greenAccent), // Headline color
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.greenAccent, // Buttons use green accent
          textTheme: ButtonTextTheme.primary, // Text on buttons is primary
        ),
        cardColor: Colors.green[800], // Card color for a unified theme
      ),
      home: GameScreen(),
    );
  }
}
