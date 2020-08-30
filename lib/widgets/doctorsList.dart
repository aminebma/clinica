import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:clinica/models/doctor.dart';
import 'package:clinica/services/doctors.dart';
import 'package:clinica/widgets/listFilter.dart';

class DoctorsList extends StatefulWidget {
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  List<String> _criteria = [
    'Cardiologue',
    'Dentiste',
    'Dermatologue',
    'Gastrologue',
    'Généraliste',
    'Gynécologue',
    'Pédiatre',
    'Psychologue',
    'Radiologue',
    'Urologue'
  ];
  List<String> _filters = [];

  Future<List<Doctor>> loadDoctorsData() async {
    print('Loading data...');
    Doctors instance = Doctors();
    List<Doctor> listOfDoctors = await instance.getDoctors()
      ..removeWhere((Doctor doctor) =>
          (_filters.length != 0 && !_filters.contains(doctor.speciality)));
    print('Data loaded :D');
    return listOfDoctors;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 15,
            bottom: 10,
          ),
          child: Text(
            'Filtrer par spécialité',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListFilter(
          _criteria,
          _filters,
          onFilter: () {
            setState(() {});
          },
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
          height: MediaQuery.of(context).size.height - 250,
          child: FutureBuilder(
            future: loadDoctorsData(),
            builder: (BuildContext c, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext c, int index) {
                    return Card(
                      elevation: 7.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[400], width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Column(
                        children: [
                          Image.network(
                            "${snapshot.data[index].picture}",
                            scale: 1.0,
                            repeat: ImageRepeat.noRepeat,
                            fit: BoxFit.fill,
                            height: 250,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            "${snapshot.data[index].speciality}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 19,
                            ),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            "${snapshot.data[index].phoneNumber}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 19,
                            ),
                          ),
                          RaisedButton.icon(
                            icon: Icon(
                              Icons.question_answer,
                              color: Colors.blue,
                            ),
                            label: Text(
                              "Demander un diagnostique",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () {
                              print('Demande de diagnostique envoyée !');
                            },
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: SpinKitChasingDots(
                    color: Colors.blue,
                    size: 50,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
