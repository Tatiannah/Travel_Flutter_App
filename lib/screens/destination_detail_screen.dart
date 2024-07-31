import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import '../models/destination.dart';
import 'edit_destination_screen.dart';
import 'dart:io';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  DestinationDetailScreen({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.nom),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDestinationScreen(destination: destination),
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
            (destination.image != null && destination.image!.isNotEmpty)
                ? Image.file(
              File(destination.image!),
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
                    destination.nom,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${destination.lieu}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${destination.prix} Ar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    destination.description,
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
                      content: Text('Are you sure you want to delete this destination ?'),
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
                    await DatabaseHelper.instance.deleteDestination(destination.id!);
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
