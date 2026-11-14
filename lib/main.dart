import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/settings_view.dart';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const SouthseaCinemaApp());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class SouthseaCinemaApp extends StatelessWidget {
  const SouthseaCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cinemaSurface,
          iconTheme: IconThemeData(color: cinemaBrand),
          titleTextStyle: cinemaHeaderStyle,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const HomeView();
        },
        '/basket': (BuildContext context) {
          return const BasketView();
        },
        '/settings': (BuildContext context) {
          return const SettingsView();
        },
      },
    );
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves bookings with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
