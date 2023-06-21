import 'package:doctors/Data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

// don't forget to send the deafault intervals in the init state !!!!!!!!!!!
// don't forget to send the deafault intervals in the init state !!!!!!!!!!!
// don't forget to send the deafault intervals in the init state !!!!!!!!!!!
// don't forget to send the deafault intervals in the init state !!!!!!!!!!!

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Future<void>

  @override
  void initState() {
    super.initState();
  }

  dynamic schedule;
  final List<String> days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];

  // Future

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

  Map<String, Map<String, String>> intervals = {
    'Lundi': {'start': '9h', 'end': '10h'},
    'Mardi': {'start': '10h', 'end': '11h'},
    'Mercredi': {'start': '11h', 'end': '12h'},
    'Jeudi': {'start': '12h', 'end': '13h'},
    'Vendredi': {'start': '13h', 'end': '14h'},
    'Samedi': {'start': '14h', 'end': '15h'},
    'Dimanche': {'start': '15h', 'end': '16h'},
  };

  void _modifyInterval(String day, String startHour, String endHour) {
    setState(() {
      intervals[day] = {'start': startHour, 'end': endHour};
    });
  }

  void _sendIntervals() {
    print(AuthServices.id);
    Map<String, String> requestBody = {
      'doctor': AuthServices.id,
      'lundi':
          '${intervals["Lundi"]!["start"]} - ${intervals["Lundi"]!["end"]}',
      'mardi':
          '${intervals["Mardi"]!["start"]} - ${intervals["Mardi"]!["end"]}',
      'mercredi':
          '${intervals["Mercredi"]!["start"]} - ${intervals["Mercredi"]!["end"]}',
      'jeudi':
          '${intervals["Jeudi"]!["start"]} - ${intervals["Jeudi"]!["end"]}',
      'vendredi':
          '${intervals["Vendredi"]!["start"]} - ${intervals["Vendredi"]!["end"]}',
      'samedi':
          '${intervals["Samedi"]!["start"]} - ${intervals["Samedi"]!["end"]}',
      'dimanche':
          '${intervals["Dimanche"]!["start"]} - ${intervals["Dimanche"]!["end"]}',
    };

    http.post(
      Uri.parse('$baseUrl/user/schedule/'),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    ).then((response) {
      if (response.statusCode == 200) {
        // Interval update successful
        // Handle the response accordingly
        print('Interval update successful');
        print(response.body);
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.lightBlue,
            content: const Text(
              'mis à jour avec success',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ))
            ],
          ),
        );
      } else {
        // Interval update failed
        // Handle the error response accordingly
        print('Interval update failed');
      }
    }).catchError((error) {
      // Error occurred during the API request
      // Handle the error accordingly
      print('Error occurred: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'Img/schedule.png',
                  height: MediaQuery.of(context).size.height / 5,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 36),
            const Text(
              'Ajustez vos horaires',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 46,
            ),
            SizedBox(
              // color: Colors.green,
              height: MediaQuery.of(context).size.height / 2.5,
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final startHour = intervals[day]!['start'];
                  final endHour = intervals[day]!['end'];

                  return ListTile(
                    title: Text(day),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$startHour - $endHour'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showIntervalDialog(
                              context, day, startHour!, endHour!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  _sendIntervals();
                },
                color: Colors.lightBlue[800],
                height: MediaQuery.of(context).size.height / 18,
                minWidth: MediaQuery.of(context).size.width / 3,
                child: const Text(
                  'Confirmer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendIntervals,
      //   child: const Icon(Icons.check),
      // ),
    );
  }

  void _showIntervalDialog(
      BuildContext context, String day, String startHour, String endHour) {
    showDialog(
      context: context,
      builder: (context) {
        String newStartHour = startHour;
        String newEndHour = endHour;

        return AlertDialog(
          title: Text(day),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: newStartHour,
                items: hours.map((hour) {
                  return DropdownMenuItem<String>(
                    value: hour,
                    child: Text(hour),
                  );
                }).toList(),
                onChanged: (value) {
                  newStartHour = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: newEndHour,
                items: hours.map((hour) {
                  return DropdownMenuItem<String>(
                    value: hour,
                    child: Text(hour),
                  );
                }).toList(),
                onChanged: (value) {
                  newEndHour = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _modifyInterval(day, newStartHour, newEndHour);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
