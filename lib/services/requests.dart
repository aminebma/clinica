import 'dart:io';

import 'package:clinica/models/crequest.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    // call http.get method and pass imageUrl into it to get response.
    var response = await http.get(imageUrl);
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<List<CRequest>> getRequests(bool isDoctor) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var id =
        await _prefs.then((SharedPreferences prefs) => prefs.getString('id'));
    List<CRequest> requestsData = [];
    var url = isDoctor
        ? 'https://clinicaapp.herokuapp.com/api/requests/$id'
        : 'https://clinicaapp.herokuapp.com/api/requests/patient/$id';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var requests = jsonDecode(response.body);
      for (var request in requests) {
        File pic = await urlToFile(
            "https://clinicaapp.herokuapp.com/images/${request['picture']}");
        List<String> listOfSymptoms = [];
        for (var symptom in request['symptoms']) listOfSymptoms.add(symptom);
        requestsData.add(CRequest(
            id: request['_id'],
            date: DateTime.parse(request['date']),
            patientId: request['patientId'],
            doctorId: request['doctorId'],
            patientFirstName: request['patientFirstName'],
            patientLastName: request['patientLastName'],
            symptoms: listOfSymptoms,
            treatments: request['treatments'],
            picture: pic,
            response: request['response'],
            status: request['status']));
      }
    }
    return requestsData;
  }

  Future<List<CRequest>> getTwoDaysRequests() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var id =
        await _prefs.then((SharedPreferences prefs) => prefs.getString('id'));
    List<CRequest> requestsData = [];
    var url = 'https://clinicaapp.herokuapp.com/api/requests/$id/all';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var requests = jsonDecode(response.body);
      for (var request in requests) {
        requestsData.add(CRequest(
          id: request['_id'],
          date: DateTime.parse(request['date']),
        ));
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
    var url = 'https://clinicaapp.herokuapp.com/api/requests/new';
    Dio dio = Dio();
    FormData body = FormData.fromMap({
      "date": DateTime.now(),
      "doctorId": request.doctorId,
      "patientId": patientData['patientId'],
      "patientFirstName": patientData['patientFirstName'],
      "patientLastName": patientData['patientLastName'],
      "symptoms": request.symptoms,
      "treatments": request.treatments,
      "picture": await MultipartFile.fromFile(
        request.picture.path,
        filename: request.picture.path.split('/').last,
        contentType: MediaType('image', 'png'),
      ),
    });
    var response = await dio.post(
      url,
      data: body,
    );
    if (response.statusCode == 200)
      return true;
    else {
      print(response.data);
      return false;
    }
  }

  Future<bool> answerRequest(String id, String diagnostic) async {
    var url = 'https://clinicaapp.herokuapp.com/api/requests/response';
    var response = await http.post(
      url,
      body: {
        'id': id,
        'answer': diagnostic,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
