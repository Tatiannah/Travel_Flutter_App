import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/hotel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditHotelScreen extends StatefulWidget {
  final Hotel hotel;

  EditHotelScreen({required this.hotel});

  @override
  _EditHotelScreenState createState() => _EditHotelScreenState();
}

class _EditHotelScreenState extends State<EditHotelScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _nbrChambreDispoController;
  late TextEditingController _lieuController;
  late TextEditingController _prixController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.hotel.nom);
    _descriptionController = TextEditingController(text: widget.hotel.description);
    _phoneController = TextEditingController(text: widget.hotel.phone);
    _nbrChambreDispoController = TextEditingController(text: widget.hotel.nbrChambreDispo.toString());
    _lieuController = TextEditingController(text: widget.hotel.lieu);
    _prixController = TextEditingController(text: widget.hotel.prix.toString());
    _image = (widget.hotel.image != null && widget.hotel.image!.isNotEmpty)
        ? File(widget.hotel.image!)
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

  void _updateHotel() async {
    if (_formKey.currentState!.validate()) {
      final updatedHotel = Hotel(
        id: widget.hotel.id,
        nom: _nomController.text,
        description: _descriptionController.text,
        phone: _phoneController.text,
        nbrChambreDispo: int.parse(_nbrChambreDispoController.text),
        image: _image != null ? _image!.path : widget.hotel.image,
        lieu: _lieuController.text,
        prix: double.parse(_prixController.text),
      );
      await DatabaseHelper.instance.updateHotel(updatedHotel);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier Hôtel')),
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
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le numéro de téléphone';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nbrChambreDispoController,
                  decoration: InputDecoration(labelText: 'Nombre de Chambres Disponibles'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nombre de chambres disponibles';
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
                  onPressed: _updateHotel,
                  child: Text('Modifier Hôtel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
