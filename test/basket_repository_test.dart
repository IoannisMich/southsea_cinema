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
    test('starts empty with zero totals', () {
      final BasketRepository basket = BasketRepository.instance;
      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalTickets(), 0);
      expect(basket.getTotal(), 0.0);
    });

    test('adds tickets and calculates totals', () {
      final BasketRepository basket = BasketRepository.instance;
      basket.addItem(TicketItem(movie: testMovie1, quantity: 2));
      basket.addItem(TicketItem(movie: testMovie2, quantity: 1));

      expect(basket.getItems().length, 2);
      expect(basket.getTotalTickets(), 3);
      expect(basket.getTotal(), 26.0);
    });

    test('removes a ticket item', () {
      final BasketRepository basket = BasketRepository.instance;
      basket.addItem(TicketItem(movie: testMovie1, quantity: 1));
      expect(basket.getItems().length, 1);

      basket.removeItem(0);
      expect(basket.getItems(), isEmpty);
      expect(basket.getTotal(), 0.0);
    });

    test('ignores removing an invalid index', () {
      final BasketRepository basket = BasketRepository.instance;
      basket.addItem(TicketItem(movie: testMovie1, quantity: 1));

      basket.removeItem(5);
      expect(basket.getItems().length, 1);
    });

    test('clear empties the basket', () {
      final BasketRepository basket = BasketRepository.instance;
      basket.addItem(TicketItem(movie: testMovie1, quantity: 2));
      basket.addItem(TicketItem(movie: testMovie2, quantity: 3));

      basket.clear();
      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalTickets(), 0);
    });
  });
}
