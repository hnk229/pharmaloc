import 'package:flutter/material.dart';

class RecherchePharma extends StatefulWidget {
  const RecherchePharma({super.key});

  @override
  State<RecherchePharma> createState() => _RecherchePharmaState();
}

class _RecherchePharmaState extends State<RecherchePharma> {
  final GlobalKey<FormState> _formSeachPharmaKey = GlobalKey<FormState>();
  final _controllerPharma = TextEditingController();
  String pharma = "";

  Future<void> _showMyAlert() async{
    return showDialog(context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Attention"),
          content: const Text("Veillez entrer une Zone de recherche"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text("OK")
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formSeachPharmaKey,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: _controllerPharma,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showMyAlert();
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff367f2b)
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          label: const Text('Recherche'),
                          hintText: 'Zone de recherche',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () =>{
                          if(_formSeachPharmaKey.currentState!.validate()){
                            pharma = _controllerPharma.value.text,

                          }
                        },
                        icon: const Icon(Icons.search,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),

                  ],

                ),

              ),
              const SizedBox(
                height: 10,
              ),
              //const ReadMedoc(),
            ],
          ),
        ),
      ),
    );
  }
}
