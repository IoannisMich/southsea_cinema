import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsView displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byKey(const Key('newsletterSwitch')), findsOneWidget);
    expect(find.byKey(const Key('darkModeSwitch')), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    final Finder nameField = find.widgetWithText(TextField, 'Full name');
    final Finder addressField = find.widgetWithText(TextField, 'Address');
    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Gerald Vernon-Jackson');
    await tester.enterText(addressField, 'Guildhall, PO1 2AJ');
    await tester.enterText(
      emailField,
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );

    final Finder switchFinder = find.byKey(const Key('newsletterSwitch'));
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved for Gerald Vernon-Jackson'),
      findsOneWidget,
    );

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefName), 'Gerald Vernon-Jackson');
    expect(await prefs.getString(prefAddress), 'Guildhall, PO1 2AJ');
    expect(
      await prefs.getString(prefEmail),
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );
    expect(await prefs.getBool(prefNewsletter), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();
    expect(find.text('Gerald Vernon-Jackson'), findsOneWidget);
    expect(find.text('Guildhall, PO1 2AJ'), findsOneWidget);
    expect(
      find.text('gerald.vernon-jackson@portsmouthcc.gov.uk'),
      findsOneWidget,
    );
    final Switch reopenedSwitch = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(reopenedSwitch.value, isTrue);
  });

  testWidgets('SettingsView pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefName: 'Abdul Kadir',
      prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
      prefEmail: 'abdul.kadir@portsmouthcc.gov.uk',
      prefNewsletter: true,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    expect(find.text('Abdul Kadir'), findsOneWidget);
    expect(find.text('Portsmouth Guildhall, PO1 2AJ'), findsOneWidget);
    expect(find.text('abdul.kadir@portsmouthcc.gov.uk'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Dark mode switch defaults on and can be toggled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    final Finder darkModeSwitch = find.byKey(const Key('darkModeSwitch'));
    expect(tester.widget<SwitchListTile>(darkModeSwitch).value, isTrue);

    await tester.tap(darkModeSwitch);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(darkModeSwitch).value, isFalse);
  });

  testWidgets('Saving settings stores the dark mode choice', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('darkModeSwitch')));
    await tester.pump();
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getBool(prefDarkMode), isFalse);
  });

  testWidgets('A saved light mode choice is loaded on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefDarkMode: false,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    final SwitchListTile darkModeSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('darkModeSwitch')),
    );
    expect(darkModeSwitch.value, isFalse);
  });

  testWidgets('Dark mode previews changes without saving them', (
    WidgetTester tester,
  ) async {
    final List<bool> changes = [];
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsView(darkMode: true, onDarkModeChanged: changes.add),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('darkModeSwitch')));
    await tester.pump();

    expect(changes, <bool>[false]);
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getBool(prefDarkMode), isNull);
  });
}
