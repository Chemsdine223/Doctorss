import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';
import 'doctors_details.dart';

class SearchPagePatient extends StatefulWidget {
  const SearchPagePatient({Key? key}) : super(key: key);

  @override
  State<SearchPagePatient> createState() => _SearchPagePatientState();
}

class _SearchPagePatientState extends State<SearchPagePatient> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> foundUsers = [];
  String searchQuery = '';

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

  void runFilter(String searchValue) {
    List<Map<String, dynamic>> results = [];
    if (searchValue.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers.where((user) {
        final String lowercaseValue = searchValue.toLowerCase();
        final String lowercaseName = user["nom"].toLowerCase();
        final String lowercaseSpeciality =
            user["specialite"]["nom"].toLowerCase();
        return lowercaseName.contains(lowercaseValue) ||
            lowercaseSpeciality.contains(lowercaseValue);
      }).toList();
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
                hintText: 'Recherchez pour un docteur',
                suffixIcon: Icon(Icons.search),
                iconColor: Colors.lightBlue,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                runFilter(value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(foundUsers[index]["id"]),
                  color: Colors.lightBlue[700],
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorsPage(
                          idDoc: foundUsers[index]['id'],
                          nomDoc: foundUsers[index]['nom'],
                          prenomDoc: foundUsers[index]['prenom'],
                          specialite: foundUsers[index]['specialite']['id'],
                        ),
                      ),
                    ),
                    title: Text(
                      foundUsers[index]['nom'].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      foundUsers[index]["specialite"]["nom"],
                      style: const TextStyle(color: Colors.white),
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
