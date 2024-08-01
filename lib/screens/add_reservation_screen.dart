import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/reservation.dart';
import 'package:toastification/toastification.dart';

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
  String? _selectedNomHotel;
  String? _selectedNomDestination;
  String? _selectedTypeTransport;


  // Controllers
  late TextEditingController _nomController;
  late TextEditingController _phoneController;
  late TextEditingController _nbrChambreController;
  late TextEditingController _nbrPersController;
  late TextEditingController _dateArriveeController;
  late TextEditingController _dateDepartController;

  List<String> _hotelLieux = [];
  List<String> _hotelNoms = [];
  List<String> _destinationLieux = [];
  List<String> _destinationNoms = [];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _phoneController = TextEditingController();
    _nbrChambreController = TextEditingController();
    _nbrPersController = TextEditingController();
    _dateArriveeController = TextEditingController();
    _dateDepartController = TextEditingController();
    _loadLieux();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _phoneController.dispose();
    _nbrChambreController.dispose();
    _nbrPersController.dispose();
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

  Future<void> _loadNomHotels(String lieuHotel) async {
    final noms = await DatabaseHelper.instance.queryHotelNoms(lieuHotel);
    setState(() {
      _hotelNoms = noms;
      _selectedNomHotel = null; // Reset selection
    });
  }

  Future<void> _loadNomDestinations(String lieuDestination) async {
    final noms = await DatabaseHelper.instance.queryDestinationNoms(lieuDestination);
    setState(() {
      _destinationNoms = noms;
      _selectedNomDestination = null; // Reset selection
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
      try {
        final reservation = Reservation(
          nom: _nomController.text,
          phone: _phoneController.text,
          nomHotel: _isLieuHotelChecked ? _selectedNomHotel ?? '' : null,
          lieuHotel: _isLieuHotelChecked ? _selectedLieuHotel ?? '' : null,
          nomDestination: _isLieuDestinationChecked ? _selectedNomDestination ?? '' : null,
          lieuDestination: _isLieuDestinationChecked ? _selectedLieuDestination ?? '' : null,
          nbr_chambre: int.tryParse(_nbrChambreController.text) ?? 0,
          nbr_pers: int.tryParse(_nbrPersController.text) ?? 0,
          type_transport: _isLieuDestinationChecked ? _selectedTypeTransport ?? '' : null,
          dateArrivee: _dateArriveeController.text,
          dateDepart: _dateDepartController.text,
        );

        print('Réservation à ajouter : ${reservation.toMap()}'); // Débogage

        await DatabaseHelper.instance.insertReservation(reservation);
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 1),
            title: Text('Successful!'),
            // you can also use RichText widget for title and description parameters
            description: RichText(text: const TextSpan(text: 'Reservation added successfully ')),
            alignment: Alignment.topRight,
            direction: TextDirection.ltr,
            animationDuration: const Duration(milliseconds: 300)
        );

        Navigator.pop(context, 'refresh');
      } catch (e) {
        print('Error : $e'); // Débogage
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ErrOR'),
            content: Text('An error is occured : $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Full name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Hotel Location'),
                value: _isLieuHotelChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isLieuHotelChecked = value ?? false;
                    if (_isLieuHotelChecked && _selectedLieuHotel != null) {
                      _loadNomHotels(_selectedLieuHotel!);
                    } else {
                      _selectedLieuHotel = null;
                      _selectedNomHotel = null;
                      _hotelNoms = [];
                    }
                  });
                },
              ),
              if (_isLieuHotelChecked) ...[
                DropdownButtonFormField<String>(
                  value: _selectedLieuHotel,
                  hint: Text('Choose Hotel Location'),
                  items: _hotelLieux.map((lieu) {
                    return DropdownMenuItem(
                      value: lieu,
                      child: Text(lieu),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLieuHotel = value;
                      _loadNomHotels(value!);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedNomHotel,
                  hint: Text('Choose the name of the hotel'),
                  items: _hotelNoms.map((nom) {
                    return DropdownMenuItem(
                      value: nom,
                      child: Text(nom),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedNomHotel = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _nbrChambreController,
                  decoration: InputDecoration(labelText: 'Numbers of rooms to reserve'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of rooms to reserve';
                    }
                    return null;
                  },
                ),
              ],
              CheckboxListTile(
                title: Text('Destination Location'),
                value: _isLieuDestinationChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isLieuDestinationChecked = value ?? false;
                    if (_isLieuDestinationChecked && _selectedLieuDestination != null) {
                      _loadNomDestinations(_selectedLieuDestination!);
                    } else {
                      _selectedLieuDestination = null;
                      _selectedNomDestination = null;
                      _destinationNoms = [];
                    }
                  });
                },
              ),
              if (_isLieuDestinationChecked) ...[
                DropdownButtonFormField<String>(
                  value: _selectedLieuDestination,
                  hint: Text('Choose Destination Location'),
                  items: _destinationLieux.map((lieu) {
                    return DropdownMenuItem(
                      value: lieu,
                      child: Text(lieu),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLieuDestination = value;
                      _loadNomDestinations(value!);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedNomDestination,
                  hint: Text('Choose the name of destination'),
                  items: _destinationNoms.map((nom) {
                    return DropdownMenuItem(
                      value: nom,
                      child: Text(nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNomDestination = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _nbrPersController,
                  decoration: InputDecoration(labelText: 'Numbers of people who will travel '),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter the number of people who will travel';
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
                      _selectedTypeTransport = value;
                    });
                  },
                ),
              ],
              TextFormField(
                controller: _dateArriveeController,
                decoration: InputDecoration(labelText: 'Arrival Date'),
                readOnly: true,
                onTap: () => _selectDate(_dateArriveeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the arrival date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateDepartController,
                decoration: InputDecoration(labelText: 'Departure Date'),
                readOnly: true,
                onTap: () => _selectDate(_dateDepartController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the departure Date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addReservation,
                    child: Text('Add'),
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

