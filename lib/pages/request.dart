import 'package:flutter/material.dart';

import 'package:clinica/models/doctor.dart';

class Request extends StatelessWidget {
  final Doctor _doctor;

  Request(this._doctor);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'doctor-${_doctor.id}',
                child: Image.network(
                  "${_doctor.picture}",
                  scale: 1.0,
                  repeat: ImageRepeat.noRepeat,
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text(
                  '${_doctor.firstName} ${_doctor.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text('${_doctor.speciality}\n${_doctor.phoneNumber}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
