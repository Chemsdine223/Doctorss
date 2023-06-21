import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:doctors/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../Data/auth_service.dart';

part 'auth_state.dart';

// const baseUrl = 'http://127.0.0.1:8000/';
final loginUrl = '$baseUrl/user/login/';
final registerUrl = '$baseUrl/user/register/';

class AuthCubit extends Cubit<AuthState> {
  static String accessToken = '';
  static String refreshToken = '';
  static String id = '';
  static DateTime? dateTime;

  AuthCubit() : super(AuthInitial());

  Future<void> login(dynamic phone, dynamic password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'phone': phone,
            'password': password,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        AuthServices.accessToken = data['access'];
        AuthServices.refreshToken = data['refresh'];
        AuthServices.id = data['id'].toString();

        await AuthServices.saveTokens();
        print(AuthServices.id);
        // print(accessToken);

        if (data['role'] == 'Patient') {
          emit(AuthSuccess());
          // print('hi');
        } else if (data['role'] == 'Doctor') {
          emit(MedecinLogin());
          // print('hello');
        } else {
          emit(AuthError());
          // print(response);
        }
      } else {
        emit(AuthError());
        // print('Error: ${response.statusCode}');
      }
    } catch (e) {
      emit(AuthError());
      // print('Exception: $e');
    }
  }

  Future<void> register(
    String nom,
    String prenom,
    String phone,
    String password,
    String password2,
  ) async {
    emit(InscriptionLoading());
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nom": nom,
          "prenom": prenom,
          "phone": phone,
          "password": password,
          "password2": password2,
        }),
      );
      if (response.statusCode == 200) {
        emit(InscriptionSuccess());
      } else {
        emit(InscriptionError());
      }
    } catch (e) {
      emit(InscriptionError());
    }
  }

  Future<void> logout() async {
    emit(AuthInitial());
  }
}
