import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/hotel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddHotelScreen extends StatefulWidget {
  @override
  _AddHotelScreenState createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nbrChambreDispoController = TextEditingController();
  final _lieuController = TextEditingController();
  final _prixController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _addHotel() async {
    final nom = _nomController.text;
    final description = _descriptionController.text;
    final phone = _phoneController.text;
    final lieu = _lieuController.text;
    final image = _image?.path ?? '';

    if (nom.isEmpty || description.isEmpty || phone.isEmpty || lieu.isEmpty || _nbrChambreDispoController.text.isEmpty || _prixController.text.isEmpty) {
      _showErrorDialog('Tous les champs doivent être remplis.');
      return;
    }

    int? nbrChambreDispo;
    double? prix;
    try {
      nbrChambreDispo = int.parse(_nbrChambreDispoController.text);
      prix = double.parse(_prixController.text);
    } catch (e) {
      _showErrorDialog('Veuillez entrer des valeurs valides pour le nombre de chambres et le prix.');
      return;
    }

    final hotel = Hotel(
      nom: nom,
      description: description,
      phone: phone,
      nbrChambreDispo: nbrChambreDispo,
      image: image,
      lieu: lieu,
      prix: prix,
    );

    await DatabaseHelper.instance.insertHotel(hotel);
    Navigator.pop(context, true);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _nbrChambreDispoController,
                decoration: InputDecoration(labelText: 'Nbr Chambre Dispo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _lieuController,
                decoration: InputDecoration(labelText: 'Lieu'),
              ),
              TextField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choisir une Image'),
              ),
              _image != null ? Image.file(_image!) : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addHotel,
                child: Text('Add Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
