import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/reservation.dart';
import 'add_reservation_screen.dart';
import 'edit_reservation_screen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<Reservation> _reservationList = [];
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<double?> GetPriceHotel(String HotelName) async {
    final String? nameHotel = HotelName; // Assurez-vous que nomHotel n'est pas null

    if (nameHotel == null || nameHotel.isEmpty || HotelName == null || HotelName.isEmpty) {
      print('Hotel name cannot be null or empty');
      return 0 ?? null;
    }

    try {
      final double price = await _searchHotelPrice(nameHotel);
     return price;
    } catch (e) {
      print(e); // Affiche un message d'erreur si le prix de l'hôtel n'est pas trouvé
    }
  }

  Future<double> _searchHotelPrice(String nameHotel) async {
    final double? priceHotel = await DatabaseHelper.instance.getHotelPrice(nameHotel);

    if (priceHotel == null) {
      throw Exception('Price for hotel not found for the given hotel name');
    }

    return priceHotel;
  }

  Future<double?> GetPriceDestination(String DestinationName) async {
    final String? nameDestination = DestinationName; // Assurez-vous que nomHotel n'est pas null

    if (nameDestination == null || nameDestination.isEmpty ||DestinationName == null || DestinationName.isEmpty) {
      print('Destination name cannot be null or empty');
      return 0 ?? null ;
    }

    try {
      final double price = await _searchDestinationPrice(nameDestination);

      return price;
    } catch (e) {
      print(e); // Affiche un message d'erreur si le prix de l'hôtel n'est pas trouvé
    }
  }

  Future<double> _searchDestinationPrice(String nameDestination) async {
    final double? priceDestination = await DatabaseHelper.instance.getDestinationPrice(nameDestination);

    if (priceDestination == null) {
      throw Exception('Price for Destination not found for the given hotel name');
    }


    return priceDestination;
  }


  Future<String> _searchEmail(String name, String phone) async {
    final String? email = await DatabaseHelper.instance.getEmail(name, phone);

    if (email == null) {
      throw Exception('Email not found for the given name and phone');
    }

    return email;
  }


  Future<void> sendEmailHotel(String nameX,String phoneX ,String? Content) async {
    final String name = nameX;
    final String phone = phoneX ;

    try {
      final double? price = await GetPriceHotel(Content ?? 'None');
      final String mailSender = await _searchEmail(name, phone);
      final String body =price.toString();
      final String subject = "hello world";
      final List<String> recipients = [mailSender];



      await sendEmailFunction(
        body: body,
        recipients: recipients,
        subject: subject,
      );
    } catch (e) {
      print(e); // Vous pouvez afficher une alerte ou un message d'erreur ici
    }
  }

  Future<void> sendEmailDestinationHotel(String nameX,String phoneX ,String? ContentDestination,String? ContentHotel ) async {
    final String name = nameX;
    final String phone = phoneX ;

    try {
      final double? priceHotel = await GetPriceHotel(ContentHotel ?? 'None');
      final double? priceDest = await GetPriceDestination(ContentDestination ?? 'None');
      final String mailSender = await _searchEmail(name, phone);
      String concat =  priceHotel.toString() + '' +  priceDest.toString() ;
      final String body = concat;
      final String subject = "hello world";
      final List<String> recipients = [mailSender];

      print(concat);
      print(priceDest);
      print(priceHotel);
      print(mailSender);
      await sendEmailFunction(
        body: body,
        recipients: recipients,
        subject: subject,
      );
    } catch (e) {
      print(e); // Vous pouvez afficher une alerte ou un message d'erreur ici
    }
  }

  Future<void> sendEmailDestination(String nameX,String phoneX ,String? ContentDestination ) async {
    final String name = nameX;
    final String phone = phoneX ;

    try {

      final double? priceDest = await GetPriceDestination(ContentDestination ?? 'None');
      final String mailSender = await _searchEmail(name, phone);
      final String body ='' +  priceDest.toString() ;
      final String subject = "hello world";
      final List<String> recipients = [mailSender];

      await sendEmailFunction(
        body: body,
        recipients: recipients,
        subject: subject,
      );
    } catch (e) {
      print(e); // Vous pouvez afficher une alerte ou un message d'erreur ici
    }
  }


  Future<void> sendEmailFunction({
    required String body,
    required List<String> recipients,
    required String subject,
  }) async {
    final Email email = Email(
      body: body,
      recipients: recipients,
      subject: subject,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  void _loadReservations() async {
    final reservations = await DatabaseHelper.instance.queryAllReservations();
    setState(() {
      _reservationList = reservations;
    });
  }


  Future<void> _confirmReservation(Reservation reservation) async {
    try {
      final db = await DatabaseHelper.instance.database;
      // Vérifiez les disponibilités de l'hôtel
      final hotel = await db.query(
        'hotel',
        where: 'nom = ? AND lieu = ?',
        whereArgs: [reservation.nomHotel, reservation.lieuHotel],
      );

      final bool hotelAvailable = hotel.isNotEmpty &&
          (hotel.first['nbr_chambre_dispo'] as int) >= reservation.nbr_chambre;

      // Vérifiez les disponibilités de la destination
      final destination = await db.query(
        'destination',
        where: 'nom = ? AND lieu = ?',
        whereArgs: [reservation.nomDestination, reservation.lieuDestination],
      );

      final bool destinationAvailable = destination.isNotEmpty &&
          (destination.first['nbr_pers_dispo'] as int) >= reservation.nbr_pers;

      // Vérifiez les deux conditions et mettez à jour les données si disponibles
      if (hotelAvailable && destinationAvailable) {
        await db.update(
          'hotel',
          {'nbr_chambre_dispo': (hotel.first['nbr_chambre_dispo'] as int) - reservation.nbr_chambre},
          where: 'nom = ? AND lieu = ?',
          whereArgs: [reservation.nomHotel, reservation.lieuHotel],
        );

        await db.update(
          'destination',
          {'nbr_pers_dispo': (destination.first['nbr_pers_dispo'] as int) - reservation.nbr_pers},
          where: 'nom = ? AND lieu = ?',
          whereArgs: [reservation.nomDestination, reservation.lieuDestination],
        );

        // Mettre à jour l'état de la réservation
        await db.update(
          'reservation',
          {'isConfirmed': 1},
          where: 'id = ?',
          whereArgs: [reservation.id],
        );

        print('Réservation confirmée pour ${reservation.nom}');

        // Envoyer un email pour la confirmation de l'hôtel et de la destination
        sendEmailDestinationHotel(
            reservation.nom,
            reservation.phone,
            reservation.nomDestination,
            reservation.nomHotel
        );
      } else {
        // Si l'une ou l'autre des conditions échoue, afficher les messages appropriés
        if (!hotelAvailable && !destinationAvailable) {
          print('Hôtel et destination non trouvés ou pas assez de disponibilités.');
        } else if (!hotelAvailable) {
          print('Hôtel non trouvé ou pas assez de chambres disponibles.');
        } else if (!destinationAvailable) {
          print('Destination non trouvée ou pas assez de personnes disponibles.');
        }

        // Envoyer des emails en fonction de la disponibilité
        if (hotelAvailable) {
          await db.update(
            'hotel',
            {'nbr_chambre_dispo': (hotel.first['nbr_chambre_dispo'] as int) - reservation.nbr_chambre},
            where: 'nom = ? AND lieu = ?',
            whereArgs: [reservation.nomHotel, reservation.lieuHotel],
          );

          await db.update(
            'reservation',
            {'isConfirmed': 1},
            where: 'id = ?',
            whereArgs: [reservation.id],
          );

          sendEmailHotel(
              reservation.nom,
              reservation.phone,
              reservation.nomHotel
          );
        }

        if (destinationAvailable) {

          await db.update(
            'destination',
            {'nbr_pers_dispo': (destination.first['nbr_pers_dispo'] as int) - reservation.nbr_pers},
            where: 'nom = ? AND lieu = ?',
            whereArgs: [reservation.nomDestination, reservation.lieuDestination],
          );

          await db.update(
            'reservation',
            {'isConfirmed': 1},
            where: 'id = ?',
            whereArgs: [reservation.id],
          );

          sendEmailDestination(
              reservation.nom,
              reservation.phone,
              reservation.nomDestination
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la confirmation de la réservation: $e');
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