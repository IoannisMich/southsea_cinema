import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

final Movie testMovie1 = Movie(
  id: 'test-movie-1',
  title: 'Test Movie One',
  ageRating: '15',
  description: 'A test movie.',
  posterImagePath: 'assets/images/fightclub.jpg',
  showtimes: ['18:00'],
  price: 10.0,
);

final Movie testMovie2 = Movie(
  id: 'test-movie-2',
  title: 'Test Movie Two',
  ageRating: 'PG',
  description: 'Another test movie.',
  posterImagePath: 'assets/images/thehangover.jpg',
  showtimes: ['20:00'],
  price: 6.0,
);

void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketRepository tests', () {
    test('starts with empty basket and zero totals', () {
      final BasketRepository basket = BasketRepository.instance;
      expect(basket.getItems().length, 0);
      expect(basket.getTotalItems(), 0);
      expect(basket.totalItemCount, 0);
      expect(basket.getSubtotal(), 0.0);
      expect(basket.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal and total correctly', () {
      final BasketRepository basket = BasketRepository.instance;
      final TicketItem item1 = TicketItem(movie: testMovie1, quantity: 2);
      final TicketItem item2 = TicketItem(movie: testMovie2, quantity: 1);

      basket.addItem(item1);
      basket.addItem(item2);

      expect(basket.getItems().length, 2);
      expect(basket.getTotalItems(), 3);
      expect(basket.totalItemCount, 3);
      expect(basket.getSubtotal(), 26.0);
      expect(basket.getTotalDue(), 26.0);
    });

    test('removes items correctly', () {
      final BasketRepository basket = BasketRepository.instance;
      final TicketItem item = TicketItem(movie: testMovie1, quantity: 1);
      basket.addItem(item);
      expect(basket.getItems().length, 1);

      basket.removeItem(0);
      expect(basket.getItems().length, 0);
      expect(basket.getTotalDue(), 0.0);
    });
  });
}
