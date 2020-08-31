import 'package:clinica/models/crequest.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Requests {
  Future<List<CRequest>> getRequests(bool isDoctor, String id) async {
    List<CRequest> requestsData = [];
    var url = isDoctor
        ? 'https://clinicaapp.herokuapp.com/api/requests/$id'
        : 'https://clinicaapp.herokuapp.com/api/requests/patient/$id';
    var response = await get(url);
    if (response.statusCode == 200) {
      var requests = jsonDecode(response.body);
      for (var request in requests) {
        requestsData.add(CRequest(
            id: request['_id'],
            patientId: request['patientId'],
            patientFirstName: request['patientFirstName'],
            patientLastName: request['patientLastName'],
            symptoms: request['symptoms'],
            treatments: request['treatments'],
            picture:
                "https://clinicaapp.herokuapp.com/images/${request['picture']}",
            response: request['response'],
            status: request['status']));
      }
    }
    return requestsData;
  }
}
