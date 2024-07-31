import 'package:flutter/material.dart';
import 'package:projet1/services/database_helper.dart';
import 'package:projet1/models/hotel.dart';
import 'add_hotel_screen.dart';
import 'edit_hotel_screen.dart';
import 'hotel_detail_screen.dart'; // Importez l'écran des détails de l'hôtel
import 'dart:io';

class HotelList extends StatefulWidget {
  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  List<Hotel> _hotelList = [];

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  void _loadHotels() async {
    _hotelList = await DatabaseHelper.instance.queryAllHotels();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotels')),
      body: SingleChildScrollView(
      child: Column(
      children: [
      // Carrousel horizontal pour les premières cartes
      Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _hotelList.length > 6 ? 6 : _hotelList.length,
        itemBuilder: (context, index) {
          final hotel = _hotelList[index];
          return Container(
            width: 200,
            margin: EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailScreen(hotel: hotel),
                    ),
                  );
                  if (result == true) {
                    _loadHotels(); // Recharger la liste si un hôtel est modifié ou supprimé
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (hotel.image != null && hotel.image!.isNotEmpty)
                        ? ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                      child: Image.file(
                        File(hotel.image!),
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      height: 140,
                      color: Colors.grey[300],
                      child: Icon(Icons.hotel, size: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(hotel.nom,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('${hotel.prix} Ar/nuit',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    // Liste verticale pour les cartes restantes
    ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: _hotelList.length - 6 > 0 ? _hotelList.length - 6 : 0,
    itemBuilder: (context, index) {
    final hotel = _hotelList[index + 6];
    return ListTile(
    title: Text(hotel.nom),
    subtitle: Text('${hotel.prix} Ar/nuit'),
    leading: (hotel.image != null && hotel.image!.isNotEmpty)
    ? Image.file(File(hotel.image!), width: 50, height: 50, fit: BoxFit.cover)
        : Icon(Icons.hotel, size: 50),
    onTap: () async {
    final result = await Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HotelDetailScreen(hotel: hotel),
    ),
    );
    if (result == true) {
    _loadHotels(); // Recharger la liste si un hôtel est modifié ou supprimé
    }
    },
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    IconButton(
    icon: Icon(Icons.edit),
    onPressed: () async {
    final result = await Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => EditHotelScreen(hotel: hotel),
    ),
    );
    if (result == true) {
    _loadHotels(); // Recharger la liste si un hôtel est modifié
    }
    },
    ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          // Afficher une boîte de dialogue de confirmation avant de supprimer
          bool confirmDelete = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirmer la suppression'),
              content: Text('Voulez-vous vraiment supprimer cet hôtel?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Supprimer'),
                ),
              ],
            ),
          );

          if (confirmDelete) {
            // Supprimer l'hôtel de la base de données
            await DatabaseHelper.instance.deleteHotel(hotel.id!);
            // Recharger la liste des hôtels
            _loadHotels();
          }
        },
      ),
    ],
    ),
    );
    },
    ),
      ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHotelScreen()),
          ).then((_) => _loadHotels());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
