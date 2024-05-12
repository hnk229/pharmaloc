import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class authGoogle{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //Connexion avec Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    //Déclenché le flux d'authentification
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    //Obtenir les détails d'authentification de la demande
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    //Créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    //Une fois connecter, renvoyer L'identifiant de l'utilisateur
    return await _auth.signInWithCredential(credential);
  }


  //l'état de l'utilisateur en temps réel
  Stream<User?> get user => _auth.authStateChanges();

  //Fonction de déconnection
  Future<void> signOut() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}