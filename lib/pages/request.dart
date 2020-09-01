import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clinica/models/doctor.dart';
import 'package:clinica/models/crequest.dart';
import 'package:clinica/widgets/listFilter.dart';
import 'package:clinica/services/requests.dart';

class Request extends StatefulWidget {
  final Doctor _doctor;

  Request(this._doctor);

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  final _newRequestFormKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  String _otherSymptoms = '', _treatments = '';
  File _picture;
  final picker = ImagePicker();

  List<String> _symptoms = [],
      _filters = [],
      _criteria = [
        'Fièvre',
        'Toux',
        'Maux de gorge',
        'Maux de tête',
        'Douleurs à l\'estomac',
        'Ballonnements',
        'Nausées',
        'Rougeur',
        'Bleu',
        'Gonflement',
        'Démangeaisons'
      ];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _picture = File(pickedFile.path);
      print(pickedFile.path);
    });
  }

  Widget _otherSymptomsField() {
    return Container(
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
            decoration: InputDecoration(
              labelText: 'Autres symptômes (Facultatif)',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.airline_seat_individual_suite,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _otherSymptoms = value,
          )
        ],
      ),
    );
  }

  Widget _treatmentsField() {
    return Container(
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
            decoration: InputDecoration(
              labelText: 'Traitement actuel (Facultatif)',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onSaved: (value) => _treatments = value,
          )
        ],
      ),
    );
  }

  Widget _newRequestForm() {
    return Form(
      key: _newRequestFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            _otherSymptomsField(),
            _treatmentsField(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'doctor-${widget._doctor.id}',
                child: Image.network(
                  "${widget._doctor.picture}",
                  scale: 1.0,
                  repeat: ImageRepeat.noRepeat,
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text(
                  '${widget._doctor.firstName} ${widget._doctor.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    '${widget._doctor.speciality}\n${widget._doctor.phoneNumber}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Symptômes*',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListFilter(
                _criteria,
                _filters,
              ),
              _newRequestForm(),
              Center(
                child: _picture == null ? null : Image.file(_picture),
              ),
              Center(
                child: RaisedButton.icon(
                  color: Colors.blue,
                  label: Text(
                    'Ajouter une photo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
                  onPressed: getImage,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isLoading ? Colors.grey : Colors.blue,
          onPressed: _submit,
          child: isLoading
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  value: null,
                )
              : Icon(
                  Icons.check,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    if (_filters.length != 0) {
      _newRequestFormKey.currentState.save();
      _filters.forEach((String symptom) {
        _symptoms.add(symptom);
      });
      if (_otherSymptoms.length != 0) _symptoms.add(_otherSymptoms);
      CRequest request = CRequest(
        doctorId: widget._doctor.id,
        symptoms: _symptoms,
        treatments: _treatments,
        picture: _picture,
      );
      Requests instance = Requests();
      var isCreated = await instance.newRequest(request);
      if (isCreated)
        Navigator.pop(context);
      else {
        SnackBar snackBar = SnackBar(
          content: Text("Une erreur s'est produite"),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      SnackBar snackBar = SnackBar(
        content: Text("Veuillez sélectionner au moins un symptôme principal."),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    }
  }
}
