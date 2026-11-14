import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

final Movie testMovie = Movie(
  id: 'the-hangover',
  title: 'The Hangover',
  ageRating: '15',
  description: 'Three friends wake up in Las Vegas.',
  posterImagePath: 'assets/images/thehangover.jpg',
  showtimes: ['Thursday 22 Oct 2026 18:00'],
  price: 7.50,
);

void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  testWidgets('MovieListing shows the film details and showtimes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MovieListing(movie: testMovie)));

    expect(find.text('The Hangover (15)'), findsOneWidget);
    expect(find.text('Three friends wake up in Las Vegas.'), findsOneWidget);
    expect(find.text('Thursday 22 Oct 2026 18:00'), findsOneWidget);
    expect(find.text('Adult (£7.50)'), findsOneWidget);
    expect(find.text('ADD TO ORDER'), findsOneWidget);
  });

  testWidgets('ADD TO ORDER adds one ticket by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MovieListing(movie: testMovie)));

    await tester.ensureVisible(find.text('ADD TO ORDER'));
    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pump();

    expect(
      find.text('Added 1 ticket(s) for The Hangover to basket'),
      findsOneWidget,
    );
    expect(BasketRepository.instance.getItems().length, 1);
    expect(BasketRepository.instance.getItems()[0].quantity, 1);
  });

  testWidgets('Choosing 3 tickets updates the subtotal and the basket', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MovieListing(movie: testMovie)));

    final Finder dropdown = find.byType(DropdownMenu<int>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('3').last);
    await tester.pumpAndSettle();

    expect(find.text('£22.50'), findsOneWidget);

    await tester.ensureVisible(find.text('ADD TO ORDER'));
    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pump();

    expect(
      find.text('Added 3 ticket(s) for The Hangover to basket'),
      findsOneWidget,
    );
    expect(BasketRepository.instance.getTotalItems(), 3);
    expect(BasketRepository.instance.getTotalDue(), 22.50);
  });
}
