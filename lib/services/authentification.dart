import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmaloc/models/user.dart';
import 'package:pharmaloc/services/database.dart';

class AuthenticationService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebase(User? user){
      if(user != null){
        return AppUser(user.uid); // Crée un AppUser à partir de l'UID de l'utilisateur
      }else{
        return null;
      }

  }

  //la fonction qui vérifie si l'utilisateur est connecter
  Stream<AppUser?> get user{
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //la fonction pour la connection d'un utilisateur
  Future SignInWithEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user);
    }catch(exception){
      print(exception.toString());
      AlertDialog ShowDialog(BuildContext context){
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: const Text("Attention"),
            content: Text("$exception", style: const TextStyle(
              fontSize: 20,
            ),
            ),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("OK",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              )
            ]

        );
      }
    }
  }


  // La fonction pour enregister un utilisateur
  Future RegisterWithEmailPassword(String name, String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // TODO Firestore
      await DatabaseService(user!.uid).saveUser(name, email);
      return _userFromFirebase(user);

    }catch(exception){
      print(exception.toString());
      return null;
    }
  }

  //Fonction pour la deconnection d'un utilisateur
  Future SignOut() async{
    try{
      return await _auth.signOut();
    }catch(exception){
      print(exception);
      return null;
    }
  }
}

