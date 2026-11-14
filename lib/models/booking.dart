import 'package:southsea_cinema/models/booking_item.dart';

class Booking {
  final int? id;
  final int bookingNumber;
  final String summary;
  final double total;
  final String date;
  final List<BookingItem> items;

  const Booking({
    this.id,
    required this.bookingNumber,
    required this.summary,
    required this.total,
    required this.date,
    this.items = const [],
  });

  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{
      'booking_number': bookingNumber,
      'summary': summary,
      'total': total,
      'date': date,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Booking.fromMap(
    Map<String, Object?> map, {
    List<BookingItem> items = const [],
  }) {
    final int bookingNumber = map['booking_number'] as int;
    final String summary = map['summary'] as String;
    final num totalNumber = map['total'] as num;
    final double total = totalNumber.toDouble();
    final String date = map['date'] as String;

    return Booking(
      id: map['id'] as int?,
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: date,
      items: items,
    );
  }
}
