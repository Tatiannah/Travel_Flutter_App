import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
 // Assurez-vous d'avoir ce modèle
import 'dart:async';
import 'package:projet1/screens/client_list_screen.dart';  // Assurez-vous que ce fichier existe et contient la classe ClientListScreen
import 'package:projet1/screens/hotel_list_screen.dart';   // Assurez-vous que ce fichier existe et contient la classe HotelList
import 'package:projet1/screens/destination_list_screen.dart'; // Assurez-vous que ce fichier existe et contient la classe DestinationList
import 'package:projet1/screens/reservation_list_screen.dart'; // Assurez-vous que ce fichier existe et contient la classe ReservationList
import 'package:projet1/screens/statistics.dart'; // Assurez-vous que ce fichier existe et contient la classe ClientChart
import 'dart:async';

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

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  final List<Widget> _pages = [
    ClientListScreen(),
    HotelList(),
    DestinationList(),
    ReservationList(),
    ClientChart()
  ];

  Timer? _timer;

  int _selectedIndex = 4;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _unconfirmedCount = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _fetchUnconfirmedCount();
    _updateNotificationCount();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _updateNotificationCount();
    });
  }

  Future<void> _updateNotificationCount() async {
    final count = await DatabaseHelper.instance.countUnconfirmed();
    setState(() {
      _unconfirmedCount = count;
      if (_unconfirmedCount == 0) {
        _animationController.stop();
      } else {
        _animationController.repeat(reverse: true);
      }
    });
  }

  Future<void> _fetchUnconfirmedCount() async {
    // Initial fetching of unconfirmed count
    final count = await DatabaseHelper.instance.countUnconfirmed();
    setState(() {
      _unconfirmedCount = count;
      if (_unconfirmedCount == 0) {
        _animationController.stop();
      } else {
        _animationController.repeat(reverse: true);
      }
    });
  }

  void _showUnconfirmedDialog() async {

    final unconfirmed = await DatabaseHelper.instance.queryUnconfirmed();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unconfirmed Items'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: unconfirmed.map((reservation) {
              return ListTile(
                title: Text(reservation.nom), // Assurez-vous d'utiliser le bon champ
                subtitle: Text('Status: ${reservation.isConfirmed ? 'Confirmed' : 'Not Confirmed'}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
            Spacer(),
            Stack(
              children: [
                IconButton(
                  icon: RotationTransition(
                    turns: _animation,
                    child: Icon(Icons.notifications, color: Colors.white70),
                  ),
                  onPressed: _showUnconfirmedDialog,
                ),
                if (_unconfirmedCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '$_unconfirmedCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('FF');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
