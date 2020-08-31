import 'package:flutter/material.dart';

import 'package:clinica/services/accounts.dart';
import 'package:clinica/models/patient.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isConnecting = false;
  String _phoneNumber, _password;

  BuildContext _context;

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
            TextFormField(
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
                filled: true,
              ),
              validator: (value) {
                if (value.isEmpty)
                  return 'Veuillez remplir ce champs';
                else
                  return null;
              },
              onSaved: (value) => _password = value,
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
            TextFormField(
              style: TextStyle(
                fontSize: 19,
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
                filled: true,
              ),
              validator: (value) {
                if (value.isEmpty)
                  return 'Veuillez remplir ce champs';
                else
                  return null;
              },
              onSaved: (value) => _phoneNumber = value,
            )
          ],
        ),
      );
    }
  }

  Widget _phonePasswordWidget() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _entryField("Numéro de téléphone"),
          _entryField("Mot de passe", isPassword: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      key: _scaffoldKey,
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
                Visibility(
                  visible: isConnecting,
                  child: LinearProgressIndicator(
                    value: null,
                  ),
                ),
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
                        onPressed: isConnecting
                            ? null
                            : () {
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
                        onPressed: isConnecting ? null : _submit,
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

  _submit() async {
    if (_loginFormKey.currentState.validate()) {
      setState(() {
        isConnecting = true;
      });
      _loginFormKey.currentState.save();
      Accounts instance = Accounts();
      var user = await instance.connect(_phoneNumber, _password);
      if (user != null) {
        if (user is Patient)
          Navigator.pushReplacementNamed(_context, '/home-patient');
        else
          Navigator.pushReplacementNamed(_context, '/home-doctor');
      } else {
        setState(() {
          isConnecting = false;
        });
        SnackBar snackBar = SnackBar(
          content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }
}
