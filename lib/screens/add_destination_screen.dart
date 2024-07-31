import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/destination.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toastification/toastification.dart';

class AddDestinationScreen extends StatefulWidget {
  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeTransportController = TextEditingController();
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

  void _addDestination() async {
    final nom = _nomController.text;
    final description = _descriptionController.text;
    final type_transport = _typeTransportController.text;
    final lieu = _lieuController.text;
    final image = _image?.path ?? '';

    if (nom.isEmpty || description.isEmpty || lieu.isEmpty || _typeTransportController.text.isEmpty || _prixController.text.isEmpty) {
      _showErrorDialog('All fields must be completed ');
      return;
    }
    double? prix;
    try {

      prix = double.parse(_prixController.text);
    } catch (e) {
      _showErrorDialog('Please enter valid values for the price.');
      return;
    }


    final destination = Destination(
      nom: nom,
      description: description,

      type_transport: type_transport,
      image: image,
      lieu: lieu,
      prix: prix,
    );

    await DatabaseHelper.instance.insertDestination(destination);
    toastification.show(
        context: context, // optional if you use ToastificationWrapper
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        title: Text('Successful!'),
        // you can also use RichText widget for title and description parameters
        description: RichText(text: const TextSpan(text: 'Client added successfully ')),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300)
    );
    Navigator.pop(context, true);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
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
      appBar: AppBar(title: Text('Add Destination')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _typeTransportController,
                decoration: InputDecoration(labelText: 'Transport_type'),
              ),

              TextField(
                controller: _lieuController,
                decoration: InputDecoration(labelText: 'Place'),
              ),
              TextField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choose Image'),
              ),
              _image != null ? Image.file(_image!) : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDestination,
                child: Text('Add Destination'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
