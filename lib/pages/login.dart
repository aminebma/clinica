import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Login extends StatelessWidget {
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  Widget _entryField(String title, {bool isPassword = false}) {
    if (isPassword) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              keyboardType: TextInputType.number,
              obscureText: isPassword,
              decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
              controller: passwordController,
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              keyboardType: TextInputType.phone,
              obscureText: isPassword,
              decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  labelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  prefixText: '+213',
                  prefixStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
              controller: phoneNumberController,
            )
          ],
        ),
      );
    }
  }

  Widget _phonePasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Numéro de téléphone"),
        _entryField("Mot de passe", isPassword: true),
      ],
    );
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                  'La santé sur le bout des doigts !',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Lobster',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: _phonePasswordWidget(),
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
                              'http://192.168.1.7:3000/api/accounts/sign-in';
                          var response = await post(
                            url,
                            body: {
                              'phoneNumber':
                                  '+213${phoneNumberController.text}',
                              'password': passwordController.text,
                            },
                          );
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
      ),
    );
  }
}
