import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/client.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Méthode pour ajouter un client
  void _addClient() async {
    final client = Client(
      nom: _nomController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    await DatabaseHelper.instance.insertClient(client);
    Navigator.pop(context, true); // Passez true pour indiquer que des données ont été ajoutées
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Full name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addClient, // Appel de la méthode pour ajouter un client
              child: Text('Add Client'),
            ),
          ],
        ),
      ),
    );
  }
}
