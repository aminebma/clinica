import 'package:clinica/pages/requestDetails.dart';
import 'package:flutter/material.dart';

import 'package:clinica/services/requests.dart';
import 'package:clinica/models/crequest.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsList extends StatefulWidget {
  bool isDoctor = false;

  RequestsList({this.isDoctor});

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  Future<List<CRequest>> loadRequestsData() async {
    print('Loading requests data...');
    Requests instance = Requests();
    List<CRequest> listOfRequests = await instance.getRequests(widget.isDoctor);
    print('Requests data loaded :D');
    return listOfRequests;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Text(
            'Mes diagnostiques',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Lobster',
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
        height: MediaQuery.of(context).size.height - 250,
        child: FutureBuilder(
          future: loadRequestsData(),
          builder: (BuildContext c, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext c, int index) {
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300),
                    tween: Tween<double>(begin: 15, end: 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RequestDetails(snapshot.data[index])));
                      },
                      child: ListTile(
                        leading: Hero(
                          tag: 'request-${snapshot.data[index].id}',
                          child: ClipRRect(
                            child: Image.network(
                              '${snapshot.data[index].picture}',
                              height: 50,
                              width: 50,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        title: Text(
                          snapshot.data[index].symptoms[0],
                        ),
                        subtitle: Text(
                          snapshot.data[index].treatments,
                        ),
                        trailing: snapshot.data[index].status == 'pending'
                            ? Wrap(
                                spacing: 12,
                                children: [
                                  Text(
                                    'En cours',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.orange),
                                  ),
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.orange,
                                    semanticLabel: 'En cours',
                                  ),
                                ],
                              )
                            : Wrap(
                                spacing: 12,
                                children: [
                                  Text(
                                    'Répondu',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.green),
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    semanticLabel: 'Répondu',
                                  ),
                                ],
                              ),
                      ),
                    ),
                    builder:
                        (BuildContext context, double value, Widget child) {
                      return Padding(
                        padding: EdgeInsets.only(top: value),
                        child: child,
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                  size: 50,
                ),
              );
            }
          },
        ),
      ),
    ]);
  }
}
