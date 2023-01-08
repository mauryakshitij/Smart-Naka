import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_naka/screens/signup_screen.dart';
import 'package:smart_naka/screens/tabs_screen.dart';
import 'package:smart_naka/widgets/my_text_button.dart';
import '../widgets/my_password_field.dart';
import '../widgets/my_text_field.dart';

class AppLoginScreen extends StatefulWidget {
  const AppLoginScreen({super.key});

  @override
  State<AppLoginScreen> createState() => _AppLoginScreenState();
}

class _AppLoginScreenState extends State<AppLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isChecked = false;

  String _emailError = "";
  String _passwordError = "";

  Future<void> submit() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isEmpty) {
      setState(() {
        _emailError = "Email required.";
      });
      return;
    } else {
      setState(() {
        _emailError = "";
      });
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Password required.";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TabsScreen()),
          (Route route) => false);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        setState(() {
          _emailError = "Invalid username";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _passwordError = "Incorrect password";
        });
      } else {
        setState(() {
          _emailError = e.code;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = false;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Column(children: [
              SizedBox(
                height: height / 20,
              ),
              Row(
                children: [
                  const Spacer(),
                  Image(
                      image: const AssetImage("assets/images/police.png"),
                      width: width / 12),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? const Color(0xffF0EEEE)
                                : const Color(0xFF00838F)),
                      ),
                      Text("Naka",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDarkMode
                                ? const Color(0xffF0EEEE)
                                : Colors.black,
                          ))
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(
                height: height / 15,
              ),
              SizedBox(
                width: width / 1.2,
                child: MyTextField(
                  labelText: 'Email',
                  hintText: 'Enter Email Address',
                  inputType: TextInputType.emailAddress,
                  controller: _emailController,
                  errorText: _emailError,
                ),
              ),
              SizedBox(
                width: width / 1.2,
                child: MyPasswordField(
                  controller: _passwordController,
                  isPasswordVisible: isPasswordVisible,
                  errorText: _passwordError,
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: width / 12, vertical: height / 50),
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: Text(
              //       'Forgot Password?',
              //       style: GoogleFonts.poppins(
              //           color: const Color(0xFF5C5B5B),
              //           decoration: TextDecoration.underline,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 14),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: height / 40,
              ),
              SizedBox(
                width: width / 1.2,
                child: MyTextButton(
                  onTap: submit,
                  buttonName: 'Login',
                  bgColor: const Color(0xFF00838F),
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                height: height / 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppSignUpScreen()));
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00838F)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
