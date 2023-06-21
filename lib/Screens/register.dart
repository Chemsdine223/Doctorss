import 'package:doctors/Widgets/custom_app_ba.dart';
import 'package:doctors/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Logic/cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.blue[400]!,
          ),
        ),
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomAppBar(
                      titre: 'Inscription',
                    ),
                    // CustomTextField(
                    //   controller: ,                  hintText: 'Entrez votre NNI',
                    //   label: 'NNI',
                    //   icon: const Icon(Icons.credit_card),
                    //   maxLength: 10,
                    //   maxLines: 1,
                    //   hideText: false,
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height / 38,
                    // ),
                    CustomTextField(
                      controller: nomController,
                      hintText: 'Entrez votre nom',
                      label: 'Nom',
                      icon: const Icon(Icons.person),
                      maxLength: 20,
                      maxLines: 1,
                      hideText: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 38,
                    ),
                    CustomTextField(
                      controller: prenomController,
                      hintText: 'Entrez votre prenom',
                      label: 'Prenom',
                      icon: const Icon(Icons.person),
                      maxLength: 30,
                      maxLines: 1,
                      hideText: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 38,
                    ),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Entrez votre numéro de téléphone',
                      label: 'Tél',
                      icon: const Icon(Icons.phone),
                      maxLength: 8,
                      maxLines: 1,
                      hideText: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 38,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Entrez votre mot de passe',
                      label: 'Mot de passe',
                      icon: const Icon(Icons.lock),
                      maxLength: 20,
                      maxLines: 1,
                      hideText: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 38,
                    ),
                    CustomTextField(
                      controller: password2Controller,
                      hintText: 'Entrez votre mot de passe',
                      label: 'Mot de passe',
                      icon: const Icon(Icons.lock),
                      maxLength: 20,
                      maxLines: 1,
                      hideText: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 38,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthCubit>().register(
                              nomController.text,
                              prenomController.text,
                              phoneController.text,
                              passwordController.text,
                              password2Controller.text,
                            );
                        print(phoneController.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            child: Center(
                              child: BlocConsumer<AuthCubit, AuthState>(
                                listener: (context, state) {
                                  if (state is InscriptionSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Compte crée avec succès'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (state is InscriptionError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Informations invalides'),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is InscriptionLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ));
                                  } else {
                                    return const Text(
                                      'S\'inscrire',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
