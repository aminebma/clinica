import 'package:clinica/models/doctor.dart';
import 'package:clinica/services/doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePatient extends StatefulWidget {
  @override
  _HomePatientState createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  Map user = {};
  int _selectedIndex = 0;

  Future<List<Doctor>> loadDoctorsData() async {
    print('Loading data...');
    Doctors instance = Doctors();
    var listOfDoctors = await instance.getDoctors();
    print('Data loaded :D');
    return listOfDoctors;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    print(user);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Clinica - Patient',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${user['firstName'].toString().toUpperCase().substring(0, 1)}.${user['lastName']}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              accountEmail: Text(
                "${user['phoneNumber']}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              currentAccountPicture: Image.network(
                  "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Se déconnecter'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
            height: MediaQuery.of(context).size.height - 200,
            child: FutureBuilder(
              future: loadDoctorsData(),
              builder: (BuildContext c, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext c, int index) {
                      return Card(
                        elevation: 7.0,
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          children: [
                            Image.network(
                              "${snapshot.data[index].picture}",
                              scale: 1.0,
                              repeat: ImageRepeat.noRepeat,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Divider(
                              height: 10,
                            ),
                            Text(
                              "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Divider(
                              height: 10,
                            ),
                            Text(
                              "${snapshot.data[index].speciality}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                              ),
                            ),
                            Divider(
                              height: 10,
                            ),
                            Text(
                              "${snapshot.data[index].phoneNumber}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                              ),
                            ),
                            RaisedButton.icon(
                              icon: Icon(
                                Icons.question_answer,
                                color: Colors.blue,
                              ),
                              label: Text(
                                "Demander un diagnostique",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                print('Aille !');
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text("Diagnostics"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
