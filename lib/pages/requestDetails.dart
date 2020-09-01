import 'package:clinica/models/crequest.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatelessWidget {
  final CRequest _request;

  RequestDetails(this._request);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'request-${_request.id}',
                child: Image.file(
                  _request.picture,
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
                  'Symptômes: ${_request.symptoms}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: _request.treatments.length == 0
                      ? Text(
                          'Aucun traitment',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          'Traitements actuels: ${_request.treatments}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Date d'envoi: ${_request.date.day}-${_request.date.month}-${_request.date.year}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'Diagnostique',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: _request.response != null
                    ? Text(
                        _request.response,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    : Text(
                        "Le médecin n'a pas encore envoyé de diagnostique.",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
