import 'package:flutter/material.dart';
import 'WareHousePages/Maindashboard.dart'; // Ensure the correct file is imported

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Maindashboard(), // Entry point to the Main Dashboard
      theme: ThemeData(
        primaryColor: const Color(0xFF123D59), // Dark teal
        scaffoldBackgroundColor: const Color(0xFFF5E5D7), // Nude
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF123D59),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF123D59)), // Updated for Flutter 3.x
          bodyMedium: TextStyle(color: Color(0xFF123D59)), // For smaller text
        ),
        useMaterial3: true,
      ),
    );
  }
}
