import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseDark = ThemeData.dark();
    return MaterialApp(
      title: 'Chennai Metro App',
      theme: baseDark.copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: baseDark.textTheme.apply(fontFamily: 'Inter'),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          surface: const Color(0xFF121212),
          onSurface: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}