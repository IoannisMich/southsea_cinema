import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

void main() {
  Widget buildApp() {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home page')),
            drawer: const NavDrawer(),
          );
        },
        '/basket': (BuildContext context) {
          return const Scaffold(body: Text('Basket page'));
        },
        '/settings': (BuildContext context) {
          return const Scaffold(body: Text('Settings page'));
        },
      },
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  testWidgets('NavDrawer lists the three pages', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await openDrawer(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My Basket'), findsOneWidget);
    expect(find.text('My Settings'), findsOneWidget);
  });

  testWidgets('Tapping My Basket opens the basket page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await openDrawer(tester);

    await tester.tap(find.text('My Basket'));
    await tester.pumpAndSettle();

    expect(find.text('Basket page'), findsOneWidget);
  });

  testWidgets('Tapping My Settings opens the settings page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await openDrawer(tester);

    await tester.tap(find.text('My Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings page'), findsOneWidget);
  });

  testWidgets('The close button closes the drawer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await openDrawer(tester);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsNothing);
    expect(find.text('Home page'), findsOneWidget);
  });
}
