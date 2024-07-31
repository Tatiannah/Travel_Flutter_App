class Client {
  final int? id;
  final String nom;
  final String email;
  final String phone;

  Client({
    this.id,
    required this.nom,
    required this.email,
    required this.phone,
  });

  // Convertir un Client en Map pour SQL
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'phone': phone,
    };
  }

  // Convertir un Map en Client
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
