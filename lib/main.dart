import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_data_hub/WareHousePages/MainDashboard.dart';
import 'firebase_options.dart';
import 'module/HomePage.dart';
import 'module/LoginPage.dart';
// import 'module/ChangePassword.dart';
// import 'module/ForgotPassword.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // Change to Maindashboard() if needed
    );
  }
}
