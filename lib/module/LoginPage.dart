import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_data_hub/maindashboard/DashboardPage.dart';
import '../WareHousePages/MainDashboard.dart';
import '../forgetpassword/ForgotPassword.dart';
import 'SignUpPage.dart';

/// Login Page for the Stock Data Hub Application
/// This page allows users to log in using their email and password
/// and navigates them to the appropriate dashboard based on their role.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to handle email and password input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Toggles for hiding/showing the password
  bool isHidePassword = true;

  // Firebase authentication and Firestore instances
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
                      // App Logo Section
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

                      // App Title Section
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

                      // Login Form Section
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
                              // Login Header
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

                              // Email Input Field
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

                              // Password Input Field
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

                              // Forgot Password Section
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

                              // Login Button
                              Center(
                                child: ElevatedButton(
                                  onPressed: _login, // Calls the login function
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

                              // Alternative Login Methods
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Facebook Login Button
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

                                  // Google Login Button
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

                              // Sign Up Section
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

  /// Function to handle user login
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
      // Authenticate user using email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Fetch the user role from Firestore
      String userId = userCredential.user?.uid ?? '';
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      // Close the loading indicator
      Navigator.of(context).pop();

      if (userDoc.exists) {
        String? role = userDoc['role'];

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Successful"),
              content: const Text("You have successfully logged in!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog

                    // Navigate to the appropriate dashboard
                    if (role == 'Admin') {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardPage()),
                            (route) => false,
                      );
                    } else if (role == 'WareHouse') {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainDashboard()),
                            (route) => false,
                      );
                    } else {
                      _showErrorSnackbar('Role not recognized. Please contact support.');
                    }
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorSnackbar('User data not found. Please contact support.');
      }
    } catch (e) {
      // Close the loading indicator and show the error
      Navigator.of(context).pop();
      _showErrorSnackbar('Error: ${e.toString()}');
    }
  }

  /// Toggles password visibility
  void _togglePasswordView() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }

  /// Placeholder for Google login
  void _loginWithGoogle() {
    _showErrorSnackbar('Google login not implemented yet.');
  }

  /// Placeholder for Facebook login
  void _loginWithFacebook() {
    _showErrorSnackbar('Facebook login not implemented yet.');
  }

  /// Utility function to show error messages
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
}
