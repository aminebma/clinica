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
                child: Image.network(
                  "${_request.picture}",
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
                  child: Text(
                    'Traitements actuels: ${_request.treatments}',
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
