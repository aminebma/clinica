import 'package:flutter/material.dart';

import 'package:clinica/pages/login.dart';
import 'package:clinica/pages/sign_up.dart';
import 'package:clinica/pages/confirmSignUp.dart';
import 'package:clinica/pages/home_patient.dart';
import 'package:clinica/pages/home_doctor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/sign_up': (context) => SignUp(),
        '/sign_up/verify': (context) => ConfirmSignUp(),
        '/home-patient': (context) => HomePatient(),
        '/home-doctor': (context) => HomeDoctor(),
      },
    );
  }
}
