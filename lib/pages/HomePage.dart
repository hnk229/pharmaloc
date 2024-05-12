import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmaloc/pages/medicament/medicament.dart';
import 'package:pharmaloc/pages/pharmacie/pharmacieLoc.dart';
import 'package:pharmaloc/pages/pharmacie/rechercherPharma.dart';
import 'package:pharmaloc/services/authGoogle.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isSelected = false;

  setCurrentPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white,
          size: 30,
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: const Color(0xff000000),
        backgroundColor: const Color(0xff367f2b),
        title: [
          Text(
            "Pharmacies",
            style: GoogleFonts.poppins(
              color: const Color(0xffffffff),
            ),
          ),
          Text(
            "Médicaments",
            style: GoogleFonts.poppins(
              color: const Color(0xffffffff),
            ),
          ),
          Text(
            "Recherche",
            style: GoogleFonts.poppins(
              color: const Color(0xffffffff),
            ),
          )
        ][_currentIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff367f2b),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user!.photoURL!),
                    backgroundColor: Colors.white,
                    radius: 50,
                    onBackgroundImageError: (exception, stackTrace) {
                      // Gérer l'erreur ici, par exemple afficher un message d'erreur ou charger une image de secours
                      if (kDebugMode) {
                        print(
                            'Erreur lors du chargement de l\'image : $exception');
                      }
                      const AssetImage('assets/images/avatar.jpg');
                    },
                  ),
                  Text("${_user.displayName}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                _user.email!,
                style: GoogleFonts.poppins(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                "${_user.phoneNumber}",
                style: GoogleFonts.poppins(),
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () async {
                    authGoogle().signOut();
                  },
                  icon: const Icon(Icons.logout)),
              title: Text(
                'Déconnexion',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
      body: [const PharmacieLoc(), const Medicament(), const RecherchePharma()][_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Colors.white,
            labelTextStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 14, color: Color(0xff000000)))),
        child: NavigationBar(
          height: 70,
          animationDuration: const Duration(milliseconds: 500),
          selectedIndex: _currentIndex,
          //type: BottomNavigationBarType.fixed,
          onDestinationSelected: (index) => setCurrentPage(index),
          indicatorColor: const Color(0xff367f2b),
          backgroundColor: Colors.white,
          //shadowColor: const Color(0xff000000),
          //iconSize: 32,
          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.add_location_alt,
                  color: Color(0xffffffff),
                ),
                icon: Icon(Icons.add_location_alt_outlined,
                  color: Colors.grey,
                ),
                label: "Pharmacie"),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.medical_information,
                  color: Color(0xffffffff),
                ),
                icon: Icon(Icons.medical_information_outlined,
                  color: Colors.grey,
                ),
                label: "Médicament"),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.search,
                  color: Color(0xffffffff),
                ),
                icon: Icon(Icons.search_outlined,
                  color: Colors.grey,
                ),
                label: "Recherche")
          ],
        ),
      ),
    );
  }
}

//Center(
//child: Text("${_user!.email!}\n${_user.displayName!}"),
//)
