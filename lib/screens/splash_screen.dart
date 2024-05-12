import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmaloc/pages/HomePage.dart';
import 'package:pharmaloc/screens/welcome_screen.dart';
import 'package:provider/provider.dart';


class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    //return _user == null ? const WelcomeScreen() : MapSample();
    //ou
      if (_user == null) {
          // Afficher la page de connexion si l'utilisateur n'est pas connecté
        return const WelcomeScreen();
      } else {
          // Afficher la page d'accueil si l'utilisateur est connecté
         return const HomePage();
      }
      }
  }
