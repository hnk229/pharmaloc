import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaloc/widgets/custom_scaffold.dart';

class VerifierMedicament extends StatefulWidget {
  const VerifierMedicament({super.key});

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

  _onSearchChange(){
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
            Expanded(child: ListView.builder(itemBuilder: itemBuilder))
          ],
        ),
      ),
    );
  }
}
