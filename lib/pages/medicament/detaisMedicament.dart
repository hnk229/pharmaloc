import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaloc/widgets/custom_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMedoc extends StatefulWidget {
  final Map<String, dynamic> medicament;
  final Map<String, dynamic> pharmacie;
  final Map<String, dynamic> prix;
  final qte;
  const DetailMedoc({super.key, required this.medicament, required this.pharmacie, required this.prix, this.qte});

  @override
  State<DetailMedoc> createState() => _DetailMedocState();
}

class _DetailMedocState extends State<DetailMedoc> {




  @override
  Widget build(BuildContext context) {
    var qte = widget.qte;
    String nomPharma = widget.pharmacie['nom'];
    // Fonction pour ouvrir l'application Google Maps avec le lieu spécifié
    Future<void> _openMapsApp() async {
      // Encodez le nom du lieu pour qu'il soit utilisable dans un URL
      String encodedPlaceName = Uri.encodeFull(nomPharma);

      // Lien pour ouvrir Google Maps avec le lieu spécifié
      String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedPlaceName';

      // Vérifier si le lien peut être ouvert
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl); // Ouvrir l'application Google Maps
      } else {
        throw 'Impossible d\'ouvrir Google Maps';
      }
    }
    return Scaffold(

      backgroundColor: const Color(0xff367f2b),
      body:CustomScaffold(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
                child: SizedBox(
                  height: 10,
                )
            ),
            Expanded(
              flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                  child:  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          Text(widget.pharmacie['nom'],
                            style: const TextStyle(color: Color(0xff367f2b),
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.medicament['nomM'] + widget.medicament['posologie']),
                              Text(widget.prix['prix'] + " FCFA"),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          qte > 0
                            ?const Text("Disponible",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff367f2b)
                              ),
                              )
                            :const Text("Indisponible",
                              style: TextStyle(
                                color: Colors.red,
                                  fontSize: 18,
                              ),
                              ),
                          const SizedBox(height: 50,),
                          ElevatedButton(onPressed: _openMapsApp,

                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff367f2b),
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(13),
                                  elevation: 8,
                                  shadowColor: Colors.black
                              ),
                              child: const Text("Itinéraire",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}



