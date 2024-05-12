import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_scaffold.dart';

class DetailPharmacie extends StatefulWidget {
  final Map<String, dynamic> pharmacie;
  const DetailPharmacie({super.key, required this.pharmacie});

  @override
  State<DetailPharmacie> createState() => _DetailPharmacieState();
}


class _DetailPharmacieState extends State<DetailPharmacie> {

  late String nomPharma = "" ;
  @override
  void initState() {
    super.initState();
    // Initialiser les variables d'état ici
    nomPharma = widget.pharmacie['name'].toString();
  }
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
  @override
  Widget build(BuildContext context) {
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
                            Text(widget.pharmacie['name'],
                              style: const TextStyle(color: Color(0xff367f2b),
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.pharmacie['vicinity']),
                                //Text(widget.pharmacie['formatted_phone_number']),

                              ],
                            ),

                            const SizedBox(height: 50,),
                            Row(
                              children: [
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
                                    )),
                                const SizedBox(width: 20,),
                                ElevatedButton(onPressed: _openMapsApp,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff367f2b),
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.all(13),
                                        elevation: 8,
                                        shadowColor: Colors.black
                                    ),
                                    child: const Text("Vérifier Médicament",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    )),
                              ],
                            )
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
