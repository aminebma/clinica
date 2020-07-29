import 'package:flutter/material.dart';

import 'package:clinica/pages/login.dart';
import 'package:clinica/pages/sign_up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/sign_up': (context) => SignUp(),
      },
    );
  }
}
