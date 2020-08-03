import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SignUp extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final mailController = TextEditingController();
  final phoneController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

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
            keyboardType: TextInputType.number,
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
            controller: firstNameController,
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
            keyboardType: TextInputType.number,
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
            controller: lastNameController,
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
            keyboardType: TextInputType.number,
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
            controller: addressController,
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
            keyboardType: TextInputType.number,
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
            controller: mailController,
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
              ),
              prefixText: '213',
              prefixStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            controller: phoneController,
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
        onPressed: () async {
          if (_signUpFormKey.currentState.validate()) {
            var url = 'http://192.168.1.7:3000/api/accounts/sign-up';
            var response = await post(
              url,
              body: {
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'address': addressController.text,
                'mail': mailController.text,
                'phoneNumber': '+213${phoneController.text}',
              },
            );
            var sid = response.body;
            Navigator.pushNamed(context, '/sign_up/verify', arguments: sid);
          }
        },
      ),
    );
  }
}
