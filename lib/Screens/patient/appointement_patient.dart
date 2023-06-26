import 'dart:convert';

import 'package:doctors/Data/auth_service.dart';
import 'package:doctors/Logic/cubit/auth_cubit.dart';
import 'package:doctors/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});

  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments> {
  Future<List<dynamic>> _fetchConsultations() async {
    final response = await http.get(
        Uri.parse('$baseUrl/user/consultationsPatient/${AuthServices.id}/'));
    if (response.statusCode == 200) {
      print(AuthCubit.id);
      final data = jsonDecode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to fetch consultations');
    }
  }

  Future<void> deleteConsultation(dynamic idConsultation) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/user/delete/$idConsultation/'),
    );

    if (response.statusCode == 200) {
      setState(() {});
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _fetchConsultations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final consultation = snapshot.data![index];
                // Customize how each item is displayed
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    color: Colors.lightBlue[700],
                    child: ListTile(
                      trailing: consultation['status'] == 'accepted'
                          ? null
                          : IconButton(
                              onPressed: () {
                                print(consultation['id']);
                                deleteConsultation(consultation['id']);

                                // setState(() {});
                              },
                              icon: Icon(Icons.close),
                            ),
                      tileColor: consultation['status'] == 'accepted'
                          ? Colors.lightBlue[900]
                          : Colors.red,
                      onTap: () {
                        print(consultation['id']);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                          child: Text(
                                        'Consultation',
                                        style: TextStyle(
                                            // color: Colors.,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Dr. ${consultation['doctor_id']['nom'].toString()}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Description :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${consultation['description']}',
                                        // ${consultation['doctor_id']['nom'].toString(),},
                                        style: const TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      title: Text(
                        'Dr. ${consultation['doctor_id']['nom'].toString()}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Specialté: ${consultation['specialite']['nom']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            print(AuthCubit.id);
            return const Center(
                child: Text(
              'Vous n\'avez pas des consultations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
