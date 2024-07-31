import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/client.dart';

class EditClientScreen extends StatefulWidget {
  final Client client;

  EditClientScreen({required this.client});

  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.client.nom);
    _emailController = TextEditingController(text: widget.client.email);
    _phoneController = TextEditingController(text: widget.client.phone);
  }

  void _updateClient() async {
    final updatedClient = Client(
      id: widget.client.id, // Conserver l'ID du client pour la mise à jour
      nom: _nomController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    await DatabaseHelper.instance.updateClient(updatedClient);
    Navigator.pop(context, true); // Passez true pour indiquer que des données ont été modifiées
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom'),
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
              onPressed: _updateClient, // Appel de la méthode pour mettre à jour le client
              child: Text('Update Client'),
            ),
          ],
        ),
      ),
    );
  }
}
