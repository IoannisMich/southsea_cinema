import 'package:southsea_cinema/models/ticket_item.dart';

class BasketRepository {
  BasketRepository._internal();

  static final BasketRepository instance = BasketRepository._internal();

  final List<TicketItem> _items = [];

  List<TicketItem> getItems() {
    return List<TicketItem>.unmodifiable(_items);
  }

  void addItem(TicketItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int getTotalItems() {
    int total = 0;
    for (final TicketItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  int get totalItemCount {
    return getTotalItems();
  }

  double getSubtotal() {
    double sum = 0.0;
    for (final TicketItem item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double getTotalDue() {
    return getSubtotal();
  }

  void clear() {
    _items.clear();
  }
}