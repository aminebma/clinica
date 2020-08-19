import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map _user = {};

  void loadUserData() async {
    var userData = await _prefs.then((SharedPreferences prefs) {
      return {
        "firstName": prefs.getString('firstName'),
        "lastName": prefs.getString('lastName'),
        "sex": prefs.getString('sex'),
        "phoneNumber": prefs.getString('phoneNumber'),
        "speciality": prefs.getString('speciality'),
        "picture": prefs.getString('picture')
      };
    });
    setState(() {
      _user = userData;
    });
  }

  @override
  void initState() async {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Clinica',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          _prefs.then((SharedPreferences prefs) => prefs.clear());
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }
}
