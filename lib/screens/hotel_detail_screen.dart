import 'package:flutter/material.dart';
import 'package:projet1/models/hotel.dart';
import 'package:projet1/services/database_helper.dart';
import 'edit_hotel_screen.dart';
import 'dart:io';
import 'package:toastification/toastification.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  HotelDetailScreen({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.nom),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditHotelScreen(hotel: hotel),
                ),
              );
              if (result == true) {
                // Si une modification a été effectuée, recharger les données
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (hotel.image != null && hotel.image!.isNotEmpty)
                ? Image.file(
              File(hotel.image!),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            )
                : Container(
              height: 250,
              color: Colors.grey[300],
              child: Icon(Icons.hotel, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.hotel, size: 24, color: Colors.blue),
                      SizedBox(width: 8), // Corrected value
                      Text(
                        hotel.nom,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8), // Corrected value
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 24, color: Colors.blue),
                      SizedBox(width: 8), // Corrected value
                      Text(
                        '${hotel.lieu}',
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, size: 24, color: Colors.blue),
                      SizedBox(width: 8), // Corrected value
                      Text(
                        '${hotel.prix} Ar/night',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.description, size: 24, color: Colors.blue),
                      SizedBox(width: 8), // Corrected value
                      Expanded(
                        child: Text(
                          hotel.description ?? 'Aucune description disponible.',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    // Afficher une boîte de dialogue de confirmation avant de supprimer
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm deletion'),
                        content: Text('Are you sure you want to remove this hotel from your list?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    // Si l'utilisateur confirme la suppression, procéder à la suppression
                    if (confirmDelete) {
                      await DatabaseHelper.instance.deleteHotel(hotel.id!);
                      toastification.show(
                        context: context, // optional if you use ToastificationWrapper
                        type: ToastificationType.success,
                        style: ToastificationStyle.fillColored,
                        autoCloseDuration: const Duration(seconds: 3),
                        title: Text('Successful!'),
                        // you can also use RichText widget for title and description parameters
                        description: RichText(text: const TextSpan(text: 'Hotel deleted successfully ')),
                        alignment: Alignment.topRight,
                        direction: TextDirection.ltr,
                        animationDuration: const Duration(milliseconds: 300),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                  child: Icon(Icons.delete),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
