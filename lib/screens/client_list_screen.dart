import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/client.dart';
import 'package:projet1/screens/edit_client_screen.dart';
import 'package:projet1/screens/add_client_screen.dart'; // Assurez-vous que ce chemin est correct
import 'package:toastification/toastification.dart';

class ClientListScreen extends StatefulWidget {
  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    final clients = await DatabaseHelper.instance.queryAllClients();
    setState(() {
      _clients = clients;
      _filteredClients = clients;
    });
  }

  void _filterClients(String query) {
    setState(() {
      _searchQuery = query;
      _filteredClients = _clients.where((client) {
        final lowerCaseQuery = query.toLowerCase();
        return client.nom.toLowerCase().contains(lowerCaseQuery) ||
            client.email.toLowerCase().contains(lowerCaseQuery) ||
            client.phone.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _deleteClient(int id) async {
    await DatabaseHelper.instance.deleteClient(id);
    toastification.show(
        context: context, // optional if you use ToastificationWrapper
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        title: Text('Successful!'),
        // you can also use RichText widget for title and description parameters
        description: RichText(text: const TextSpan(text: 'Client deleted successfully ')),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300)
    );
    _fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients List',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Texte en gras
            fontSize: 25.0,
            // Taille de la police
          )),
        centerTitle: true, // Centre le titre dans l'AppBar
      ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterClients,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredClients.length,
              itemBuilder: (context, index) {
                final client = _filteredClients[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Espacement autour de chaque élément
                  elevation: 4, // Élémentation de l'ombre de la carte
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordures arrondies
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        client.nom.isNotEmpty ? client.nom[0].toUpperCase() : '?', // Première lettre du nom ou '?' si vide
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue, // Couleur de fond de l'avatar
                    ),
                    title: Text(
                    client.nom,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Texte en gras
                      fontSize: 15.0,              // Taille de la police
                    ),
                  ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            Icon(Icons.email, size: 16), // Icône d'email
                            // Espacement entre l'icône et le texte
                            Text(client.email),
                          ],
                        ),
                        SizedBox(height: 4), // Espacement entre les lignes
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16), // Icône de téléphone
                            SizedBox(width: 4), // Espacement entre l'icône et le texte
                            Text(client.phone),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.edit),

                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditClientScreen(client: client),
                              ),
                            );
                            if (result == true) {
                              _fetchClients();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (client.id != null) {
                              _showDeleteConfirmationDialog(client.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClientScreen()),
          );
          if (result == true) {
            _fetchClients();
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positionnement en bas à droite
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Client'),
          content: Text('Are you sure you want to delete this client?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteClient(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
