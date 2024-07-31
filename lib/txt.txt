import 'package:flutter/material.dart';
import 'package:projet1/screens/client_list_screen.dart';
import 'package:projet1/screens/hotel_list_screen.dart';
import 'package:projet1/screens/destination_list_screen.dart';
import 'package:projet1/screens/reservation_list_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [
    ClientListScreen(),
    HotelList(),
  DestinationList(),
   ReservationList(),
  ];

  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Booking App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Clients'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              title: Text('Hôtels'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              title: Text('Destinations'),
              onTap: () => _selectPage(2),
            ),
            ListTile(
              title: Text('Réservations'),
              onTap: () => _selectPage(3),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
