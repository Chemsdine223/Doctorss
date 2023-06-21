import 'package:flutter/material.dart';

import '../../Widgets/custom_app_ba.dart';
import '../../Widgets/custom_text_field.dart';

class PatientLogin extends StatefulWidget {
  const PatientLogin({super.key});

  @override
  State<PatientLogin> createState() => _PatientLoginState();
}

class _PatientLoginState extends State<PatientLogin> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.blue[400]!,
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const CustomAppBar(
                  titre: 'Connexion',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      Image.asset(
                        'Img/dossier.png',
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        // color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                controller: phoneController,
                                hintText: 'Entrez votre numero de telephone',
                                label: 'Tél',
                                icon: const Icon(Icons.phone),
                                maxLength: 8,
                                maxLines: 1,
                                hideText: false,
                              ),
                              CustomTextField(
                                controller: passwordController,
                                hintText: 'Entrez votre mot de passe',
                                label: 'Mot de passe',
                                icon: const Icon(Icons.phone),
                                maxLength: 20,
                                maxLines: 1,
                                hideText: false,
                              ),
                              Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                          )
                        ]),
                    height: MediaQuery.of(context).size.height / 12,
                    child: const Center(
                      child: Text(
                        'S\'inscrire',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
