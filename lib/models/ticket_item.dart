import 'package:southsea_cinema/models/movie.dart';

class TicketItem {
  final Movie movie;
  final int quantity;

  const TicketItem({
    required this.movie,
    required this.quantity,
  });

  double get lineTotal {
    return movie.price * quantity;
  }
}
