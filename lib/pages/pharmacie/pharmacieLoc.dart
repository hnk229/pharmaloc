import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmaloc/animation/delayed_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmaloc/pages/pharmacie/detailPharmacie.dart';

class PharmacieLoc extends StatefulWidget {
  const PharmacieLoc({super.key});

  @override
  State<PharmacieLoc> createState() => _PharmacieLocState();
}

class _PharmacieLocState extends State<PharmacieLoc> {
  late GoogleMapController mapController;
  late LatLng userLocation;
  final Set<Marker> _markers = {};
  final DateTime heure = DateTime.now();
  List<dynamic> pharmacies = [];
  bool trouver = false;
  bool isLoading = false;
  late bool open = false;
  // Définir les heures d'ouverture et de fermeture
  int heureOuverture = 8;
  int heureFermeture = 22;

  // Vérifier si l'heure actuelle est dans l'intervalle d'ouverture

  @override
  void initState() {
    trouver = false;
    _requestLocationPermission();
    _getNearbyPharmacies();
    super.initState();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation(); // Si les autorisations sont accordées, obtenir la localisation
    } else {
      // Gérer le cas où l'utilisateur refuse les autorisations
      return Future.error("Permission de localisation refuser");
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }
  Future<void> _getNearbyPharmacies() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      const apiKey = 'AIzaSyBH6OlY-ADuCJNgqmPd01HjcdoFQUOFOm4';
      final latitude = position.latitude;
      final longitude = position.longitude;
      const type = 'pharmacy';
      const radius = 5000;

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey');
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          pharmacies = data['results'];
          isLoading = true;
          trouver = true;
          _sortPharmaciesByDistance(latitude, longitude);
        });
      } else {
        print('Erreur: ${data['status']}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _sortPharmaciesByDistance(double userLat, double userLng) async {
    for (int i = 0; i < pharmacies.length; i++) {
      final pharmacy = pharmacies[i];
      final pharmacyLat = pharmacy['geometry']['location']['lat'];
      final pharmacyLng = pharmacy['geometry']['location']['lng'];
      final distanceInKilometers = await _calculateDistanceInKilometers(userLat, userLng, pharmacyLat, pharmacyLng);
      pharmacy['distance'] = distanceInKilometers.toStringAsFixed(2);
    }
    setState(() {
      pharmacies = pharmacies;
    });
  }

  Future<double> _calculateDistanceInKilometers(double userLat, double userLng, double pharmacyLat, double pharmacyLng) async {
    final userLocation = LatLng(userLat, userLng);
    final pharmacyLocation = LatLng(pharmacyLat, pharmacyLng);
    final distanceInMeters = await Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      pharmacyLocation.latitude,
      pharmacyLocation.longitude,
    );
    return distanceInMeters / 1000;
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trouver ?
                      isLoading ?
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pharmacies.length,
                          itemBuilder: (context, index) {
                            final pharmacy = pharmacies[index];
                            final name = pharmacy['name'];
                            final vicinity = pharmacy['vicinity'];
                            final distance = pharmacy['distance'];
                            final openingHours = pharmacy['opening_hours'];
                            print(pharmacy['international_phone_number']);
                            if(heure.hour >= heureOuverture && heure.hour < heureFermeture){
                              open = true;
                            }else{
                              open = false;
                            }
                        
                            //print(openingHours);
                        
                            //final bool open = openingHouse["open_now"];
                            return Card(
                              elevation: 5,
                              color: Colors.white,
                              child: ListTile(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return DetailPharmacie(pharmacie: pharmacy);
                                          }),
                                  );
                                },
                                title: Text(name,
                                  style: const TextStyle(
                                    color: Color(0xff367f2b)
                                  ),
                                ),
                                subtitle: Text(vicinity),
                                leading: Text("$distance Km",
                                  style: const TextStyle(
                                    color: Color(0xff367f2b)
                                  ),
                                ),
                                trailing: open ? const Text("Ouvert",
                                  style: TextStyle(
                                    color: Color(0xff367f2b),
                                  ),
                                )
                                    : const Text("Fermé",
                                  style: TextStyle(
                                    color: Colors.red
                                  ),
                                )
                              ),
                            );
                          },
                        ),
                      )

                      : const Center(child: CircularProgressIndicator())
                  : Column(
                    children:[
                      const DelayedAnimation(
                          delay: 200,
                          child: Image(image:
                          AssetImage("assets/images/searching.gif"),
                            height: 300,
                          )),
                      const SizedBox(height: 20,),
                      DelayedAnimation(
                          delay: 800,
                          child: ElevatedButton(
                              onPressed: () => {
                                setState(() {
                                  trouver = !trouver;

                                })
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff367f2b),
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(13),
                                  elevation: 8,
                                  shadowColor: Colors.black
                              ),
                              child: Text(
                                "Trouver Une Pharmacie",
                                style: GoogleFonts.poppins(
                                    color: Colors.white
                                ),
                              )
                          )),
                    ]
                  )

                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}
