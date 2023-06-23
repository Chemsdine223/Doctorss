import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'Models/users.dart';

// //refresh url

// const baseUrl = 'http://127.0.0.1:8000/';
final patientData = '$baseUrl/user/data/';
// // const baseUrl = 'http://192.168.100.48:8000/';
// // const baseUrl = 'http://192.168.0.212:8000/';
// // const baseUrl = 'http://192.168.8.183:8000/';
// // const baseUrl = 'http://192.168.100.30:8000/';
// // const baseUrl = 'http://192.168.0.107:8000/';

// const login = '$baseUrl/login_P/';
// const data = '$baseUrl/data';
// const signUpUrl = '$baseUrl/patient_rg/';
final refreshUrl = '$baseUrl/refresh/';

// class AuthService {

//   static Future<UserModel> getUserData() async {
//     final uri = await Uri.parse('$data/${AuthService.id}');
//     final response = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${AuthService.accessToken}',
//       },
//     );
//     if (response.statusCode == 200) {
//       print('${response.body} signIn');
//       final data = jsonDecode(response.body);
//       final user = UserModel.fromJson(data);
//       print(response.body);
//       return user;
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }

class AuthServices {
  static String accessToken = '';
  static String refreshToken = '';
  static String id = '';
  static DateTime? dateTime;

  static Future<String> refresh() async {
    final response = await http.post(
      Uri.parse(refreshUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );
    final data = jsonDecode(response.body);
    accessToken = data['access'];
    await saveTokens();
    return accessToken;
  }

  static Future<void> saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('id', id);
  }

  static Future<String> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? '';
    refreshToken = prefs.getString('refresh_token') ?? '';
    id = prefs.getString('id') ?? '';

    return refreshToken;
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('id');
  }

  static bool isAuthenticated() {
    if (accessToken.isNotEmpty && !JwtDecoder.isExpired(accessToken)) {
      return true;
    } else {
      return false;
    }
  }
}

//   static Future<UserModel> signIn(String phone, String password) async {
//     final uri = Uri.parse(login);
//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone_number': phone, 'password': password}),
//     );

//     final data = jsonDecode(response.body);
//     print('$data 22');
//     accessToken = data['access'];
//     id = data['id'].toString();

//     if (response.statusCode == 200) {
//       print('${response.body} signIn');
//       final user = UserModel.fromJson(data);
//       return user;
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }

//   static Future<bool> signUp(String nni, String phone, String password) async {
//     final uri = Uri.parse(signUpUrl);
//     final response = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(
//         {
//           'phone_number': phone,
//           'nni': nni,
//           'password': password,
//         },
//       ),
//     );

//     print(response.statusCode);
//     // final data = await jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       // await AuthService.signIn(phone, password);
//       // final user = UserModel.fromJson(data);
//       return true;
//     } else {
//       throw Exception(response.body);
//     }
//   }

//   static Future<String> refresh() async {
//     final response = await http.post(
//       Uri.parse(refreshUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'refresh': refreshToken}),
//     );
//     final data = jsonDecode(response.body);
//     accessToken = data['access'];
//     await saveTokens();
//     return accessToken;
//   }

//   static Future<void> saveTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', accessToken);
//     await prefs.setString('refresh_token', refreshToken);
//     await prefs.setString('id', id);
//   }

//   static Future<String> loadTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     accessToken = prefs.getString('access_token') ?? '';
//     refreshToken = prefs.getString('refresh_token') ?? '';
//     id = prefs.getString('id') ?? '';

//     return refreshToken;
//   }

//   static Future<void> clearTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('access_token');
//     await prefs.remove('refresh_token');
//     await prefs.remove('id');
//   }

//   static bool isAuthenticated() {
//     if (accessToken.isNotEmpty && !JwtDecoder.isExpired(accessToken)) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }

// class CentreRepo {
//   Future<List<Centre>>? fetchCentreList() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/centres_rest/'),
//     );
//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body);
//       List<Centre> centres = jsonList.map((e) => Centre.fromJson(e)).toList();
//       for (var i = 0; i < centres.length; i++) {
//         print(centres[i].nom);
//         print(centres[i].longitude);
//         print(centres[i].latitude);
//       }
//       // print(centres);
//       return centres;
//     } else {
//       throw Exception('Failed to load bank list');
//     }
//   }
// }

class PatientRepo {
  Future<List<dynamic>> createConsultation(
    dynamic docID,
    dynamic patientID,
    dynamic specialite,
    // dynamic specialite,
    dynamic heureConultation,
    dynamic dateConsultation,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/user/consulter/',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "doctor_id": docID,
          "patient_id": patientID,
          "specialite": specialite,
          "heure_de_consultation": heureConultation,
          "date_de_consultation": dateConsultation,
        },
      ),
    );
    print(response.body);
    print(response.statusCode);
    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // final data = jsonDecode(response.body);

      // print('$data ==============');

      // final patient = Patient.fromJson(data);

      print('his is the user data helloooooo');

      // await AuthServices.saveTokens();
      return [true, 'Consultation crée avec succès '];
    } else {
      return [false, data['error']];
    }
  }

  Future<Patient> getPatientData() async {
    if (!AuthServices.isAuthenticated()) {
      await AuthServices.loadTokens();
      await AuthServices.refresh();
    }
    print(AuthServices.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/user/data/${AuthServices.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthServices.accessToken}',
        // 'Authorization': 'Bearer ${AuthaccessToken}',
      },
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('$data ==============');

      final patient = Patient.fromJson(data);

      print('$patient this is the user data helloooooo');

      await AuthServices.saveTokens();
      return patient;
    } else {
      throw 'message';
    }
  }
}
