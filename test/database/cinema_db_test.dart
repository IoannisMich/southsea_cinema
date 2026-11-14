import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: CinemaDatabase.instance.configureDatabase,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  Booking buildBooking(int bookingNumber, String summary, double total) {
    return Booking(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  const BookingItem item = BookingItem(
    movieId: 'the-hangover',
    movieTitle: 'The Hangover',
    unitPrice: 7.50,
    quantity: 2,
  );

  test('the app creates version 2 with both tables and foreign keys', () async {
    await CinemaDatabase.instance.close();
    final Database db = await CinemaDatabase.instance.open(
      inMemoryDatabasePath,
    );
    try {
      expect(await db.getVersion(), 2);
      final List<Map<String, Object?>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      );
      final List<String> names = [];
      for (final Map<String, Object?> table in tables) {
        names.add(table['name'] as String);
      }
      expect(names, containsAll(['bookings', 'booking_items']));
      expect(await db.query('bookings'), hasLength(3));
      expect(await db.query('booking_items'), isEmpty);
      final List<Map<String, Object?>> foreignKeys = await db.rawQuery(
        'PRAGMA foreign_keys',
      );
      expect(foreignKeys[0]['foreign_keys'], 1);
      final List<Map<String, Object?>> links = await db.rawQuery(
        'PRAGMA foreign_key_list(booking_items)',
      );
      expect(links[0]['table'], 'bookings');
      expect(links[0]['from'], 'booking_id');
      expect(links[0]['to'], 'id');
    } finally {
      await db.close();
    }
  });

  test('reopening a version 1 file keeps bookings and adds linked items',
      () async {
    final Directory folder = await Directory.systemTemp.createTemp(
      'cinema_migration_',
    );
    final String filePath = join(folder.path, 'bookings.db');
    final Map<String, Object?> oldBooking = <String, Object?>{
      'id': 42,
      'booking_number': 1042,
      'summary': '2 x Old Film',
      'total': 15.00,
      'date': '01/01/2026 10:00',
    };
    final Map<String, Object?> otherBooking = <String, Object?>{
      'id': 43,
      'booking_number': 1043,
      'summary': '1 x Other Film',
      'total': 6.00,
      'date': '02/01/2026 10:00',
    };
    try {
      final Database oldDatabase =
          await databaseFactoryFfiNoIsolate.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute('''
                  CREATE TABLE bookings (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    booking_number INTEGER NOT NULL,
                    summary TEXT NOT NULL,
                    total REAL NOT NULL,
                    date TEXT NOT NULL
                  )
                ''');
          },
        ),
      );
      try {
        await oldDatabase.insert('bookings', oldBooking);
        await oldDatabase.insert('bookings', otherBooking);
      } finally {
        await oldDatabase.close();
      }

      await CinemaDatabase.instance.close();
      final Database upgraded = await CinemaDatabase.instance.open(filePath);
      CinemaDatabase.instance.setDatabase(upgraded);
      expect(await upgraded.getVersion(), 2);
      expect(await upgraded.query('bookings', orderBy: 'id'), [
        oldBooking,
        otherBooking,
      ]);
      expect(await upgraded.query('booking_items'), isEmpty);

      final List<Booking> oldBookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(oldBookings[1].summary, '2 x Old Film');
      expect(oldBookings[1].items, isEmpty);
      expect(await CinemaDatabase.instance.getNextBookingNumber(), 1044);

      final int id = await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1044,
          summary: '2 x The Hangover',
          total: 15.00,
          date: '03/01/2026 10:00',
          items: [item],
        ),
      );
      expect((await upgraded.query('booking_items'))[0]['booking_id'], id);
      await CinemaDatabase.instance.close();

      final Database reopened = await CinemaDatabase.instance.open(filePath);
      CinemaDatabase.instance.setDatabase(reopened);
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings, hasLength(3));
      expect(bookings[0].items[0].movieTitle, 'The Hangover');
      expect(bookings[2].toMap(), oldBooking);
    } finally {
      await CinemaDatabase.instance.close();
      await folder.delete(recursive: true);
    }
  });

  test('insertBooking stores a booking and returns its id', () async {
    final int id = await CinemaDatabase.instance.insertBooking(
      buildBooking(1001, '1 x The Hangover', 7.50),
    );
    expect(id, greaterThan(0));

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings.length, 1);
    expect(bookings[0].id, id);
    expect(bookings[0].summary, '1 x The Hangover');
    expect(bookings[0].total, 7.50);
  });

  test('getNextBookingNumber increments the current maximum', () async {
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1001);

    await CinemaDatabase.instance.insertBooking(
      buildBooking(1005, 'Booking', 5.0),
    );
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1006);
  });

  test('getAllBookings returns the highest booking number first', () async {
    await CinemaDatabase.instance.insertBooking(
      buildBooking(1001, 'First', 5.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildBooking(1003, 'Third', 9.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildBooking(1002, 'Second', 7.0),
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings[0].bookingNumber, 1003);
    expect(bookings[1].bookingNumber, 1002);
    expect(bookings[2].bookingNumber, 1001);
  });

  test('items are linked to their booking and keep purchase details', () async {
    await CinemaDatabase.instance.insertBooking(buildBooking(1001, 'Old', 9.0));
    final int id = await CinemaDatabase.instance.insertBooking(
      const Booking(
        bookingNumber: 1002,
        summary: '2 x The Hangover, 1 x Fight Club',
        total: 21.0,
        date: '01/01/2026 10:00',
        items: [
          item,
          BookingItem(
            movieId: 'fight-club',
            movieTitle: 'Fight Club',
            unitPrice: 6.00,
            quantity: 1,
          ),
        ],
      ),
    );

    final Database db = await CinemaDatabase.instance.database;
    final List<Map<String, Object?>> rows = await db.query(
      'booking_items',
      orderBy: 'id',
    );
    expect(rows, hasLength(2));
    expect(rows[0]['booking_id'], id);
    expect(rows[1]['booking_id'], id);

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings[0].items, hasLength(2));
    expect(bookings[0].items[0].movieTitle, 'The Hangover');
    expect(bookings[0].items[0].unitPrice, 7.50);
    expect(bookings[0].items[0].quantity, 2);
    expect(bookings[0].items[0].lineTotal, 15.0);
    expect(bookings[0].items[1].movieTitle, 'Fight Club');
    expect(bookings[1].items, isEmpty);
  });

  test('foreign keys reject items for a booking that does not exist', () async {
    final Database db = await CinemaDatabase.instance.database;
    await expectLater(
      db.insert('booking_items', item.toMap(999)),
      throwsA(isA<DatabaseException>()),
    );
    expect(await db.query('booking_items'), isEmpty);
  });

  test('a failed item rolls back the booking and earlier items', () async {
    await CinemaDatabase.instance.insertBooking(
      buildBooking(1001, 'Existing booking', 9.0),
    );

    await expectLater(
      CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1002,
          summary: 'Invalid booking',
          total: 15.00,
          date: '01/01/2026 10:00',
          items: [
            item,
            BookingItem(
              movieId: 'invalid',
              movieTitle: 'Invalid Film',
              unitPrice: 6.00,
              quantity: 0,
            ),
          ],
        ),
      ),
      throwsA(isA<DatabaseException>()),
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings, hasLength(1));
    expect(bookings[0].summary, 'Existing booking');
    final Database db = await CinemaDatabase.instance.database;
    expect(await db.query('booking_items'), isEmpty);
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1002);
  });
}
