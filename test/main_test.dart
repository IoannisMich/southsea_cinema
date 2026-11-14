import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

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

    testWidgets('displays a booking button for each movie', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, 'BOOK NOW', skipOffstage: false),
        findsNWidgets(2),
      );
    });
  });

  group('Theme mode', () {
    testWidgets('uses dark mode by default', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(app.themeMode, ThemeMode.dark);
    });

    testWidgets('loads a saved light mode choice', (
      WidgetTester tester,
    ) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData(<String, Object>{
        prefDarkMode: false,
      });

      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(app.themeMode, ThemeMode.light);
    });

    testWidgets('the settings switch changes the theme straight away', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final NavigatorState navigator = tester.state<NavigatorState>(
        find.byType(Navigator),
      );
      navigator.pushNamed('/settings');
      await tester.pumpAndSettle();

      final Finder darkModeSwitch = find.byKey(const Key('darkModeSwitch'));
      await tester.ensureVisible(darkModeSwitch);
      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(app.themeMode, ThemeMode.light);
    });
  });

  test('Android is supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });

  test('Other platforms are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('The unsupported platform screen explains what to do', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android emulator'), findsOneWidget);
  });
}
