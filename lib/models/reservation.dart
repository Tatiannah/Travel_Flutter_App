class Reservation {
  int id;
  String nom;
  String phone;
  String nomHotel;
  String lieuHotel;
  String nomDestination;
  String lieuDestination;
  int nbr_chambre;
  int nbr_pers;
  String typeTransport;
  String dateArrivee;
  String dateDepart;

  Reservation({
    required this.id,
    required this.nom,
    required this.phone,
    required this.nomHotel,
    required this.lieuHotel,
    required this.nomDestination,
    required this.lieuDestination,
    required this.nbr_chambre,
    required this.nbr_pers,
    required this.typeTransport,
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
    typeTransport: json['typeTransport'],
    dateArrivee: json['dateArrivee'],
    dateDepart: json['dateDepart'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'phone': phone,
    'nomHotel': nomHotel,
    'lieuHotel': lieuHotel,
    'nomDestination': nomDestination,
    'lieuDestination': lieuDestination,
    'nbr_chambre': nbr_chambre,
    'nbr_pers': nbr_pers,
    'typeTransport': typeTransport,
    'dateArrivee': dateArrivee,
    'dateDepart': dateDepart,
  };
}
