import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clinica/widgets/doctorsList.dart';
import 'package:clinica/widgets/requestsList.dart';

class HomePatient extends StatefulWidget {
  @override
  _HomePatientState createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map _user = {};
  int _selectedIndex = 0;
  List<Widget> _displayedPage = [
    DoctorsList(),
    RequestsList(
      isDoctor: false,
    ),
  ];

  void loadUserData() async {
    var userData = await _prefs.then((SharedPreferences prefs) {
      return {
        "firstName": prefs.getString('firstName'),
        "lastName": prefs.getString('lastName'),
        "sex": prefs.getString('sex'),
        "phoneNumber": prefs.getString('phoneNumber'),
        "mail": prefs.getString('mail'),
        "address": prefs.getString('address')
      };
    });
    setState(() {
      _user = userData;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${_user['firstName'].toString().toUpperCase().substring(0, 1)}.${_user['lastName']}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              accountEmail: Text(
                "${_user['phoneNumber']}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              currentAccountPicture: Image.network(
                "https://www.concordrusam.com/wp-content/uploads/2017/10/pro.jpg",
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Se déconnecter'),
              onTap: () {
                _prefs.then((SharedPreferences prefs) => prefs.clear());
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
      body: _displayedPage.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text("Diagnostiques"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
