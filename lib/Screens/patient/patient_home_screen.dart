import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctors/Data/auth_service.dart';
import 'package:doctors/Screens/login.dart';
import 'package:doctors/Screens/patient/patient_home.dart';
import 'package:doctors/Screens/patient/patient_profile.dart';
import 'package:doctors/Screens/patient/search_patient.dart';
import 'package:flutter/material.dart';

import 'appointement_patient.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomePatientPage(),
    SearchPagePatient(),
    PatientAppointments(),
    ProfilePatient(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print(_selectedIndex);
              },
              icon: _selectedIndex != 1
                  ? IconButton(
                      onPressed: () =>
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              AuthServices.clearTokens();
                              return const Login();
                            },
                          )),
                      icon: const Icon(Icons.logout))
                  : const Icon(Icons.person)),
        ],
        title: Row(
          mainAxisAlignment: _selectedIndex != 1
              ? MainAxisAlignment.start
              : MainAxisAlignment.start,
          children: [
            const Icon(Icons.health_and_safety),
            Text(
              _selectedIndex == 0
                  ? 'Doctors'
                  : _selectedIndex == 1
                      ? 'Recherchez'
                      : _selectedIndex == 2
                          ? 'Dossier Medicale'
                          : 'Profile',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.indigo,
        // leading: _selectedIndex != 1
        //     ? const Icon(
        //         Icons.menu,
        //         color: Colors.white,
        //       )
        //     : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // fixedColor: Colors.black,
        // elevation: 0.0,
        backgroundColor: Colors.transparent,
        color: Colors.indigo,
        index: _selectedIndex,
        onTap: navigateBottomBar,
        items: const [
          Icon(
            color: Colors.white,
            Icons.home,
          ),
          // BottomNavigationBarItem(
          //     icon: const
          //     label: AppLocalizations.of(context)!.translate('Home')),
          // BottomNavigationBarItem(
          // icon:
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          // label: AppLocalizations.of(context)!
          //     .translate('Request a loan')),
          Icon(
            color: Colors.white,
            Icons.history,
          ),

          Icon(
            color: Colors.white,
            Icons.person,
          ),
          // BottomNavigationBarItem(
          //     icon:
          //     label: AppLocalizations.of(context)!
          //         .translate('Loan history')),
        ],
      ),
    );
  }
}







//home