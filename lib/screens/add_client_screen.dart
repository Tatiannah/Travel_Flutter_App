import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/client.dart';
import 'package:toastification/toastification.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Méthode pour ajouter un client
  void _addClient() async {
    if (_formKey.currentState?.validate() ?? false) {
      final client = Client(
        nom: _nomController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );
      await DatabaseHelper.instance.insertClient(client);
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
  }

  // Validation des champs
  String? _validateNom(String? value) {
    if (value == null || value.isEmpty) {
      return 'the field name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'the field name is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'the field name is required';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid phone number (10 digits) ';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Full name'),
                validator: _validateNom,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone number'),
                validator: _validatePhone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addClient,
                child: Text('Add Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
