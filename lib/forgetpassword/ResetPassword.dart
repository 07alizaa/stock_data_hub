import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isHideNewPassword = true;
  bool isHideConfirmPassword = true;

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
                                "Your new password must be different from previously used password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 25),
                              // New Password Text Field
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2.0),
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
                              // Confirm Password Text Field
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2.0),
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
                                  onPressed: () {
                                    // Save action
                                  },
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