import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:sortedmap/sortedmap.dart';

import 'package:clinica/services/requests.dart';
import 'package:clinica/models/crequest.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Color> listOfColors = [Colors.green, Colors.orange];
  double _taux = 0;

  Future<Map> loadStats() async {
    print('Loading pie chart statistics data...');
    Map<String, double> listOfTwoDaysStats;
    Requests instance = Requests();
    List<CRequest> listOfTwoDaysRequests = await instance.getTwoDaysRequests();
    var today = DateTime.now();
    var listOfTodayRequests = List.of(listOfTwoDaysRequests)
      ..removeWhere((CRequest element) => today.day != element.date.day);
    var todayRequests = listOfTodayRequests.length.toDouble();
    var yesterdayRequests = listOfTwoDaysRequests.length - todayRequests;
    listOfTwoDaysStats = {
      "Traitées": todayRequests,
      "Non-traitées": yesterdayRequests,
    };
    _taux = todayRequests == 0
        ? 0
        : (todayRequests - yesterdayRequests) * 100 / todayRequests;
    print('Pie chart statistics data loaded :D');
    print('Loading sparkline statistics data...');
    List<double> listOfStats = [];
    var countMap = SortedMap<String, double>(Ordering.byKey());
    var listOfRequests = await instance.getAllRequestsDates();
    listOfRequests.forEach((date) => countMap[date] =
        !countMap.containsKey(date) ? (1) : (countMap[date] + 1));

    countMap.forEach((key, value) {
      listOfStats.add(value);
    });
    print('Sparkline statistics data loaded  :D');
    return {
      "twoDays": listOfTwoDaysStats,
      "daily": listOfStats,
      "reqNumber": listOfRequests.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              'Mon tableau de bord',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Lobster',
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
          height: MediaQuery.of(context).size.height - 250,
          child: FutureBuilder(
            future: loadStats(),
            builder: (BuildContext c, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return StaggeredGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    Material(
                      elevation: 14,
                      shadowColor: Color(0x802196F3),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'Demandes de diagnostique du jour',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              PieChart(
                                dataMap: snapshot.data['twoDays'],
                                colorList: listOfColors,
                                legendPosition: LegendPosition.bottom,
                                chartRadius: 150,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 14,
                      shadowColor: Color(0x802196F3),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'Nombre de demandes total',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Center(
                                child: Text(
                                  snapshot.data['reqNumber'].toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Sparkline(
                                data: snapshot.data['daily'],
                                fillMode: FillMode.below,
                                fillGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: _taux > 0
                                      ? [Colors.blue[800], Colors.blue[200]]
                                      : [Colors.red[800], Colors.red[200]],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 14,
                      shadowColor: Color(0x802196F3),
                      borderRadius: BorderRadius.circular(24),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "Taux d'évolution",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                  _taux > 0
                                      ? '+${_taux.toStringAsFixed(2)} %'
                                      : '${_taux.toStringAsFixed(2)} %',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _taux > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                              _taux > 0
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 50,
                                    )
                                  : Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                      size: 50,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(2, 300),
                    StaggeredTile.extent(1, 200),
                    StaggeredTile.extent(1, 200),
                  ],
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
    );
  }
}
