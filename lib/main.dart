import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_data_hub/ProductManagement/AddNewProduct.dart';
import 'firebase_options.dart';
import 'forgetpassword/ChangePassword.dart';
import 'forgetpassword/ForgotPassword.dart';
import 'module/LoginPage.dart';
// import 'forgetpassword/ResetPassword.dart';
// import 'forgetpassword/SendCode.dart';
// import 'forgetpassword/ForgotPassword.dart';
// import 'module/LoginPage.dart';
import 'WareHousePages/MainDashboard.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddNewProduct (),
      //Set LoginPage as the home page
      // home: const ForgotPasswordPage(),
      // home: const ChangePasswordPage(),
    );
  }
}
