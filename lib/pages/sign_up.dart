import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  String _firstName, _lastName, _address, _mail, _phoneNumber;
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

  Widget _signUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          _lastNameField(),
          _firstNameField(),
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
        onPressed: _submit,
      ),
    );
  }

  void _submit() async {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();
      var url = 'https://clinicaapp.herokuapp.com/api/accounts/sign-up';
      Map user = {
        'firstName': _firstName,
        'lastName': _lastName,
        'address': _address,
        'mail': _mail,
        'phoneNumber': '+213$_phoneNumber',
      };
      var response = await post(
        url,
        body: user,
      );
      var sid = response.body;
      Navigator.pushNamed(_context, '/sign_up/verify', arguments: {
        'sid': sid,
        'firstName': user['firstName'],
        'lastName': user['lastName'],
        'address': user['address'],
        'mail': user['mail'],
        'phoneNumber': user['phoneNumber'],
      });
    }
  }
}
