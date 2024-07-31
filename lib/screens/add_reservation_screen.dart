import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/reservation.dart';

class AddReservationScreen extends StatefulWidget {
  @override
  _AddReservationScreenState createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLieuHotelChecked = false;
  bool _isLieuDestinationChecked = false;
  String? _selectedLieuHotel;
  String? _selectedLieuDestination;
  String? _selectedTypeTransport;

  // Controllers
  late TextEditingController _nomController;
  late TextEditingController _phoneController;
  late TextEditingController _nbrChambreController;
  late TextEditingController _dateArriveeController;
  late TextEditingController _dateDepartController;

  List<String> _hotelLieux = [];
  List<String> _destinationLieux = [];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _phoneController = TextEditingController();
    _nbrChambreController = TextEditingController();
    _dateArriveeController = TextEditingController();
    _dateDepartController = TextEditingController();
    _loadLieux();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _phoneController.dispose();
    _nbrChambreController.dispose();
    _dateArriveeController.dispose();
    _dateDepartController.dispose();
    super.dispose();
  }

  Future<void> _loadLieux() async {
    final hotelLieux = await DatabaseHelper.instance.queryHotelLieux();
    final destinationLieux = await DatabaseHelper.instance.queryDestinationLieux();

    setState(() {
      _hotelLieux = hotelLieux;
      _destinationLieux = destinationLieux;
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _addReservation() async {
    if (_formKey.currentState!.validate()) {
      final reservation = Reservation(
        id: 0, // Auto incremented
        nom: _nomController.text,
        phone: _phoneController.text,
        nomHotel: _isLieuHotelChecked ? _selectedLieuHotel ?? '' : '',
        lieuHotel: _isLieuHotelChecked ? _selectedLieuHotel ?? '' : '',
        nomDestination: _isLieuDestinationChecked ? _selectedLieuDestination ?? '' : '',
        lieuDestination: _isLieuDestinationChecked ? _selectedLieuDestination ?? '' : '',
        nbrChambre: int.parse(_nbrChambreController.text),
        nbrPers: 0, // Assuming not required for this form
        typeTransport: _selectedTypeTransport ?? '',
        dateArrivee: _dateArriveeController.text,
        dateDepart: _dateDepartController.text,
        statut: 'en attente', // Default value or you can handle it differently
      );

      await DatabaseHelper.instance.insertReservation(reservation);

      Navigator.pop(context, 'refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Réservation'),
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
              CheckboxListTile(
                title: Text('Lieu Hôtel'),
                value: _isLieuHotelChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isLieuHotelChecked = value ?? false;
                    if (!_isLieuHotelChecked) {
                      _selectedLieuHotel = null;
                    }
                  });
                },
              ),
              if (_isLieuHotelChecked) ...[
                DropdownButtonFormField<String>(
                  value: _selectedLieuHotel,
                  hint: Text('Sélectionner le lieu de l\'hôtel'),
                  items: _hotelLieux.map((lieu) {
                    return DropdownMenuItem(
                      value: lieu,
                      child: Text(lieu),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLieuHotel = value;
                    });
                  },
                ),
              ],
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
              CheckboxListTile(
                title: Text('Lieu Destination'),
                value: _isLieuDestinationChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isLieuDestinationChecked = value ?? false;
                    if (!_isLieuDestinationChecked) {
                      _selectedLieuDestination = null;
                    }
                  });
                },
              ),
              if (_isLieuDestinationChecked) ...[
                DropdownButtonFormField<String>(
                  value: _selectedLieuDestination,
                  hint: Text('Sélectionner le lieu de la destination'),
                  items: _destinationLieux.map((lieu) {
                    return DropdownMenuItem(
                      value: lieu,
                      child: Text(lieu),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLieuDestination = value;
                    });
                  },
                ),
              ],
              DropdownButtonFormField<String>(
                value: _selectedTypeTransport,
                hint: Text('Type de Transport'),
                items: ['avion', 'train', 'voiture'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTypeTransport = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un type de transport';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateArriveeController,
                decoration: InputDecoration(labelText: 'Date d\'Arrivée'),
                readOnly: true,
                onTap: () => _selectDate(_dateArriveeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la date d\'arrivée';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateDepartController,
                decoration: InputDecoration(labelText: 'Date de Départ'),
                readOnly: true,
                onTap: () => _selectDate(_dateDepartController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la date de départ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addReservation,
                    child: Text('Ajouter'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Annuler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
