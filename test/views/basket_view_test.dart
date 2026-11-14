import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final Movie testMovie = Movie(
  id: 'test-movie',
  title: 'Test Movie',
  ageRating: '15',
  description: 'A test movie.',
  posterImagePath: 'assets/images/fightclub.jpg',
  showtimes: ['18:00'],
  price: 10.0,
);

void main() {
  setUp(() async {
    BasketRepository.instance.clear();
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  testWidgets('BasketView displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets('BasketView renders items and removes item when delete pressed', (
    WidgetTester tester,
  ) async {
    final TicketItem item = TicketItem(movie: testMovie, quantity: 2);
    BasketRepository.instance.addItem(item);

    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('Your basket'), findsOneWidget);
    expect(find.text('2 x Test Movie'), findsOneWidget);
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
  });

  testWidgets('Checkout saves the booking and clears the basket', (
    WidgetTester tester,
  ) async {
    BasketRepository.instance.addItem(
      TicketItem(movie: testMovie, quantity: 2),
    );

    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();

    final List<Booking>? bookings = await tester.runAsync(() async {
      return await CinemaDatabase.instance.getAllBookings();
    });

    expect(bookings, isNotNull);
    if (bookings != null) {
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
      expect(bookings[0].summary, '2 x Test Movie');
      expect(bookings[0].total, 20.0);
    }
    expect(BasketRepository.instance.getItems(), isEmpty);
    expect(find.text('Booking 1001 saved'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
  });

  testWidgets('Checkout keeps the basket when saving fails', (
    WidgetTester tester,
  ) async {
    BasketRepository.instance.addItem(
      TicketItem(movie: testMovie, quantity: 2),
    );

    await tester.runAsync(() async {
      final Database database = await CinemaDatabase.instance.database;
      await database.execute('DROP TABLE bookings');
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();

    expect(BasketRepository.instance.getItems().length, 1);
    expect(find.text('2 x Test Movie'), findsOneWidget);
    expect(find.textContaining('Could not save your booking'), findsOneWidget);
  });

  testWidgets('BasketView lists past bookings newest first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1001,
          summary: '1 x Fight Club',
          total: 6.00,
          date: '01/01/2026 10:00',
        ),
      );
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1002,
          summary: '2 x The Hangover',
          total: 15.00,
          date: '02/01/2026 11:00',
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('Booking #1002'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
    expect(find.text('2 x The Hangover'), findsOneWidget);
    final double newestY = tester.getTopLeft(find.text('Booking #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Booking #1001')).dy;
    expect(newestY, lessThan(oldestY));
  });

  testWidgets('BasketView shows a message when there are no bookings', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('No bookings yet'), findsOneWidget);
  });
}
