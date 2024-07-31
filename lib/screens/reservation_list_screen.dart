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
      body: _reservationList.isEmpty
          ? Center(child: Text('Aucune réservation trouvée'))
          : ListView.builder(
        itemCount: _reservationList.length,
        itemBuilder: (context, index) {
          final reservation = _reservationList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(Icons.hotel, size: 40, color: Colors.blue),
              title: Text(
                reservation.nom,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hôtel: ${reservation.nomHotel}'),
                  Text('Destination: ${reservation.nomDestination}'),
                  SizedBox(height: 8),
                  Text(
                    'Dates: ${reservation.dateArrivee} - ${reservation.dateDepart}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Chip(
                          label: Text('${reservation.nbr_chambre} Chambres'),
                          backgroundColor: Colors.orange[100],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Chip(
                          label: Text('${reservation.nbr_pers} Personnes'),
                          backgroundColor: Colors.green[100],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditReservationScreen(reservation: reservation),
                  ),
                ).then((_) => _loadReservations()); // Reload reservations on return
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Supprimer la Réservation'),
                      content: Text('Êtes-vous sûr de vouloir supprimer cette réservation?'),
                      actions: [
                        TextButton(
                          child: Text('Annuler'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text('Supprimer'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );

          if (confirm) {
          if (reservation.id != null) {
          await DatabaseHelper.instance.deleteReservation(reservation.id!);
          _loadReservations();
          } else {
          // Gérez le cas où l'ID est nul si nécessaire
          print('Erreur : ID de réservation nul');
          }
          }


        },
              ),
            ),
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
