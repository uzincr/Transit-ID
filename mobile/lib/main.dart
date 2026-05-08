import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TransitIdApp());
}

class TransitIdApp extends StatelessWidget {
  const TransitIdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransitID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A), // Very dark blue/black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F0FF),   // Cyan glow
          secondary: Color(0xFFD400FF), // Purple glow
          surface: Color(0xFF1E2130),   // Card dark color
        ),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
