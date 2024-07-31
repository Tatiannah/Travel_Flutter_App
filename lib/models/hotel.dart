class Hotel {
  final int? id;
  final String nom;
  final String description;
  final String phone;
  final int nbrChambreDispo;
  final String? image;
  final String lieu;
  final double prix;

  Hotel({
    this.id,
    required this.nom,
    required this.description,
    required this.phone,
    required this.nbrChambreDispo,
    this.image,
    required this.lieu,
    required this.prix,
  });

  // Convert a Hotel into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'phone': phone,
      'nbr_chambre_dispo': nbrChambreDispo,
      'image': image,
      'lieu': lieu,
      'prix': prix,
    };
  }

  // Extract a Hotel object from a Map.
  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '', // Valeur par défaut vide si null
      description: map['description'] as String? ?? '', // Valeur par défaut vide si null
      phone: map['phone'] as String? ?? '', // Valeur par défaut vide si null
      nbrChambreDispo: map['nbr_chambre_dispo'] as int? ?? 0, // Valeur par défaut si null
      image: map['image'] as String?,
      lieu: map['lieu'] as String? ?? '', // Valeur par défaut vide si null
      prix: map['prix'] as double? ?? 0.0, // Valeur par défaut si null
    );
  }

}
