import 'package:clinica/models/crequest.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  Future<List<CRequest>> getRequests(bool isDoctor) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var id =
        await _prefs.then((SharedPreferences prefs) => prefs.getString('id'));
    List<CRequest> requestsData = [];
    var url = isDoctor
        ? 'https://clinicaapp.herokuapp.com/api/requests/$id'
        : 'https://clinicaapp.herokuapp.com/api/requests/patient/$id';
    var response = await get(url);
    if (response.statusCode == 200) {
      var requests = jsonDecode(response.body);
      for (var request in requests) {
        List<String> listOfSymptoms = [];
        for (var symptom in request['symptoms']) listOfSymptoms.add(symptom);
        requestsData.add(CRequest(
            id: request['_id'],
            patientId: request['patientId'],
            doctorId: request['doctorId'],
            patientFirstName: request['patientFirstName'],
            patientLastName: request['patientLastName'],
            symptoms: listOfSymptoms,
            treatments: request['treatments'],
            picture:
                "https://clinicaapp.herokuapp.com/images/${request['picture']}",
            response: request['response'],
            status: request['status']));
      }
    }
    return requestsData;
  }

  Future<bool> newRequest(CRequest request) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var patientData = await _prefs.then((SharedPreferences prefs) {
      return {
        'patientId': prefs.getString('id'),
        'patientFirstName': prefs.getString('firstName'),
        'patientLastName': prefs.getString('lastName'),
      };
    });
    //TODO Construct the body of the post request
    var url = 'https://clinicaapp.herokuapp.com/api/requests/new';
    var response = await post(url);
    if (response.statusCode == 200)
      return true;
    else {
      print(response.body);
      return false;
    }
  }
}
