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
    final response = await http.get(Uri.parse(
        '$baseUrl/user/consultations/${AuthServices.id}/'));
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
                    onTap: (){},
                    // leading:
                    //     Text(foundUsers[index]["patient_id"]['nom'].toString()),
                    title: Text(
                      foundUsers[index]["patient_id"]['nom'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
