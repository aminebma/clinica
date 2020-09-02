import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinica/models/patient.dart';
import 'package:clinica/models/doctor.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Accounts {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<dynamic> connect(String phoneNumber, String password) async {
    var url = 'https://clinicaapp.herokuapp.com/api/accounts/sign-in';
    var response = await post(
      url,
      body: {
        'phoneNumber': '+213$phoneNumber',
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      Map user = jsonDecode(response.body);
      if (user["type"] == 0) {
        _prefs.then((SharedPreferences prefs) {
          prefs.setInt('type', 0);
          prefs.setString('id', user['_id']);
          prefs.setString('firstName', user['firstName']);
          prefs.setString('lastName', user['lastName']);
          prefs.setString('sex', user['sex']);
          prefs.setString('phoneNumber', user['phoneNumber']);
          prefs.setString('mail', user['mail']);
          prefs.setString('address', user['address']);
        });
        Patient patient = Patient(
            id: user['_id'],
            firstName: user['firstName'],
            lastName: user['lastName'],
            sex: user['sex'],
            phoneNumber: user['phoneNumber'],
            address: user['address']);
        return patient;
      } else {
        _prefs.then((SharedPreferences prefs) {
          prefs.setInt('type', 1);
          prefs.setString('id', user['_id']);
          prefs.setString('firstName', user['firstName']);
          prefs.setString('lastName', user['lastName']);
          prefs.setString('sex', user['sex']);
          prefs.setString('phoneNumber', user['phoneNumber']);
          prefs.setString('speciality', user['speciality']);
          prefs.setString('picture',
              "https://clinicaapp.herokuapp.com/images/${user['picture']}");
        });
        Doctor doctor = Doctor(
            id: user['_id'],
            firstName: user['firstName'],
            lastName: user['lastName'],
            speciality: user['speciality'],
            phoneNumber: user['phoneNumber'],
            picture:
                "https://clinicaapp.herokuapp.com/images/${user['picture']}");
        return doctor;
      }
    } else
      return null;
  }

  Future<dynamic> signUp(Map user) async {
    var url = 'https://clinicaapp.herokuapp.com/api/accounts/sign-up';
    var response = await post(
      url,
      body: user,
    );
    if (response.statusCode == 200)
      return response.body;
    else {
      print(response.body);
      return null;
    }
  }

  Future<dynamic> confirmAccount(Map user, String code) async {
    var url = 'https://clinicaapp.herokuapp.com/api/accounts/sign-up/verify';
    var response = await post(
      url,
      body: {
        'phoneNumber': user['phoneNumber'],
        'code': code,
        'sid': user['sid'],
      },
    );
    if (response.statusCode == 200) {
      user.putIfAbsent('id', () => response.body);
      _prefs.then((SharedPreferences prefs) {
        prefs.setInt('type', 0);
        prefs.setString('id', user['_id']);
        prefs.setString('firstName', user['firstName']);
        prefs.setString('lastName', user['lastName']);
        prefs.setString('sex', user['sex']);
        prefs.setString('phoneNumber', user['phoneNumber']);
        prefs.setString('mail', user['mail']);
        prefs.setString('address', user['address']);
      });
      return user;
    } else
      return null;
  }
}
