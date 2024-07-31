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
    final reservations = await DatabaseHelper.instance.queryAllReservations();
    setState(() {
      _reservationList = reservations;
    });
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
          final reservation = _reservationList[index];
          return ListTile(
            title: Text(reservation.nom),
            subtitle: Text(
                'Hôtel: ${reservation.nomHotel} - Destination: ${reservation.nomDestination}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditReservationScreen(reservation: reservation),
                ),
              ).then((_) => _loadReservations()); // Reload reservations on return
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReservationScreen()),
          );
          if (result == 'refresh') {
            _loadReservations();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
