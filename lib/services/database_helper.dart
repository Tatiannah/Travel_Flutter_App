import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projet1/models/client.dart';
import 'package:projet1/models/hotel.dart';
import 'package:projet1/models/destination.dart';
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
      version: 2, // Incrémenter la version
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
        type_transport TEXT,
        image TEXT,
        lieu TEXT,
        prix REAL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE hotel ADD COLUMN description TEXT');
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
      'hotel',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
