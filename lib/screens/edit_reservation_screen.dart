import 'package:flutter/material.dart';
import 'package:projet1/models/reservation.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:toastification/toastification.dart';

class EditReservationScreen extends StatefulWidget {
  final Reservation reservation;

  EditReservationScreen({required this.reservation});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomController;
  late TextEditingController _phoneController;
  late TextEditingController _nomHotelController;
  late TextEditingController _lieuHotelController;
  late TextEditingController _nomDestinationController;
  late TextEditingController _lieuDestinationController;
  late TextEditingController _nbrChambreController;
  late TextEditingController _nbrPersController;
  late TextEditingController _typeTransportController;
  late TextEditingController _dateArriveeController;
  late TextEditingController _dateDepartController;
  String? _selectedTypeTransport;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.reservation.nom);
    _phoneController = TextEditingController(text: widget.reservation.phone);
    _nomHotelController = TextEditingController(text: widget.reservation.nomHotel);
    _lieuHotelController = TextEditingController(text: widget.reservation.lieuHotel);
    _nomDestinationController = TextEditingController(text: widget.reservation.nomDestination);
    _lieuDestinationController = TextEditingController(text: widget.reservation.lieuDestination);
    _nbrChambreController = TextEditingController(text: widget.reservation.nbr_chambre.toString());
    _nbrPersController = TextEditingController(text: widget.reservation.nbr_pers.toString());
    _selectedTypeTransport = widget.reservation.type_transport;
    _dateArriveeController = TextEditingController(text: widget.reservation.dateArrivee);
    _dateDepartController = TextEditingController(text: widget.reservation.dateDepart);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _phoneController.dispose();
    _nomHotelController.dispose();
    _lieuHotelController.dispose();
    _nomDestinationController.dispose();
    _lieuDestinationController.dispose();
    _nbrChambreController.dispose();
    _nbrPersController.dispose();
    _typeTransportController.dispose();
    _dateArriveeController.dispose();
    _dateDepartController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.parse(controller.text)) {
      setState(() {
        controller.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _updateReservation() async {
    if (_formKey.currentState!.validate()) {
      Reservation updatedReservation = Reservation(
        id: widget.reservation.id,
        nom: _nomController.text,
        phone: _phoneController.text,
        nomHotel: _nomHotelController.text,
        lieuHotel: _lieuHotelController.text,
        nomDestination: _nomDestinationController.text,
        lieuDestination: _lieuDestinationController.text,
        nbr_chambre: int.parse(_nbrChambreController.text),
        nbr_pers: int.parse(_nbrPersController.text),
        type_transport: _selectedTypeTransport.toString(),
        dateArrivee: _dateArriveeController.text,
        dateDepart: _dateDepartController.text,
      );

      await DatabaseHelper.instance.updateReservation(updatedReservation);

      toastification.show(
          context: context, // optional if you use ToastificationWrapper
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 1),
          title: Text('Successful!'),
          // you can also use RichText widget for title and description parameters
          description: RichText(text: const TextSpan(text: 'Reservation Informations edited successfully ')),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          animationDuration: const Duration(milliseconds: 300)
      );
      Navigator.pop(context, 'refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la Réservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le numéro de téléphone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomHotelController,
                decoration: InputDecoration(labelText: 'Nom de l\'Hôtel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'hôtel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lieuHotelController,
                decoration: InputDecoration(labelText: 'Lieu de l\'Hôtel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le lieu de l\'hôtel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomDestinationController,
                decoration: InputDecoration(labelText: 'Nom de la Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de la destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lieuDestinationController,
                decoration: InputDecoration(labelText: 'Lieu de la Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le lieu de la destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbrChambreController,
                decoration: InputDecoration(labelText: 'Nombre de Chambres'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de chambres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbrPersController,
                decoration: InputDecoration(labelText: 'Nombre de Personnes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de personnes';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedTypeTransport,
                hint: Text('Transport_Type'),
                items: ['Plan', 'Train', 'Car'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedTypeTransport = value ;
                  });
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context, _dateArriveeController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateArriveeController,
                    decoration: InputDecoration(labelText: 'Date d\'Arrivée'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la date d\'arrivée';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, _dateDepartController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateDepartController,
                    decoration: InputDecoration(labelText: 'Date de Départ'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la date de départ';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateReservation,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
