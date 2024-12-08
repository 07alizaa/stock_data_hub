import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../module/LoginPage.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isHideCurrentPassword = true;
  bool isHideNewPassword = true;
  bool isHideConfirmPassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  void _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirm password do not match.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      String currentPassword = currentPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();

      if (user?.email == null) {
        throw FirebaseAuthException(
          code: 'no-email',
          message: 'No email associated with the current user.',
        );
      }

      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user!.reauthenticateWithCredential(credential);

      // Update the password
      await user!.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Sign out the user and navigate to the login page
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-mismatch':
          errorMessage = 'The supplied credentials do not match any user.';
          break;
        case 'wrong-password':
          errorMessage = 'The current password is incorrect.';
          break;
        case 'invalid-credential':
          errorMessage = 'The credentials are invalid or expired.';
          break;
        case 'no-email':
          errorMessage = e.message ?? 'No email found.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $errorMessage'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

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
                                "Your new password must be different from your current password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                "Current Password",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: currentPasswordController,
                                obscureText: isHideCurrentPassword,
                                decoration: InputDecoration(
                                  hintText: "Enter current password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHideCurrentPassword = !isHideCurrentPassword;
                                      });
                                    },
                                    child: Icon(isHideCurrentPassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                "New Password",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: newPasswordController,
                                obscureText: isHideNewPassword,
                                decoration: InputDecoration(
                                  hintText: "Enter new password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHideNewPassword = !isHideNewPassword;
                                      });
                                    },
                                    child: Icon(isHideNewPassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                "Confirm Password",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: confirmPasswordController,
                                obscureText: isHideConfirmPassword,
                                decoration: InputDecoration(
                                  hintText: "Enter confirm password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHideConfirmPassword = !isHideConfirmPassword;
                                      });
                                    },
                                    child: Icon(isHideConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFA726),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
}
