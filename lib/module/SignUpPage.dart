import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  final List<String> roles = ['Customer', 'Seller', 'Admin'];
  bool isHidePassword = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isContactValid = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3B5A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel('Full Name'),
              _buildTextField('Enter your full name', controller: nameController),
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
              _buildLabel('Address'),
              _buildTextField('Enter your address', controller: addressController),
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
              _buildLabel('Role'),
              _buildDropdown(),
              const SizedBox(height: 30),
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

  Future<void> _signUp() async {
    if (!_isEmailValid || !_isPasswordValid || !_isContactValid || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields correctly")),
      );
      return;
    }

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up successful')),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _togglePasswordView() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }

  bool _isValidEmail(String email) {
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailRegex).hasMatch(email);
  }

  bool _isValidContact(String contact) {
    String contactRegex = r'^\d{10}$';
    return RegExp(contactRegex).hasMatch(contact);
  }
}