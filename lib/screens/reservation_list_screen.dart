import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/reservation.dart';

import 'add_reservation_screen.dart';
import 'edit_reservation_screen.dart';

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<Reservation> _reservationList = [];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() async {
    _reservationList = await DatabaseHelper.instance.queryAllReservations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Réservations'),
      ),
      body: ListView.builder(
        itemCount: _reservationList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_reservationList[index].nom),
            subtitle: Text(
                'Hôtel: ${_reservationList[index].nomHotel} - Destination: ${_reservationList[index].nomDestination}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditReservationScreen(reservation: _reservationList[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReservationScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
