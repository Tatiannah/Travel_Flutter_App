import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/client.dart';
import 'package:projet1/screens/edit_client_screen.dart';
import 'package:projet1/screens/add_client_screen.dart'; // Assurez-vous que ce chemin est correct

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
    _fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClientScreen()),
              );
              if (result == true) {
                _fetchClients();
              }
            },
          ),
        ],
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
                return ListTile(
                  title: Text(client.nom),
                  subtitle: Text(client.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                );
              },
            ),
          ),
        ],
      ),
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
