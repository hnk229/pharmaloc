import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pharmaloc/services/authGoogle.dart';
import '../animation/delayed_animation.dart';
import '../widgets/custom_scaffold.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool inLogin = false;
  sign() {
    setState(() {
      inLogin = true;
      authGoogle().signInWithGoogle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 40.0,
                ),
                child: Center(
                    child: Column(
                  children: [
                    const DelayedAnimation(
                      delay: 1500,
                      child: Image(
                        image: AssetImage('assets/images/Logo.png'),
                      //height: 280,
                        width: 1000,
                      ),
                    ),
                    DelayedAnimation(
                      delay: 2500,
                      child: Text(
                        "BIENVENUE SUR \nPHARMALOC",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(letterSpacing: .5),
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                )),
              )),
          DelayedAnimation(
            delay: 3500,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    children: [
                      inLogin
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffa4d518),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => sign(),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Logo(Logos.google,
                                      size: 22,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Connexion",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: const Color(0xff367f2b),
                                      )
                                    )
                                  ]))
                    ],
                  )),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
