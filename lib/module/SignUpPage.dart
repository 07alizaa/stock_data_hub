import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_data_hub/module/LoginPage.dart'; // Replace with the actual path to your LoginPage widget

/// SignUp Page for Warehouse and Admin Users
/// This page allows users to register by entering their details and selecting their role.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for user input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Role selection
  String? selectedRole;
  final List<String> roles = ['WareHouse', 'Admin']; // Roles available for selection

  // Form validation
  bool isHidePassword = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isContactValid = true;

  // Firebase services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3B5A), // Background color of the page
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              const Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Full Name Field
              _buildLabel('Full Name'),
              _buildTextField(
                'Enter your full name',
                controller: nameController,
              ),

              // Phone Number Field
              _buildLabel('Phone No'),
              _buildTextField(
                'Enter your phone number',
                controller: phoneController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _isContactValid = _isValidContact(value);
                  });
                },
                errorText: _isContactValid ? null : 'Enter a valid contact number',
              ),

              // Email Field
              _buildLabel('Email'),
              _buildTextField(
                'Enter your email',
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    _isEmailValid = _isValidEmail(value);
                  });
                },
                errorText: _isEmailValid ? null : 'Enter a valid email address',
              ),

              // Address Field
              _buildLabel('Address'),
              _buildTextField(
                'Enter your address',
                controller: addressController,
              ),

              // Password Field
              _buildLabel('Password'),
              _buildTextField(
                'Enter password',
                controller: passwordController,
                isPassword: true,
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = value.length >= 8;
                  });
                },
                errorText: _isPasswordValid ? null : 'Password must be at least 8 characters',
              ),

              // Role Dropdown
              _buildLabel('Role'),
              _buildDropdown(),

              const SizedBox(height: 30),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE69A5C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: Build a label for form fields
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Widget: Build a reusable text input field
  Widget _buildTextField(
      String hint, {
        required TextEditingController controller,
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
        String? errorText,
        Function(String)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isHidePassword : false,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          errorText: errorText,
          filled: true,
          fillColor: const Color(0xFFF5E6D3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? InkWell(
            onTap: _togglePasswordView,
            child: Icon(isHidePassword ? Icons.visibility_off : Icons.visibility),
          )
              : null,
        ),
      ),
    );
  }

  /// Widget: Build the role dropdown
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      hint: const Text('Select your role'),
      items: roles.map((role) {
        return DropdownMenuItem(value: role, child: Text(role));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedRole = value;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5E6D3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Function: Handle Sign Up logic
  Future<void> _signUp() async {
    // Validate fields
    if (!_isEmailValid || !_isPasswordValid || !_isContactValid || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields correctly")),
      );
      return;
    }

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Register user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user details to Firestore
      String userId = userCredential.user?.uid ?? '';
      await _firestore.collection('users').doc(userId).set({
        'full_name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'role': selectedRole,
      });

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration complete. Please log in.')),
      );

      // Navigate to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Hide loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Function: Toggle Password Visibility
  void _togglePasswordView() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }

  /// Utility: Validate email format
  bool _isValidEmail(String email) {
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailRegex).hasMatch(email);
  }

  /// Utility: Validate contact format
  bool _isValidContact(String contact) {
    String contactRegex = r'^\d{10}$';
    return RegExp(contactRegex).hasMatch(contact);
  }
}
