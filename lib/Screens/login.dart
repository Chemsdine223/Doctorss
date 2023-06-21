import 'package:doctors/Logic/cubit/auth_cubit.dart';
import 'package:doctors/Screens/home.dart';
import 'package:doctors/Screens/patient/patient_home_screen.dart';
import 'package:doctors/Screens/register.dart';
import 'package:doctors/Widgets/custom_app_ba.dart';
import 'package:doctors/Widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
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
                      Lottie.asset(
                        'Img/21474-medical-frontliners.json',
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
                                icon: const Icon(Icons.lock),
                                maxLength: 20,
                                maxLines: 1,
                                hideText: true,
                              ),
                              Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<AuthCubit>().login(
                          phoneController.text.toString(),
                          passwordController.text.toString(),
                        );
                    print(phoneController.text);
                    print(passwordController.text);
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
                            if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Informations invalides'),
                                ),
                              );
                            } else if (state is AuthSuccess) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const PatientHome();
                                },
                              ));
                            } else if (state is MedecinLogin) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const DoctorHome();
                                },
                              ));
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              print(state);
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              print(state);
                              return const Text(
                                'Connexion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const RegisterScreen();
                        },
                      ));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Vous n\'avez pas de compte ?',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const RegisterScreen();
                                    },
                                  )),
                            text: ' Créez un compte',
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


                    // context.read<AuthCubit>().register(
                    //       nniController.text,
                    //       nomController.text,
                    //       prenomController.text,
                    //       passwordController.text,
                    //       passwordController.text,
                    //       password2Controller.text,
                    //     );