import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

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
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketView tests', () {
    testWidgets('shows empty message when basket has no tickets',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text('CHECKOUT'), findsNothing);
    });

    testWidgets('shows tickets and removes one when delete is tapped',
        (WidgetTester tester) async {
      BasketRepository.instance
          .addItem(TicketItem(movie: testMovie, quantity: 2));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Test Movie'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('CHECKOUT'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    });

    testWidgets('checkout clears basket and shows confirmation',
        (WidgetTester tester) async {
      BasketRepository.instance
          .addItem(TicketItem(movie: testMovie, quantity: 1));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      await tester.tap(find.text('CHECKOUT'));
      await tester.pump();

      expect(BasketRepository.instance.getItems(), isEmpty);
      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text('Thanks, your tickets are booked'), findsOneWidget);
    });
  });
}
