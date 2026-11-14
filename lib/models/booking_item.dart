class BookingItem {
  final String movieId;
  final String movieTitle;
  final double unitPrice;
  final int quantity;

  const BookingItem({
    required this.movieId,
    required this.movieTitle,
    required this.unitPrice,
    required this.quantity,
  });

  double get lineTotal {
    return unitPrice * quantity;
  }

  Map<String, Object?> toMap(int bookingId) {
    return <String, Object?>{
      'booking_id': bookingId,
      'movie_id': movieId,
      'movie_title': movieTitle,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }

  factory BookingItem.fromMap(Map<String, Object?> map) {
    final num price = map['unit_price'] as num;
    return BookingItem(
      movieId: map['movie_id'] as String,
      movieTitle: map['movie_title'] as String,
      unitPrice: price.toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}
