import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pharmaloc/pages/medicament/detaisMedicament.dart';

class Medicament extends StatefulWidget {
  const Medicament({super.key});

  @override
  State<Medicament> createState() => _MedicamentState();
}

class _MedicamentState extends State<Medicament> {
  late String _searchQuery;
  final TextEditingController _controllerMedoc = TextEditingController();

  @override
  void initState() {
    _searchQuery = "";
    super.initState();
    _controllerMedoc.addListener(_onSearchChange);
  }

  _onSearchChange(){
    setState(() {
      _searchQuery = _controllerMedoc.text;
    });
  }
  @override
  void dispose() {
    _controllerMedoc.removeListener(_onSearchChange);
    _controllerMedoc.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          //alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoSearchTextField(
                keyboardType: TextInputType.text,
                controller: _controllerMedoc,
                placeholder: "Rechercher Médicament",
              ),
              const SizedBox(
                height: 10,
              ),
               Expanded(
                   child: StreamBuilder<QuerySnapshot>(
                     stream: FirebaseFirestore.instance
                              .collection("Médicaments").orderBy('nomM')
                              .startAt([_searchQuery])
                              .endAt(["$_searchQuery\uf8ff"])
                              .snapshots(),
                     builder: (context, snapshot) {
                       if (snapshot.connectionState ==
                           ConnectionState.waiting) {
                         return const Center(child: CircularProgressIndicator());
                       }
                       if (snapshot.hasError) {
                         return Center(
                             child: Text('Erreur : ${snapshot.error}'));
                       }
                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                         return const Center(child: Text('Aucun médicament trouvé'));
                       }
                       return ListView.builder(itemCount: snapshot.data!.docs.length,
                         itemBuilder: (context, index) {
                           final DocumentSnapshot document =
                           snapshot.data!.docs[index];
                           final Map<String, dynamic>? data =
                           document.data() as Map<String, dynamic>?;

                           if (data != null) {
                             return _buildMedicamentCard(data);
                           } else {
                             return const SizedBox.shrink(); // Élément vide
                           }
                         },
                       );
                     }),
    )
              ],
          ),
        ),
    );
  }
}




Widget _buildMedicamentCard(Map<String, dynamic> data) {
  // Logique pour construire une carte de médicament
  String nameMedoc = data['nomM'];
  String idCont = data['id_contient'];
  String poso = data['posologie'];

  // Récupérer les données du médicament à partir de l'ID
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection("Contient").doc(idCont).get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> medocSnapshot) {
      if (medocSnapshot.connectionState == ConnectionState.done) {
        if (medocSnapshot.hasData && medocSnapshot.data != null && medocSnapshot.data!.exists) {
          Map<String, dynamic> medocData = medocSnapshot.data!.data() as Map<String, dynamic>;
          // Ici, vous pouvez accéder aux données supplémentaires du médicament
          String prix = medocData['prix'];
          String idPharma = medocData['id_pharmacie'];
          String idMedoc = medocData['id_medicament'];
          int qte = int.parse(medocData['Qte']);

          // Récupérer les catégories du médicament
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection("Categories").doc(idMedoc).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> categorieSnapshot) {
              if (categorieSnapshot.connectionState == ConnectionState.done) {
                if (categorieSnapshot.hasData && categorieSnapshot.data != null && categorieSnapshot.data!.exists) {
                  Map<String, dynamic> categorieData = categorieSnapshot.data!.data() as Map<String, dynamic>;
                  String libelleCategorie = categorieData['libelle'];

                  // Récupérer les informations de la pharmacie
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection("Pharmacies").doc(idPharma).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> pharmacieSnapshot) {
                      if (pharmacieSnapshot.connectionState == ConnectionState.done) {
                        if (pharmacieSnapshot.hasData && pharmacieSnapshot.data != null && pharmacieSnapshot.data!.exists) {
                          Map<String, dynamic> pharmacieData = pharmacieSnapshot.data!.data() as Map<String, dynamic>;
                          String nomPhar = pharmacieData['nom'];

                          // Construction de la carte de médicament
                          return Card(
                            elevation: 2,
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return DetailMedoc(
                                        medicament: data,
                                        pharmacie: pharmacieData,
                                        prix: medocData,
                                        qte: qte,
                                      );
                                    },
                                  ),
                                );
                              },
                              title: Text(
                                "$nomPhar",
                                style: const TextStyle(color: Color(0xff367f2b)),
                              ),
                              subtitle: Text("$nameMedoc\n$poso"),
                              trailing: qte > 0
                                  ? Text(
                                '$prix FCFA\nDisponible',
                                style: const TextStyle(color: Color(0xff367f2b)),
                              )
                                  : Text(
                                '$prix FCFA\nIndisponible',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator(
                          color: Color(0xff367f2b),
                        )); // Indicateur de chargement pour les données de la pharmacie
                      }
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const Center(child: CircularProgressIndicator(
                  color: Color(0xff367f2b),
                )); // Indicateur de chargement pour les données de la catégorie
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const Center(child: CircularProgressIndicator(
          color: Color(0xff367f2b),
        )); // Indicateur de chargement pour les données du médicament
      }
    },
  );
}









