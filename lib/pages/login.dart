import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Login extends StatelessWidget {
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
                'Login screen',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lobster',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Username',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lobster',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lobster',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 36,
                    width: 120,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      child: Text(
                        'S\'inscrire',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 120,
                    child: RaisedButton(
                      onPressed: () async {
                        var url =
                            'http://899759e0d2bb.ngrok.io/api/accounts/sign-in';
                        var response = await post(url, body: {
                          'phoneNumber': '+213696709244',
                          'password': '1234'
                        });
                        Map user = jsonDecode(response.body);
                        if (user["type"] == 0)
                          Navigator.pushReplacementNamed(
                            context,
                            '/home-patient',
                            arguments: user,
                          );
                        else
                          Navigator.pushReplacementNamed(
                            context,
                            '/home-doctor',
                            arguments: user,
                          );
                      },
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
