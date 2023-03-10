import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:smart_naka/screens/tabs_screen.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final bool isLogin;

  const WelcomeScreen(this.isLogin, {super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    if (!mounted) return;
    if (!widget.isLogin) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AppLoginScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TabsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = false;
    final width = MediaQuery.of(context).size.width;
    return Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Center(
              child: Row(
                children: [
                  const Spacer(),
                  Image(
                      image: const AssetImage("assets/images/police.png"),
                      width: width / 3),
                  const SizedBox(
                    width: 12,
                  ),
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        "Smart",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF00838F)),
                      ),
                      Text(
                        "Naka",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer()
                    ],
                  )),
                  const Spacer()
                ],
              ),
            ),
          ),
        ));
  }
}
