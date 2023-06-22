import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Data/auth_service.dart';
import '../constants.dart';

class DoctorAppointmentsPage extends StatefulWidget {
  const DoctorAppointmentsPage({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> foundUsers = [];
  Color defaultColor = Colors.white;

  Future<void> acceptRequest(dynamic consultationId) async {
    final url = '$baseUrl/user/consultations/$consultationId/';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "consultation_id": consultationId,
        },
      ),
    );
    print(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Accepté avec succès'),
        ),
      );
      setState(() {
        defaultColor = Colors.lightBlue[900]!;
      });
    }
  }

  Future<void> refuseRequest(dynamic consultationId) async {
    final url = '$baseUrl/user/consultations/$consultationId/';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "consultation_id": consultationId,
        },
      ),
    );
    print(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rendez vous refusé'),
        ),
      );
      setState(() {
        defaultColor = Colors.lightBlue[900]!;
      });
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
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http
        .get(Uri.parse('$baseUrl/user/consultations/${AuthServices.id}/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> users =
          List<Map<String, dynamic>>.from(data);
      return users;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  void runFilter(String searchValue) {
    List<Map<String, dynamic>> results = [];
    if (searchValue.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers
          .where((user) => user["patient_id"]['nom']
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase()))
          .toList();
    }

    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
                iconColor: Colors.lightBlue,
              ),
              onChanged: (value) => runFilter(value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                // scrollDirection: Axis.horizontal,
                itemCount: foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(foundUsers[index]["id"]),
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {
                      // defaultColor = Colors.green;
                    },
                    tileColor: foundUsers[index]['status'] == 'accepted'
                        ? Colors.green
                        : foundUsers[index]['status'] == 'refused'
                            ? Colors.red
                            : defaultColor,
                    // leading: const Icon(Icons.person),
                    //     Text(foundUsers[index]["patient_id"]['nom'].toString()),
                    title: Text(
                      foundUsers[index]["patient_id"]['nom'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        acceptRequest(foundUsers[index]['id']);
                      },
                      icon: const Icon(Icons.done),
                    ),

                    subtitle: Text(
                      foundUsers[index]["heure_de_consultation"],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
