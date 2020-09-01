import 'package:flutter/material.dart';

import 'package:clinica/services/accounts.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum Sexe { Homme, Femme }

class _SignUpState extends State<SignUp> {
  String _firstName, _lastName, _address, _mail, _phoneNumber;
  Sexe _sex = Sexe.Homme;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _signUpFormKey = GlobalKey<FormState>();

  BuildContext _context;

  Widget _firstNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Prénom',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _firstName = value,
          )
        ],
      ),
    );
  }

  Widget _lastNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Nom',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _lastName = value,
          )
        ],
      ),
    );
  }

  Widget _addressField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Adresse',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _address = value,
          )
        ],
      ),
    );
  }

  Widget _mailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Mail',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _mail = value,
          )
        ],
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone',
              labelStyle: TextStyle(
                color: Colors.blue,
                fontSize: 19,
              ),
              prefixText: '+213',
              prefixStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _phoneNumber = value,
          )
        ],
      ),
    );
  }

  Widget _sexField() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.accessibility,
                color: Colors.blue,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Sexe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text(
              'Homme',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            leading: Radio(
              value: Sexe.Homme,
              groupValue: _sex,
              onChanged: (Sexe value) {
                setState(() {
                  _sex = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Femme',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            leading: Radio(
              value: Sexe.Femme,
              groupValue: _sex,
              onChanged: (Sexe value) {
                setState(() {
                  _sex = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          _lastNameField(),
          _firstNameField(),
          _sexField(),
          _addressField(),
          _mailField(),
          _phoneField()
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
          'Inscription',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: isLoading,
                      child: LinearProgressIndicator(
                        value: null,
                      ),
                    ),
                    Image.asset(
                      "assets/logo.png",
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Faites votre premier pas vers la guérison !',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lobster',
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: _signUpForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: isLoading ? null : _submit,
      ),
    );
  }

  void _submit() async {
    if (_signUpFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _signUpFormKey.currentState.save();
      Map user = {
        'firstName': _firstName,
        'lastName': _lastName,
        'sex': _sex == Sexe.Homme ? 'h' : 'f',
        'address': _address,
        'mail': _mail,
        'phoneNumber': '+213$_phoneNumber',
      };
      Accounts instance = Accounts();
      var sid = await instance.signUp(user);
      if (sid != null) {
        Navigator.pushNamed(_context, '/sign_up/verify', arguments: {
          'sid': sid,
          'firstName': user['firstName'],
          'lastName': user['lastName'],
          'sex': user['sex'],
          'address': user['address'],
          'mail': user['mail'],
          'phoneNumber': user['phoneNumber'],
        });
      } else {
        SnackBar snackBar = SnackBar(
          content: Text("Une erreur s'est produite."),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
