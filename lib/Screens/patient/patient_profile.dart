import 'package:doctors/Data/auth_service.dart';
import 'package:doctors/Widgets/patient_card.dart';
import 'package:flutter/material.dart';

class ProfilePatient extends StatefulWidget {
  const ProfilePatient({super.key});

  @override
  State<ProfilePatient> createState() => _ProfilePatientState();
}

class _ProfilePatientState extends State<ProfilePatient> {
  String? nom;
  String? prenom;
  String? phone;

  Future<void> fetchUserDataa() async {
    final userData = await PatientRepo().getPatientData();
    setState(() {
      nom = userData.nom;
      prenom = userData.prenom;
      phone = userData.phone;
    });
  }

  @override
  void initState() {
    fetchUserDataa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Center(
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       PatientRepo().getPatientData();
      //     },
      //   ),
      // ),
      body: nom != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PatientCard(
                        title: 'Informations personnels',
                        color: Colors.red,
                        nom: nom!,
                        prenom: prenom!,
                        phone: phone!,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
