import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';
void main() {
  group('UserSettings', () {
    test('default values are empty and newsletter is off', () {
      const UserSettings settings = UserSettings();

      expect(settings.name, isEmpty);
      expect(settings.address, isEmpty);
      expect(settings.email, isEmpty);
      expect(settings.receiveNewsletter, isFalse);
    });

    test('stores the values passed to the constructor', () {
      const UserSettings settings = UserSettings(
        name: 'Alex Smith',
        address: '10 Elm Road, Portsmouth',
        email: 'alex@example.com',
        receiveNewsletter: true,
      );

      expect(settings.name, 'Alex Smith');
      expect(settings.address, '10 Elm Road, Portsmouth');
      expect(settings.email, 'alex@example.com');
      expect(settings.receiveNewsletter, isTrue);
    });
  });
}