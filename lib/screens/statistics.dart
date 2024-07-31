import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClientChart extends StatefulWidget {
  @override
  _ClientChartState createState() => _ClientChartState();
}

class _ClientChartState extends State<ClientChart> {
  int _clientCount = 0;
  int _HotelCount = 0;
  int _DestinationCount = 0;
  int _ReservationCount = 0;
  Map<String, int> _data = {};
  Map<String, int> _dataHotel = {};


  @override
  void initState() {
    super.initState();
    _loadClientCount();
    _loadHotelCount();
    _loadDestinationCount();
    _loadReservationCount();
    _fetchData();
    _fetchDataforHotel;
  }


  Future<void> _fetchData() async {
    final data = await DatabaseHelper.instance.getReservationsCountByPlace();
    setState(() {
      _data = data;
    });
  }

  Future<void> _fetchDataforHotel() async {
    final data = await DatabaseHelper.instance.getReservationsCountByHotel();
    setState(() {
      _dataHotel = data;
    });
  }

  Future<void> _loadClientCount() async {
    final clientList = await DatabaseHelper.instance.queryAllClients();
    setState(() {
      _clientCount = clientList.length;
    });
  }

  Future<void> _loadHotelCount() async {
    final HotelList = await DatabaseHelper.instance.queryAllHotels();
    setState(() {
      _HotelCount = HotelList.length;
    });
  }

  Future<void> _loadDestinationCount() async {
    final HotelList = await DatabaseHelper.instance.queryAllDestinations();
    setState(() {
      _DestinationCount = HotelList.length;
    });
  }

  Future<void> _loadReservationCount() async {
    final HotelList = await DatabaseHelper.instance.queryAllReservations();
    setState(() {
      _ReservationCount = HotelList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = _data.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();

    List<ChartData> chartDataHotel = _dataHotel.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: ListView(
            children: [

              SizedBox(height: 50),
              Container(
                height: 200, // Fixer une hauteur si nécessaire
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: _clientCount.toDouble(),
                        title: 'Clients :'+ _clientCount.toString(),
                        color: Colors.blue,
                        radius: 100,
                        showTitle: true,

                      ),
                      PieChartSectionData(
                        value: _HotelCount.toDouble(),
                        title: 'Hotels:' + _HotelCount.toString(),
                        color: Colors.red,
                        showTitle: true,
                        radius: 100,
                      ),

                      PieChartSectionData(
                        value: _DestinationCount.toDouble(),
                        title: 'Destinations:' + _DestinationCount.toString(),
                        color: Colors.greenAccent,
                        showTitle: true,
                        radius: 100,
                      ),

                      PieChartSectionData(
                        value: _ReservationCount.toDouble(),
                        title: 'Reservations:' + _ReservationCount.toString(),
                        color: Colors.yellow,
                        showTitle: true,
                        radius: 100,
                      ),


                    ],
                    sectionsSpace: 0,
                    startDegreeOffset: 0,
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: true),

                  ),
                  swapAnimationDuration: Duration(milliseconds: 1000), // Durée de l'animation
                  swapAnimationCurve: Curves.easeInOut, // Courbe de l'animation
                ),
              ),
              SizedBox(height: 75),
              SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  LineSeries<ChartData, String>(
                    enableTooltip: true,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    // Optionnel: Ajouter un nom à la série
                    name: 'The most Destination selected by Clients',
                  )
                ],
              ),
              SizedBox(height: 75),
              SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  LineSeries<ChartData, String>(
                    enableTooltip: true,
                    dataSource: chartDataHotel,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    // Optionnel: Ajouter un nom à la série
                    name: 'The most Hotel selected by Clients',
                  )
                ],
              ),

            ],
          )
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}