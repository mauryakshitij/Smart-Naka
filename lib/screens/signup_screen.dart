import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_naka/widgets/my_text_button.dart';
import 'package:smart_naka/widgets/my_text_field.dart';
import '../models/user_model.dart';
import '../widgets/my_password_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppSignUpScreen extends StatefulWidget {
  const AppSignUpScreen({super.key});

  @override
  State<AppSignUpScreen> createState() => _AppSignUpScreenState();
}

class _AppSignUpScreenState extends State<AppSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _employeeController = TextEditingController();
  bool isPasswordVisible = true;

  String _nameError = "";
  String _emailError = "";
  String _employeeError = "";
  String _passwordError = "";
  String _confirmError = "";

  Future<void> submit() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirm = _confirmController.text;
    String employeeID = _employeeController.text;

    if (name.isEmpty) {
      setState(() {
        _nameError = "Name is required.";
      });
      return;
    } else {
      setState(() {
        _nameError = "";
      });
    }
    if (email.isEmpty) {
      setState(() {
        _emailError = "Email is required.";
      });
      return;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      setState(() {
        _emailError = "Enter valid email";
      });
      return;
    } else {
      setState(() {
        _emailError = "";
      });
    }
    if (employeeID.isEmpty) {
      setState(() {
        _employeeError = "Employee ID is required.";
      });
      return;
    } else {
      setState(() {
        _employeeError = "";
      });
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Password can't be empty";
      });
    } else if (confirm.isEmpty) {
      setState(() {
        _passwordError = "";
        _confirmError = "Password can't be empty";
      });
    } else if (password != confirm) {
      setState(() {
        _passwordError = "";
        _confirmError = "Passwords don't match.";
      });
      return;
    }
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection("users");
      UserModel user =
          UserModel(name: name, email: email, employeeID: employeeID);
      usersCollection.doc(user.email).set(user.toJson());
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sign up successful")));
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        setState(() {
          _passwordError = "Password too weak.";
        });
      } else if (e.code == "email-already-in-use") {
        setState(() {
          _emailError = "Email already registered.";
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Some error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: SingleChildScrollView(
              child: Column(children: [
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
                                  : const Color(0xFF213B7E)),
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
                  height: height / 25,
                ),
                SizedBox(
                  width: width / 1.2,
                  child: MyTextField(
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    inputType: TextInputType.text,
                    controller: _nameController,
                    errorText: _nameError,
                  ),
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
                  child: MyTextField(
                    labelText: 'Employee ID',
                    hintText: 'Enter Employee ID',
                    inputType: TextInputType.number,
                    controller: _employeeController,
                    errorText: _employeeError,
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
                SizedBox(
                  width: width / 1.2,
                  child: MyTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Enter Password',
                    inputType: TextInputType.visiblePassword,
                    controller: _confirmController,
                    errorText: _confirmError,
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
                SizedBox(
                  width: width / 1.2,
                  child: MyTextButton(
                    onTap: submit,
                    buttonName: 'Sign up',
                    bgColor: const Color(0xFF136DD6),
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
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2845DB)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
