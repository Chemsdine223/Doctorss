import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctors/Screens/consultations_doctor.dart';
import 'package:doctors/Screens/home_page_doctor.dart';
import 'package:doctors/Screens/login.dart';
import 'package:flutter/material.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    // SearchPagePatient(),
    DoctorAppointmentsPage(),
    ScheduleScreen(),
    // LoadingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
          // centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                print(_selectedIndex);
              },
              icon: IconButton(
                onPressed: () =>
                    Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const Login();
                  },
                )),
                icon: const Icon(Icons.logout),
              ),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.health_and_safety),
              Text(
                _selectedIndex == 0 ? 'Consultations' : 'Gestion de temps',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.indigo,
          leading: const Icon(Icons.folder_rounded)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // fixedColor: Colors.black,
        // elevation: 0.0,
        backgroundColor: Colors.white,
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
          // Icon(
          //   Icons.medical_information,
          //   color: Colors.white,
          // ),
          // label: AppLocalizations.of(context)!
          //     .translate('Request a loan')),
          Icon(
            color: Colors.white,
            Icons.calendar_month,
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
