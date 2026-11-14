import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking_item.dart';

void main() {
  const BookingItem item = BookingItem(
    movieId: 'the-hangover',
    movieTitle: 'The Hangover',
    unitPrice: 7.50,
    quantity: 2,
  );

  test('lineTotal multiplies the price by the quantity', () {
    expect(item.lineTotal, 15.0);
  });

  test('item maps include the booking link and purchase snapshot', () {
    expect(item.toMap(42), <String, Object?>{
      'booking_id': 42,
      'movie_id': 'the-hangover',
      'movie_title': 'The Hangover',
      'unit_price': 7.50,
      'quantity': 2,
    });
  });

  test('a database row converts back into an item', () {
    final BookingItem restored = BookingItem.fromMap(item.toMap(42));
    expect(restored.movieId, 'the-hangover');
    expect(restored.movieTitle, 'The Hangover');
    expect(restored.unitPrice, 7.50);
    expect(restored.quantity, 2);
  });

  test('whole-number SQLite prices become doubles', () {
    final Map<String, Object?> row = item.toMap(42);
    row['unit_price'] = 6;
    final BookingItem restored = BookingItem.fromMap(row);
    expect(restored.unitPrice, 6.0);
    expect(restored.unitPrice, isA<double>());
  });
}
