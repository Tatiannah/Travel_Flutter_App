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

  Future<void> _confirmReservation(Reservation reservation) async {
    final db = await DatabaseHelper.instance.database;
    final hotel = await db.query(
      'hotel',
      where: 'nom = ? AND lieu = ?',
      whereArgs: [reservation.nomHotel, reservation.lieuHotel],
    );

    if (hotel.isNotEmpty) {
      final availableRooms = hotel.first['nbr_chambre_dispo'] as int;
      if (availableRooms >= reservation.nbr_chambre) {
        // Mettre à jour le nombre de chambres disponibles
        await db.update(
          'hotel',
          {'nbr_chambre_dispo': availableRooms - reservation.nbr_chambre},
          where: 'nom = ? AND lieu = ?',
          whereArgs: [reservation.nomHotel, reservation.lieuHotel],
        );
        // Mettre à jour l'état de la réservation
        await db.update(
          'reservation',
          {'isConfirmed': 1},
          where: 'id = ?',
          whereArgs: [reservation.id],
        );
        print('Réservation confirmée pour ${reservation.nom}');
      } else {
        print('Pas assez de chambres disponibles');
      }
    } else {
      print('Hôtel non trouvé');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Réservations'),
      ),
      body: _reservationList.isEmpty
          ? Center(child: Text('Aucune réservation trouvée'))
          : SingleChildScrollView(
        child: Column(
          children: _reservationList.map((reservation) {
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
                        Flexible(
                          child: Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bed, size: 16, color: Colors.orange),
                                SizedBox(width: 4),
                                Text('${reservation.nbr_chambre}'),
                              ],
                            ),
                            backgroundColor: Colors.orange[100],
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person, size: 16, color: Colors.green),
                                SizedBox(width: 4),
                                Text('${reservation.nbr_pers}'),
                              ],
                            ),
                            backgroundColor: Colors.green[100],
                          ),
                        ),
                      ],
                    ),
                    if (reservation.isConfirmed)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'La réservation est confirmée',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
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
                trailing: reservation.isConfirmed
                    ? SizedBox.shrink() // Hide trailing icons if confirmed
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmer la Réservation'),
                            content: Text('Êtes-vous sûr de vouloir confirmer cette réservation?'),
                            actions: [
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Confirmer'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _confirmReservation(reservation);
                          _loadReservations();
                        }
                      },
                    ),
                    IconButton(
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

                        if (confirm == true) {
                          if (reservation.id != null) {
                            await DatabaseHelper.instance.deleteReservation(reservation.id!);
                            _loadReservations();
                          } else {
                            print('Erreur : ID de réservation nul');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
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