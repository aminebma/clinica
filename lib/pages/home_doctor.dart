import 'package:clinica/widgets/dashboard.dart';
import 'package:clinica/widgets/requestsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map _user = {};
  List<Widget> _displayedPage = [
    RequestsList(
      isDoctor: true,
    ),
    DashBoard(),
  ];
  int _selectedIndex = 0;

  void loadUserData() async {
    var userData = await _prefs.then((SharedPreferences prefs) {
      return {
        "firstName": prefs.getString('firstName'),
        "lastName": prefs.getString('lastName'),
        "sex": prefs.getString('sex'),
        "phoneNumber": prefs.getString('phoneNumber'),
        "speciality": prefs.getString('speciality'),
        "picture": prefs.getString('picture')
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
                _user['picture'],
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
            icon: Icon(Icons.equalizer),
            title: Text("Tableau de bord"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
