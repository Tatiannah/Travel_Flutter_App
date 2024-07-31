class Destination {
  final int? id;
  final String nom;
  final String description;
  final int nbr_pers_dispo;
  final String type_transport;
  final String? image;
  final String lieu;
  final double prix;

  Destination({
    this.id,
    required this.nom,
    required this.description,
    required this.nbr_pers_dispo,
    required this.type_transport,
    this.image,
    required this.lieu,
    required this.prix,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'nbr_pers_dispo': nbr_pers_dispo,
      'type_transport': type_transport,
      'image': image,
      'lieu': lieu,
      'prix': prix,
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
      description: map['description'] as String? ?? '',
      nbr_pers_dispo: map['nbr_pers_dispo'] as int? ?? 0,
      type_transport: map['type_transport'] as String? ?? '',
      image: map['image'] as String?,
      lieu: map['lieu'] as String? ?? '',
      prix: map['prix'] as double? ?? 0.0,
    );
  }
}
