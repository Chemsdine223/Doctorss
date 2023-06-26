import 'package:doctors/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Data/auth_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, String> selectedHours = {
    'Lundi': '',
    'Mardi': '',
    'Mercredi': '',
    'Jeudi': '',
    'Vendredi': '',
    'Samedi': '',
    'Dimanche': '',
  };

  final List<String> days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  final List<String> hours = [
    "9h",
    "10h",
    "11h",
    "12h",
    "13h",
    "14h",
    "15h",
    "16h",
    "17h",
    "18h",
    "19h",
    "20h",
    "21h",
    "22h",
  ];

  @override
  void initState() {
    super.initState();
    getInitialValues();
  }

  Future<void> getInitialValues() async {
    final url =
        '$baseUrl/user/schedules/${AuthServices.id}/'; // Replace with the actual URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 2));
      final data = jsonDecode(response.body);
      setState(() {
        // selectedHours = Map<String, String>.from(data);
        selectedHours = {
          'Lundi': data['lundi'],
          'Mardi': data['mardi'],
          'Mercredi': data['mercredi'],
          'Jeudi': data['jeudi'],
          'Vendredi': data['vendredi'],
          'Samedi': data['samedi'],
          'Dimanche': data['dimanche'],
        };
      });
      print(response.body);
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  void showHoursDialog(String day) {
    String selectedStartHour = hours[0];
    String selectedEndHour = hours[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Heures de $day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedStartHour,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStartHour = newValue!;
                  });
                },
                items: hours.map((String hour) {
                  return DropdownMenuItem<String>(
                    value: hour,
                    child: Text(hour),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedEndHour,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEndHour = newValue!;
                  });
                },
                items: hours.map((String hour) {
                  return DropdownMenuItem<String>(
                    value: hour,
                    child: Text(hour),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHours[day] = '$selectedStartHour - $selectedEndHour';
                });
                Navigator.pop(context);
              },
              child: const Text('Savegarder'),
            ),
          ],
        );
      },
    );
  }

  Future<void> postSelectedHours() async {
    final url = '$baseUrl/user/schedule/'; // Replace with the actual URL

    final requestBody = {
      "doctor": AuthServices.id,
      "lundi": selectedHours['Lundi'],
      "mardi": selectedHours['Mardi'],
      "mercredi": selectedHours['Mercredi'],
      "jeudi": selectedHours['Jeudi'],
      "vendredi": selectedHours['Vendredi'],
      "samedi": selectedHours['Samedi'],
      "dimanche": selectedHours['Dimanche'],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(
        () {
          selectedHours['Lundi'] = responseData['lundi'];
          selectedHours['Mardi'] = responseData['mardi'];
          selectedHours['Mercredi'] = responseData['mercredi'];
          selectedHours['Jeudi'] = responseData['jeudi'];
          selectedHours['Vendredi'] = responseData['vendredi'];
          selectedHours['Samedi'] = responseData['samedi'];
          selectedHours['Dimanche'] = responseData['dimanche'];
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mis à jour avec succès')));
      print('Selected hours posted successfully!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue')));
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'Img/schedule.png',
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Ajustez vos horaires',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 2.6,
              child: SingleChildScrollView(
                child: Column(
                  children: days.map(
                    (day) {
                      return ListTile(
                        onTap: () {
                          showHoursDialog(day);
                        },
                        trailing: const Icon(Icons.edit),
                        title: Text(day),
                        subtitle: Text(selectedHours[day] ?? ''),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.lightBlue[900],
              onPressed: () {
                postSelectedHours();
              },
              child: const Text(
                'Confirmer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
