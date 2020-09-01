import 'package:clinica/models/crequest.dart';
import 'package:flutter/material.dart';

import 'package:clinica/services/requests.dart';

class AnswerRequest extends StatefulWidget {
  final CRequest _request;

  AnswerRequest(this._request);

  @override
  _AnswerRequestState createState() => _AnswerRequestState();
}

class _AnswerRequestState extends State<AnswerRequest> {
  final _answerRequestFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String _response;

  Widget _responseField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLength: 2500,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Diagnostique',
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
            validator: (value) {
              if (value.isEmpty)
                return 'Veuillez remplir ce champs';
              else
                return null;
            },
            onSaved: (value) => _response = value,
          )
        ],
      ),
    );
  }

  Widget _answerRequestForm() {
    return Form(
      key: _answerRequestFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: _responseField(),
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
                tag: 'request-${widget._request.id}',
                child: Image.file(
                  widget._request.picture,
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
                  'Symptômes: ${widget._request.symptoms}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: widget._request.treatments.length == 0
                      ? Text(
                          'Aucun traitment',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          'Traitements actuels: ${widget._request.treatments}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Date d'envoi: ${widget._request.date.day}-${widget._request.date.month}-${widget._request.date.year}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 1,
              ),
              _answerRequestForm(),
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
    if (_answerRequestFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _answerRequestFormKey.currentState.save();
      Requests instance = Requests();
      var isAnswered =
          await instance.answerRequest(widget._request.id, _response);
      if (isAnswered) {
        Navigator.pushReplacementNamed(context, '/home-doctor');
      } else {
        SnackBar snackBar = SnackBar(
          content: Text("Une erreur s'est produite"),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
