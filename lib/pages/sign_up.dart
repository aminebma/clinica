import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Clinica - Inscription',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sign up screen',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lobster',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
