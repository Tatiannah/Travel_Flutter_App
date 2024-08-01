import 'package:flutter/material.dart';
import 'package:projet1/screens/client_list_screen.dart';
import 'package:projet1/screens/hotel_list_screen.dart';
import 'package:projet1/screens/destination_list_screen.dart';
import 'package:projet1/screens/reservation_list_screen.dart';
import 'package:projet1/screens/statistics.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Booking App',
      theme: ThemeData(
        primarySwatch: Colors.red,

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
    ClientChart()
  ];

  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('FF');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor('#244D61'),
        title: Row(
          children: <Widget>[
            Text(
              'Travel Booking App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontFamily: 'Tahoma',
                color: Colors.white70,
              ),
            ),
            Spacer(), // Pour espacer le texte et l'icône/logo
            Icon(
              Icons.notifications, // Remplacez avec votre icône ou image
              color: Colors.white70,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Destinations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}