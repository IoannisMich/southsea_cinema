import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  group('Home page', () {
    testWidgets('displays the app title', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text(appTitle), findsOneWidget);
    });

    testWidgets('displays the movie titles', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text('THE HANGOVER'), findsOneWidget);
      expect(find.text('FIGHT CLUB'), findsOneWidget);
    });

    testWidgets('displays a booking button for each movie',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, 'BOOK NOW', skipOffstage: false),
        findsNWidgets(2),
      );
    });
  });
}
