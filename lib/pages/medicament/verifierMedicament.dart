import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaloc/widgets/custom_scaffold.dart';

import 'detaisMedicament.dart';

class VerifierMedicament extends StatefulWidget {
  final String pharmacyName;
  const VerifierMedicament({super.key, required this.pharmacyName});

  @override
  State<VerifierMedicament> createState() => _VerifierMedicamentState();
}

class _VerifierMedicamentState extends State<VerifierMedicament> {
  final TextEditingController _controllerVerifMedoc = TextEditingController();
  late String _searchQuery;
  @override
  void initState() {
    _searchQuery = "";
    super.initState();
    _controllerVerifMedoc.addListener(_onSearchChange);
  }

  _onSearchChange() {
    setState(() {
      _searchQuery = _controllerVerifMedoc.text;
    });
  }

  @override
  void dispose() {
    _controllerVerifMedoc.removeListener(_onSearchChange);
    _controllerVerifMedoc.dispose();
    super.dispose();
  }

  Future<String?> _getPharmacyIdByName(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Pharmacies')
        .where('nom', isEqualTo: name)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isNotEmpty) {
      return documents.first.id; // Return the ID of the first document found
    } else {
      return null; // Return null if no documents found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _controllerVerifMedoc,
          placeholder: "Medicament",
        ),
        centerTitle: true,
      ),
      body: CustomScaffold(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: FutureBuilder<String?>(
                    future: _getPharmacyIdByName(widget.pharmacyName),
                    builder: (context, pharmacyIdSnapshot) {
                      if (pharmacyIdSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (pharmacyIdSnapshot.hasError) {
                        return Center(
                            child:
                                Text('Erreur : ${pharmacyIdSnapshot.error}'));
                      }
                      final String? pharmacyId = pharmacyIdSnapshot.data;
                      if (pharmacyId == null) {
                        return const Center(
                            child: Text('Pharmacie non trouvée'));
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Contient")
                            .where("id_pharmacie", isEqualTo: pharmacyId)
                            .snapshots(),
                        builder: (context, contientSnapshot) {
                          if (contientSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (contientSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Erreur : ${contientSnapshot.error}'));
                          }
                          if (!contientSnapshot.hasData ||
                              contientSnapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('Aucun médicament trouvé'));
                          }

                          final List<DocumentSnapshot> contientDocs =
                              contientSnapshot.data!.docs;
                          final List<String> medocIds = contientDocs
                              .where((doc) =>
                                  (doc.data() as Map<String, dynamic>)['nomM']
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase()))
                              .map((doc) => (doc.data()
                                      as Map<String, dynamic>)['id_medicament']
                                  .toString())
                              .toList();

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Médicaments")
                                .where(FieldPath.documentId,
                                    whereIn: medocIds.isNotEmpty
                                        ? medocIds
                                        : [
                                            'placeholder'
                                          ]) // évite l'erreur Firestore si la liste est vide
                                .snapshots(),
                            builder: (context, medocSnapshot) {
                              if (medocSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (medocSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Erreur : ${medocSnapshot.error}'));
                              }
                              if (!medocSnapshot.hasData ||
                                  medocSnapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('Aucun médicament trouvé'));
                              }

                              return ListView.builder(
                                itemCount: medocSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot document =
                                      medocSnapshot.data!.docs[index];
                                  final Map<String, dynamic>? data =
                                      document.data() as Map<String, dynamic>?;

                                  if (data != null) {
                                    return _buildMedicamentCard(
                                        data, contientDocs, pharmacyId);
                                  } else {
                                    return const SizedBox
                                        .shrink(); // Élément vide
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildMedicamentCard(Map<String, dynamic> data,
    List<DocumentSnapshot> contientDocs, String pharmacyId) {
  String nameMedoc = data['nomM'];
  String idMedoc = data['id_medicament'];

  final contientDoc = contientDocs.firstWhere((doc) =>
      (doc.data() as Map<String, dynamic>)['id_medicament'] == idMedoc);
  final contientData = contientDoc.data() as Map<String, dynamic>;

  String idCont = contientDoc.id;
  String poso = data['posologie'];
  String prix = contientData['prix'];
  int qte = int.parse(contientData['Qte']);

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection("Pharmacies")
        .doc(pharmacyId)
        .get(),
    builder: (BuildContext context,
        AsyncSnapshot<DocumentSnapshot> pharmacieSnapshot) {
      if (pharmacieSnapshot.connectionState == ConnectionState.done) {
        if (pharmacieSnapshot.hasData &&
            pharmacieSnapshot.data != null &&
            pharmacieSnapshot.data!.exists) {
          Map<String, dynamic> pharmacieData =
              pharmacieSnapshot.data!.data() as Map<String, dynamic>;
          String nomPhar = pharmacieData['nom'];

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
                        prix: contientData,
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
        return const Center(
            child: CircularProgressIndicator(
          color: Color(0xff367f2b),
        ));
      }
    },
  );
}
