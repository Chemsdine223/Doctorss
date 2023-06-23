import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Data/auth_service.dart';
import '../../constants.dart';

class DoctorsPage extends StatefulWidget {
  dynamic nomDoc;
  dynamic prenomDoc;
  dynamic idDoc;
  dynamic specialite;

  DoctorsPage({
    Key? key,
    required this.nomDoc,
    required this.prenomDoc,
    required this.idDoc,
    required this.specialite,
  }) : super(key: key);

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String? selectedHourRange;
  dynamic schedule;
  TextEditingController dateinput = TextEditingController();

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> foundUsers = [];

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/user/doctors/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> users =
          List<Map<String, dynamic>>.from(data);
      return users;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<void> fetchDoctorSchedule(dynamic doctorID) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/schedules/$doctorID/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        schedule = data;
      });
      print(schedule);
    } else {
      throw 'error';
    }
  }

  @override
  void initState() {
    fetchUsers().then((users) {
      setState(() {
        allUsers = users;
        foundUsers = allUsers;
      });
    }).catchError((error) {
      print(error);
      // Handle error
    });
    fetchDoctorSchedule(widget.idDoc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Details docteur',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: schedule != null
          ? SafeArea(
              child: Column(
                children: [
                  const Text(
                    'Horaires du docteur',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dr. ${widget.nomDoc}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.person),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlue[200]!,
                              blurRadius: 2,
                            )
                          ],
                        ),
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 1,

                        // width: 200,
                        // color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Lundi'),
                                subtitle: Text(schedule['lundi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Mardi'),
                                subtitle: Text(schedule['mardi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Mercredi'),
                                subtitle: Text(schedule['mercredi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Jeudi'),
                                subtitle: Text(schedule['jeudi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Vendredi'),
                                subtitle: Text(schedule['vendredi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Samedi'),
                                subtitle: Text(schedule['samedi']),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.history_toggle_off),
                                title: const Text('Dimanche'),
                                subtitle: Text(schedule['dimanche']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    elevation: 0,
                    color: Colors.blueAccent,
                    onPressed: () {
                      // print(foundUsers[index]["id"]);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              IconButton(
                                onPressed: () async {
                                  // if () {

                                  // }
                                  final consultationss =
                                      await PatientRepo().createConsultation(
                                    widget.idDoc,
                                    AuthServices.id,
                                    widget.specialite,
                                    selectedHourRange,
                                    dateinput.text,
                                  );
                                  print(consultationss);
                                  if (consultationss[0] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Consultation crée avec succès')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Vous avez déjà une consultation avec ce docteur ..'),
                                      ),
                                    );
                                  }
                                  // if () {
                                  // print(foundUsers[index]["id"]
                                  //     .toString());

                                  // }
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.done),
                              )
                            ],
                            // backgroundColor: Colors.lightBlue[400],
                            content: SizedBox(
                              // color: Colors.lightBlue[400],
                              height: 400,
                              width: 300,

                              child: Column(
                                // mainAxisAlignment:
                                //     // MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Choisissez l\'heure',
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: const Text(
                                        'Choisissez l\'heure',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      value: selectedHourRange,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedHourRange = newValue;
                                        });
                                        print(newValue);
                                        setState(() {});
                                      },
                                      items: hourRanges.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const Text(
                                    'Choisissez la date',
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    readOnly: true,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Please enter a date !';
                                    //   }
                                    //   return null;
                                    // },
                                    controller: dateinput,
                                    decoration: InputDecoration(
                                        iconColor: Colors.blue,
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(pickedDate);

                                                dateinput.text = formattedDate;
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.calendar_month,
                                            )),
                                        // icon: Icon(Icons.calendar_today),
                                        labelText: 'Entrez une date'),
                                    // readOnly: true,
                                  ),
                                ],
                              ),
                              // color: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Prendre un RDV',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

final List<String> hourRanges = [
  "9h-10h",
  "10h-11h",
  "11h-12h",
  "12h-13h",
  "13h-14h",
  "14h-15h",
  "15h-16h",
  "16h-17h",
  "17h-18h",
  "18h-19h",
  "19h-20h",
  "20h-21h",
  "21h-22h",
];
