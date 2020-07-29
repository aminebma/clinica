import 'package:flutter/material.dart';

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
                      onPressed: () {},
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
