import 'package:clinica/models/doctor.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Doctors {
  Future<List<Doctor>> getDoctors() async {
    List<Doctor> doctorsData = [];
    var url = 'https://clinicaapp.herokuapp.com/api/doctors/';
    var response = await get(url);
    if (response.statusCode == 200) {
      var doctors = jsonDecode(response.body);
      for (var doctor in doctors) {
        doctorsData.add(Doctor(
            id: doctor['_id'],
            firstName: doctor['firstName'],
            lastName: doctor['lastName'],
            speciality: doctor['speciality'],
            phoneNumber: doctor['phoneNumber'],
            picture:
                "https://clinicaapp.herokuapp.com/images/${doctor['picture']}"));
      }
    }
    return doctorsData;
  }
}
