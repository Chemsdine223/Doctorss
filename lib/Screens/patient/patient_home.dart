import 'package:doctors/Widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

import '../../Data/auth_service.dart';
import '../../constants.dart';

class HomePatientPage extends StatefulWidget {
  const HomePatientPage({Key? key}) : super(key: key);

  @override
  State<HomePatientPage> createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  String? selectedHourRange;

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> foundUsers = [];
  TextEditingController dateinput = TextEditingController();

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
    super.initState();
  }

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

  Future<Map<String, dynamic>> fetchSchedule(dynamic doctorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/schedules/$doctorId/'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(response);
      print(data);
      return data;
    } else {
      throw 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Center(
      //   child: FloatingActionButton(onPressed: () {
      //     fetchSchedules();
      //   }),
      // ),
      // extendBody: true,
      body: Builder(builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.4,
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: Column(
            children: [
              // TextField(
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     suffixIcon: Icon(Icons.search),
              //     iconColor: Colors.lightBlue,
              //   ),
              //   onChanged: (value) => runFilter(value),
              // ),
              // const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foundUsers.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      key: ValueKey(foundUsers[index]["id"]),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightBlue[200]!,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      margin: const EdgeInsets.all(8),
                      // height: 200,
                      width: MediaQuery.of(context).size.width / 1.08,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                'Img/doctor.png',
                                height: MediaQuery.of(context).size.height / 5,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 20),
                            FieldSet(
                                title: 'Nom',
                                content:
                                    'Dr. ${foundUsers[index]['nom'].toString()}'
                                // .toUpperCase(),
                                ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 30),
                            FieldSet(
                                sizeText: 30,
                                title: 'Specialité',
                                content: foundUsers[index]['specialite']['nom']
                                    .toString()
                                // .toUpperCase(),
                                ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 60),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[900],
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                height: MediaQuery.of(context).size.height / 12,
                                child: InkWell(
                                  onTap: () async {
                                    final result = await fetchSchedule(
                                        foundUsers[index]['id']);
                                    showBottomSheet(
                                      // elevation: 3,
                                      // enableDrag: true,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                              )
                                            ],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            color: Colors.white,
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          'Emploi du docteur',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Lundi'),
                                                  subtitle:
                                                      Text(result['lundi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Mardi'),
                                                  subtitle:
                                                      Text(result['mardi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Mercredi'),
                                                  subtitle:
                                                      Text(result['mercredi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Jeudi'),
                                                  subtitle:
                                                      Text(result['jeudi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Vendredi'),
                                                  subtitle:
                                                      Text(result['vendredi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Samedi'),
                                                  subtitle:
                                                      Text(result['samedi']),
                                                ),
                                                ListTile(
                                                  trailing: const Icon(
                                                      Icons.history_toggle_off),
                                                  title: const Text('Dimanche'),
                                                  subtitle:
                                                      Text(result['dimanche']),
                                                ),
                                                MaterialButton(
                                                  elevation: 0,
                                                  color: Colors.blueAccent,
                                                  onPressed: () {
                                                    print(foundUsers[index]
                                                        ["id"]);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          actions: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                // if () {

                                                                // }
                                                                final consultationss =
                                                                    await PatientRepo()
                                                                        .createConsultation(
                                                                  foundUsers[
                                                                          index]
                                                                      ['id'],
                                                                  AuthServices
                                                                      .id,
                                                                  foundUsers[index]
                                                                          [
                                                                          'specialite']
                                                                      ['id'],
                                                                  selectedHourRange,
                                                                  dateinput
                                                                      .text,
                                                                );
                                                                print(
                                                                    consultationss);
                                                                if (consultationss[
                                                                        0] ==
                                                                    true) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Consultation crée avec succès')));
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text('${consultationss[1].toString()}')));
                                                                }
                                                                // if () {
                                                                // print(foundUsers[index]["id"]
                                                                //     .toString());

                                                                // }
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.done),
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
                                                                  style:
                                                                      TextStyle(
                                                                    // color: Colors.white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                DropdownButtonHideUnderline(
                                                                  child:
                                                                      DropdownButton<
                                                                          String>(
                                                                    hint:
                                                                        const Text(
                                                                      'Choisissez l\'heure',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    value:
                                                                        selectedHourRange,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedHourRange =
                                                                            newValue;
                                                                      });
                                                                      print(
                                                                          newValue);
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    items: hourRanges
                                                                        .map((String
                                                                            value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child: Text(
                                                                            value),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'Choisissez la date',
                                                                  style:
                                                                      TextStyle(
                                                                    // color: Colors.white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                TextField(
                                                                  readOnly:
                                                                      true,
                                                                  // validator: (value) {
                                                                  //   if (value!.isEmpty) {
                                                                  //     return 'Please enter a date !';
                                                                  //   }
                                                                  //   return null;
                                                                  // },
                                                                  controller:
                                                                      dateinput,
                                                                  decoration: InputDecoration(
                                                                      iconColor: Colors.blue,
                                                                      border: const OutlineInputBorder(),
                                                                      suffixIcon: IconButton(
                                                                          onPressed: () async {
                                                                            DateTime? pickedDate = await showDatePicker(
                                                                                context: context,
                                                                                initialDate: DateTime.now(),
                                                                                firstDate: DateTime(2000),
                                                                                lastDate: DateTime(2101));

                                                                            if (pickedDate !=
                                                                                null) {
                                                                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Consulter',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Lottie.asset('Img/45708-swipe-left.json',
                  height: MediaQuery.of(context).size.height / 16),
            ],
          ),
        );
      }),
    );
  }
}

// get the doctor timetable by id

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
