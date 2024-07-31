class Reservation {
  int? id;
  String nom;
  String phone;
  String? nomHotel; // Allow null
  String? lieuHotel; // Allow null
  String? nomDestination; // Allow null
  String? lieuDestination; // Allow null
  int nbr_chambre;
  int nbr_pers;
  String? type_transport; // Allow null
  String dateArrivee;
  String dateDepart;

  Reservation({
    this.id,
    required this.nom,
    required this.phone,
    this.nomHotel,
    this.lieuHotel,
    this.nomDestination,
    this.lieuDestination,
    required this.nbr_chambre,
    required this.nbr_pers,
    this.type_transport,
    required this.dateArrivee,
    required this.dateDepart,
  });

  factory Reservation.fromMap(Map<String, dynamic> json) => Reservation(
    id: json['id'],
    nom: json['nom'],
    phone: json['phone'],
    nomHotel: json['nomHotel'],
    lieuHotel: json['lieuHotel'],
    nomDestination: json['nomDestination'],
    lieuDestination: json['lieuDestination'],
    nbr_chambre: json['nbr_chambre'],
    nbr_pers: json['nbr_pers'],
    type_transport: json['type_transport'],
    dateArrivee: json['dateArrivee'],
    dateDepart: json['dateDepart'],
  );

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'phone': phone,
    'nomHotel': nomHotel,
    'lieuHotel': lieuHotel,
    'nomDestination': nomDestination,
    'lieuDestination': lieuDestination,
    'nbr_chambre': nbr_chambre,
    'nbr_pers': nbr_pers,
    'type_transport': type_transport,
    'dateArrivee': dateArrivee,
    'dateDepart': dateDepart,
  };
}
