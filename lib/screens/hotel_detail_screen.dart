import 'package:flutter/material.dart';
import 'package:projet1/models/hotel.dart';
import 'package:projet1/services/database_helper.dart';
import 'edit_hotel_screen.dart';
import 'dart:io';

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
                  Text(
                    hotel.nom,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${hotel.lieu}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${hotel.prix} Ar/night',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    hotel.description ?? 'Aucune description disponible.',
                    style: TextStyle(fontSize: 16),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Afficher une boîte de dialogue de confirmation avant de supprimer
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm deletion'),
                      content: Text('Are you sure you want to remove this hotel from your list ?'),
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
                    Navigator.pop(context, true);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

