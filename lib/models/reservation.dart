class Reservation {
  int id;
  String nom;
  String phone;
  String nomHotel;
  String lieuHotel;
  String nomDestination;
  String lieuDestination;
  int nbrChambre;
  int nbrPers;
  String typeTransport;
  String dateArrivee;
  String dateDepart;
  String statut;

  Reservation({
    required this.id,
    required this.nom,
    required this.phone,
    required this.nomHotel,
    required this.lieuHotel,
    required this.nomDestination,
    required this.lieuDestination,
    required this.nbrChambre,
    required this.nbrPers,
    required this.typeTransport,
    required this.dateArrivee,
    required this.dateDepart,
    required this.statut,
  });

  factory Reservation.fromMap(Map<String, dynamic> json) => new Reservation(
    id: json['id'],
    nom: json['nom'],
    phone: json['phone'],
    nomHotel: json['nomHotel'],
    lieuHotel: json['lieuHotel'],
    nomDestination: json['nomDestination'],
    lieuDestination: json['lieuDestination'],
    nbrChambre: json['nbrChambre'],
    nbrPers: json['nbrPers'],
    typeTransport: json['typeTransport'],
    dateArrivee: json['dateArrivee'],
    dateDepart: json['dateDepart'],
    statut: json['statut'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'phone': phone,
    'nomHotel': nomHotel,
    'lieuHotel': lieuHotel,
    'nomDestination': nomDestination,
    'lieuDestination': lieuDestination,
    'nbrChambre': nbrChambre,
    'nbrPers': nbrPers,
    'typeTransport': typeTransport,
    'dateArrivee': dateArrivee,
    'dateDepart': dateDepart,
    'statut': statut,
  };
}
