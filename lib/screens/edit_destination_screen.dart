import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/destination.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditDestinationScreen extends StatefulWidget {
  final Destination destination;

  EditDestinationScreen({required this.destination});

  @override
  _EditDestinationScreenState createState() => _EditDestinationScreenState();
}

class _EditDestinationScreenState extends State<EditDestinationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _typeTransportController;
  late TextEditingController _lieuController;
  late TextEditingController _prixController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.destination.nom);
    _descriptionController = TextEditingController(text: widget.destination.description);
    _typeTransportController = TextEditingController(text: widget.destination.type_transport.toString());
    _lieuController = TextEditingController(text: widget.destination.lieu);
    _prixController = TextEditingController(text: widget.destination.prix.toString());
    _image = (widget.destination.image != null && widget.destination.image!.isNotEmpty)
        ? File(widget.destination.image!)
        : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _updateDestination() async {
    if (_formKey.currentState!.validate()) {
      final updatedDestination = Destination(
        id: widget.destination.id,
        nom: _nomController.text,
        description: _descriptionController.text,
        type_transport: _typeTransportController.text,
        image: _image != null ? _image!.path : widget.destination.image,
        lieu: _lieuController.text,
        prix: double.parse(_prixController.text),
      );
      await DatabaseHelper.instance.updateDestination(updatedDestination);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modification ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Adresse'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'adresse';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _typeTransportController,
                  decoration: InputDecoration(labelText: 'Type de transport'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le type de transport';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lieuController,
                  decoration: InputDecoration(labelText: 'Lieu'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le lieu';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le prix';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Choisir une Image'),
                ),
                _image != null ? Image.file(_image!) : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateDestination,
                  child: Text('Modifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
