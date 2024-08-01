import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projet1/models/client.dart';
import 'package:projet1/models/hotel.dart';
import 'package:projet1/models/destination.dart';
import 'package:projet1/models/reservation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'travel_booking.db');

    return await openDatabase(
      path,
      version: 6, // Augmenter la version de la base de données
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE client (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        email TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE hotel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        description TEXT,
        phone TEXT,
        nbr_chambre_dispo INTEGER,
        image TEXT,
        lieu TEXT,
        prix REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE destination (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        description TEXT,
        nbr_pers_dispo INTEGER,
        type_transport TEXT,
        image TEXT,
        lieu TEXT,
        prix REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE reservation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        phone TEXT NOT NULL,
        nomHotel TEXT,
        lieuHotel TEXT,
        nomDestination TEXT,
        lieuDestination TEXT,
        nbr_chambre INTEGER DEFAULT 0 CHECK(nbr_chambre >= 0),
        nbr_pers INTEGER DEFAULT 0 CHECK(nbr_pers >= 0),
        type_transport TEXT CHECK(type_transport IN ('avion', 'train', 'voiture')),
        dateArrivee DATE NOT NULL,
        dateDepart DATE NOT NULL,
        isConfirmed INTEGER DEFAULT 0, -- Nouvelle colonne ajoutée
        FOREIGN KEY (nomHotel, lieuHotel) REFERENCES hotel(nom, lieu),
        FOREIGN KEY (nomDestination, lieuDestination) REFERENCES destination(nom, lieu)
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _addColumnIfNotExists(db, 'reservation', 'nomDestination', 'TEXT');
      await _addColumnIfNotExists(db, 'reservation', 'lieuDestination', 'TEXT');
      await _addColumnIfNotExists(db, 'reservation', 'type_transport', 'TEXT');
    }

    if (oldVersion < 4) {
      // Ajouter la colonne isConfirmed si elle n'existe pas encore
      await _addColumnIfNotExists(
          db, 'reservation', 'isConfirmed', 'INTEGER DEFAULT 0');
    }

    if (oldVersion < 5) {
      // Ajouter la colonne isConfirmed si elle n'existe pas encore
      await _addColumnIfNotExists(
          db, 'destination', 'nbr_pers_dispo', 'INTEGER');
    }
    // Vous pouvez gérer d'autres versions si nécessaire
  }

  Future<void> _addColumnIfNotExists(Database db, String tableName,
      String columnName, String columnType) async {
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    final columnExists = result.any((column) => column['name'] == columnName);

    if (!columnExists) {
      await db.execute(
          'ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
    }
  }

  // CRUD pour les Clients
  Future<int> insertClient(Client client) async {
    final db = await database;
    return await db.insert('client', client.toMap());
  }

  Future<List<Client>> queryAllClients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('client');
    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      'client',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return await db.delete(
      'client',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD pour les Hôtels
  Future<int> insertHotel(Hotel hotel) async {
    final db = await database;
    return await db.insert('hotel', hotel.toMap());
  }

  Future<List<Hotel>> queryAllHotels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hotel');
    return List.generate(maps.length, (i) {
      return Hotel.fromMap(maps[i]);
    });
  }

  Future<int> updateHotel(Hotel hotel) async {
    final db = await database;
    return await db.update(
      'hotel',
      hotel.toMap(),
      where: 'id = ?',
      whereArgs: [hotel.id],
    );
  }

  Future<int> deleteHotel(int id) async {
    final db = await database;
    return await db.delete(
      'hotel',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD pour les destinations
  Future<int> insertDestination(Destination destination) async {
    final db = await database;
    return await db.insert('destination', destination.toMap());
  }

  Future<List<Destination>> queryAllDestinations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('destination');
    return List.generate(maps.length, (i) {
      return Destination.fromMap(maps[i]);
    });
  }

  Future<int> updateDestination(Destination destination) async {
    final db = await database;
    return await db.update(
      'destination',
      destination.toMap(),
      where: 'id = ?',
      whereArgs: [destination.id],
    );
  }

  Future<int> deleteDestination(int id) async {
    final db = await database;
    return await db.delete(
      'destination',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertReservation(Reservation reservation) async {
    final db = await instance.database;

    await db.insert(
      'reservation',
      reservation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> queryHotelLieux() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT lieu FROM hotel');
    return result.map((map) => map['lieu'] as String).toList();
  }

  Future<List<String>> queryDestinationLieux() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT lieu FROM destination');
    return result.map((map) => map['lieu'] as String).toList();
  }

  Future<List<String>> queryHotelNoms(String lieu) async {
    final db = await instance.database;
    final result = await db.query(
      'hotel',
      columns: ['nom'],
      where: 'lieu = ?',
      whereArgs: [lieu],
    );

    return result.map((row) => row['nom'] as String).toList();
  }

  Future<List<String>> queryDestinationNoms(String lieu) async {
    final db = await instance.database;
    final result = await db.query(
      'destination',
      columns: ['nom'],
      where: 'lieu = ?',
      whereArgs: [lieu],
    );

    return result.map((row) => row['nom'] as String).toList();
  }

  Future<List<Reservation>> queryAllReservations() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('reservation');

    return List.generate(maps.length, (i) {
      return Reservation.fromMap(maps[i]);
    });
  }

  Future<int> updateReservation(Reservation reservation) async {
    Database db = await instance.database;
    return await db.update(
      'reservation',
      reservation.toMap(),
      where: 'id = ?',
      whereArgs: [reservation.id],
    );
  }

  Future<void> deleteReservation(int id) async {
    final db = await instance.database;

    await db.delete(
      'reservation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  FutureOr<Map<String, int>> getReservationsCountByPlace() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT lieuDestination, COUNT(nom) as count
    FROM reservation
    GROUP BY lieuDestination
  ''');

    return {
      for (var row in result)
        if (row['lieuDestination'] != null) row['lieuDestination'] as String: row['count'] as int
    };
  }


  FutureOr<Map<String, int>> getReservationsCountByHotel() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT lieuHotel, COUNT(nom) as count
      FROM reservation
      GROUP BY lieuHotel
    ''');

    return {
      for (var row in result)
        if (row['lieuHotel'] != null) row['lieuHotel'] as String: row['count'] as int
    };
  }

  Future<String?> getEmail(String name, String phone) async {
    final db = await instance.database;

    final result = await db.query(
      'client',
      columns: ['email'],
      where: 'nom = ? AND phone = ?',
      whereArgs: [name, phone],
    );

    if (result.isNotEmpty) {
      return result.first['email'] as String?;
    } else {
      return null;
    }
  }

  Future<double?> getHotelPrice(String nameHotel) async {
    final db = await instance.database;

    final result = await db.query(
      'hotel',
      columns: ['prix'],
      where: 'nom = ? ',
      whereArgs: [nameHotel],
    );

    if (result.isNotEmpty) {
      return result.first['prix'] as double?;
    } else {
      return null;
    }
  }

  Future<double?> getDestinationPrice(String nameDestination) async {
    final db = await instance.database;

    final result = await db.query(
      'destination',
      columns: ['prix'],
      where: 'nom = ? ',
      whereArgs: [nameDestination]
    );

    if (result.isNotEmpty) {
      print(result);
      return result.first['prix'] as double?;
    } else {
      return null;
    }
  }

}
