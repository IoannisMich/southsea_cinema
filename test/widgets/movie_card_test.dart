import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

final Movie testMovie = Movie(
  id: 'fight-club',
  title: 'Fight Club',
  ageRating: '18',
  description: 'An office worker starts an underground club.',
  posterImagePath: 'assets/images/fightclub.jpg',
  showtimes: ['Saturday 24 Oct 2026 20:00'],
  price: 6.00,
);

void main() {
  Widget buildCard() {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: MovieCard(movie: testMovie)),
      ),
    );
  }

  testWidgets('MovieCard shows the title, rating, price and showtime', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildCard());

    expect(find.text('FIGHT CLUB'), findsOneWidget);
    expect(find.text('(18)'), findsOneWidget);
    expect(
      find.text('An office worker starts an underground club.'),
      findsOneWidget,
    );
    expect(find.text('BOOK TICKETS - £6.00'), findsOneWidget);
    expect(find.text('Saturday 24 Oct 2026 20:00'), findsOneWidget);
  });

  testWidgets('BOOK NOW opens the film page', (WidgetTester tester) async {
    await tester.pumpWidget(buildCard());

    await tester.tap(find.text('BOOK NOW'));
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('Fight Club (18)'), findsOneWidget);
  });
}
