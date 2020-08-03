import 'package:flutter/material.dart';

class HomePatient extends StatefulWidget {
  @override
  _HomePatientState createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  Map user = {};

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Clinica - Patient',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }
}
