import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);
    return open(filePath);
  }

  Future<Database> open(String filePath) async {
    final Database db = await openDatabase(
      filePath,
      version: 2,
      onConfigure: configureDatabase,
      onCreate: _createDB,
      onUpgrade: upgradeDatabase,
    );
    return db;
  }

  Future<void> configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await _createBookingItemsTable(db);
  }

  Future<void> _createBookingItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS booking_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_id INTEGER NOT NULL REFERENCES bookings(id),
        movie_id TEXT NOT NULL,
        movie_title TEXT NOT NULL,
        unit_price REAL NOT NULL CHECK (unit_price >= 0),
        quantity INTEGER NOT NULL CHECK (quantity > 0)
      )
    ''');
  }

  Future<void> upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createBookingItemsTable(db);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1003,
      'summary': '2 x The Hangover',
      'total': 15.00,
      'date': '18/04/2026 12:45',
    });
    await db.insert('bookings', <String, Object?>{
      'booking_number': 1002,
      'summary': '1 x Fight Club',
      'total': 6.00,
      'date': '02/03/2026 18:10',
    });
    await db.insert('bookings', <String, Object?>{
      'booking_number': 1001,
      'summary': '3 x The Hangover',
      'total': 22.50,
      'date': '11/01/2026 13:02',
    });
  }

  Future<int> insertBooking(Booking booking) async {
    final Database db = await database;
    final int id = await db.transaction((Transaction transaction) async {
      final int bookingId = await transaction.insert(
        'bookings',
        booking.toMap(),
      );
      for (final BookingItem item in booking.items) {
        await transaction.insert('booking_items', item.toMap(bookingId));
      }
      return bookingId;
    });
    return id;
  }

  Future<List<Booking>> getAllBookings() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'bookings',
      orderBy: 'booking_number DESC',
    );

    final List<Booking> bookings = [];
    for (final Map<String, Object?> row in records) {
      final List<Map<String, Object?>> itemRecords = await db.query(
        'booking_items',
        where: 'booking_id = ?',
        whereArgs: [row['id']],
        orderBy: 'id',
      );
      final List<BookingItem> items = [];
      for (final Map<String, Object?> itemRow in itemRecords) {
        items.add(BookingItem.fromMap(itemRow));
      }
      bookings.add(Booking.fromMap(row, items: items));
    }
    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(booking_number) as max_num FROM bookings',
    );

    if (records.isEmpty) {
      return 1001;
    }
    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }

    final int currentMax = maxValue as int;
    return currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
