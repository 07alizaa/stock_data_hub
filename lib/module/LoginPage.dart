import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_data_hub/dashboard/suppliers.dart';
import 'package:stock_data_hub/maindashboard/DashboardPage.dart';
import '../WareHousePages/MainDashboard.dart';
import '../forgetpassword/ForgotPassword.dart';

import 'SignUpPage.dart';
// import 'MainDashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHidePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEED9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.15,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "STOCK DATA HUB",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123D59),
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF123D59),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Login to continue using the app",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(height: 25),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: passwordController,
                                obscureText: isHidePassword,
                                decoration: InputDecoration(
                                  hintText: "Enter password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2.0),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(isHidePassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFA726),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: Image.asset('assets/facebook.png'),
                                      iconSize: 30,
                                      onPressed: _loginWithFacebook,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: Image.asset('assets/google.png'),
                                      iconSize: 30,
                                      onPressed: _loginWithGoogle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Don't have an account? Sign up",
                                    style: TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _login() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the user ID
      String userId = userCredential.user?.uid ?? '';

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      // Close loading indicator
      Navigator.of(context).pop();

      if (userDoc.exists) {
        String? role = userDoc['role'];

        // Navigate to the respective dashboard based on the role
        if (role == 'Admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()), // Admin dashboard
                (route) => false,
          );
        } else if (role == 'WareHouse') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  MainDashboard()), // Warehouse dashboard
                (route) => false,
          );
        } else if (role == 'Suppliers') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SuppliersPage()), // Supplier dashboard
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Role not recognized. Please contact support.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found. Please contact support.')),
        );
      }
    } catch (e) {
      // Close loading indicator
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }



  void _togglePasswordView() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }

  void _loginWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login not implemented yet.')),
    );
  }

  void _loginWithFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook login not implemented yet.')),
    );
  }
}
