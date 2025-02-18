import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/destination.dart';
import 'add_destination_screen.dart';
import 'edit_destination_screen.dart';
import 'destination_detail_screen.dart';
import 'dart:io';

class DestinationList extends StatefulWidget {
  @override
  _DestinationListState createState() => _DestinationListState();
}

class _DestinationListState extends State<DestinationList> {
  List<Destination> _destinationList = [];
  List<Destination> _filteredDestinations = []; // Liste filtrée pour la recherche
  String _searchQuery = ""; // Requête de recherche

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  void _loadDestinations() async {
    _destinationList = await DatabaseHelper.instance.queryAllDestinations();
    _filterDestinations(); // Appliquer le filtrage initial (peut-être vide)
  }

  void _filterDestinations() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredDestinations = _destinationList;
      } else {
        _filteredDestinations = _destinationList.where((destination) {
          return destination.nom.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterDestinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Destinations List',
        style: TextStyle(
          fontWeight: FontWeight.bold, // Texte en gras
          fontSize: 25.0,
          // Taille de la police
        )),
    centerTitle: true, // Centre le titre dans l'AppBar
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            // Carrousel horizontal pour les premières cartes
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredDestinations.length > 6 ? 6 : _filteredDestinations.length,
                itemBuilder: (context, index) {
                  final destination = _filteredDestinations[index];
                  return Container(
                    width: 200,
                    margin: EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DestinationDetailScreen(destination: destination),
                            ),
                          );
                          if (result == true) {
                            _loadDestinations();
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (destination.image != null && destination.image!.isNotEmpty)
                                ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                              child: Image.file(
                                File(destination.image!),
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Container(
                              height: 140,
                              color: Colors.grey[300],
                              child: Icon(Icons.home, size: 100),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(destination.nom,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('${destination.prix} Ar/pers',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Liste verticale pour les cartes restantes
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredDestinations.length - 6 > 0 ? _filteredDestinations.length - 6 : 0,
              itemBuilder: (context, index) {
                final destination = _filteredDestinations[index + 6];
                return ListTile(
                  title: Text(destination.nom),
                  subtitle: Text('${destination.prix} Ar/pers'),
                  leading: (destination.image != null && destination.image!.isNotEmpty)
                      ? Image.file(File(destination.image!), width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.home, size: 50),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DestinationDetailScreen(destination: destination),
                      ),
                    );
                    if (result == true) {
                      _loadDestinations(); // Recharger la liste si un hôtel est modifié ou supprimé
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                            _loadDestinations();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Afficher une boîte de dialogue de confirmation avant de supprimer
                          bool confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Deletion'),
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

                          if (confirmDelete) {
                            await DatabaseHelper.instance.deleteDestination(destination.id!);
                            _loadDestinations();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDestinationScreen()),
          ).then((_) => _loadDestinations());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
