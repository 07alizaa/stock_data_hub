// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'ChangePassword.dart';
//
// class SendCodePage extends StatefulWidget {
//   final String email;
//   final String verificationCode;
//
//   const SendCodePage({Key? key, required this.email, required this.verificationCode}) : super(key: key);
//
//   @override
//   _SendCodePageState createState() => _SendCodePageState();
// }
//
// class _SendCodePageState extends State<SendCodePage> {
//   final List<TextEditingController> codeControllers = List.generate(4, (index) => TextEditingController());
//
//   @override
//   void dispose() {
//     for (var controller in codeControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   void _verifyCode() {
//     String enteredCode = codeControllers.map((controller) => controller.text).join();
//
//     if (enteredCode == widget.verificationCode) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Incorrect verification code. Please try again.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCEED9),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     children: [
//                       SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                       CircleAvatar(
//                         radius: MediaQuery.of(context).size.width * 0.15,
//                         backgroundColor: Colors.white,
//                         child: Padding(
//                           padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
//                           child: Image.asset('assets/logo.png', fit: BoxFit.contain),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         "STOCK DATA HUB",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF123D59),
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//                       Expanded(
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF123D59),
//                             borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Please enter the 4-digit code sent to your email account.",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 25),
//                               // Verification Code Input
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: List.generate(4, (index) {
//                                   return Container(
//                                     width: 50,
//                                     height: 50,
//                                     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: TextField(
//                                       controller: codeControllers[index],
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                       ),
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       onChanged: (value) {
//                                         if (value.length == 1 && index < 3) {
//                                           FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty && index > 0) {
//                                           FocusScope.of(context).previousFocus();
//                                         }
//                                       },
//                                     ),
//                                   );
//                                 }),
//                               ),
//                               const SizedBox(height: 25),
//                               TextButton(
//                                 onPressed: () {
//                                   // Resend code action
//                                 },
//                                 child: const Text(
//                                   "Resend code",
//                                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                                 ),
//                               ),
//                               const SizedBox(height: 25),
//                               Center(
//                                 child: ElevatedButton(
//                                   onPressed: _verifyCode,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFFFFA726),
//                                     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Verify",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChangePassword.dart';

class SendCodePage extends StatefulWidget {
  final String email;
  final String verificationCode;

  const SendCodePage({Key? key, required this.email, required this.verificationCode}) : super(key: key);

  @override
  _SendCodePageState createState() => _SendCodePageState();
}

class _SendCodePageState extends State<SendCodePage> {
  final List<TextEditingController> codeControllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    String enteredCode = codeControllers.map((controller) => controller.text).join();

    // Verify the code against the code received via email
    if (enteredCode == widget.verificationCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification successful!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect verification code. Please try again.'),
          duration: Duration(seconds: 2),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Please enter the 4-digit code sent to your email account.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 25),
                              // Verification Code Input
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: codeControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (value) {
                                        if (value.length == 1 && index < 3) {
                                          FocusScope.of(context).nextFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 25),
                              TextButton(
                                onPressed: () {
                                  // Resend code action can be implemented here
                                },
                                child: const Text(
                                  "Resend code",
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _verifyCode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFA726),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Verify",
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
