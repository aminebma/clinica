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
    return Container();
  }
}
