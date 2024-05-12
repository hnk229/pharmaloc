import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmaloc/models/user.dart';

class DatabaseService{
  final String uid;

  DatabaseService(this.uid);
  //Créaction et initialisation du document user
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("user");

  Future<void> saveUser(String name, String email) async{
    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
    });
  }

  AppUserData _userFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?; // Convertir en Map<String, dynamic> ou null

    if (data != null && data.containsKey('name')) { // Vérifier si 'name' est présent dans le Map
      return AppUserData(
        uid, // Utilisez snapshot.id pour obtenir l'identifiant du document
        data['name'] as String, // Accéder à 'name' en tant que String
        data['email'] as String,
      );
    } else {
      // Gérer le cas où le snapshot ne contient pas de données ou 'name' est absent
      throw Exception("Snapshot does not contain 'name' data");
    }
  }

  //Méthode stream pour recupérer l'utilisateur courant
  Stream<AppUserData> get user{
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
}