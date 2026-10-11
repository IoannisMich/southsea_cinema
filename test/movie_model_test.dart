import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  Movie createMovie({String ageRating = '15', double price = 7.50}) {
    return Movie(
      id: 'test-movie',
      title: 'Test Movie',
      ageRating: ageRating,
      description: 'A test description.',
      posterImagePath: 'assets/images/test.jpg',
      showtimes: ['Monday 26 Oct 2026 18:00'],
      price: price,
    );
  }

  group('Movie constructor', () {
    test('assigns all properties correctly', () {
      final movie = Movie(
        id: 'the-hangover',
        title: 'The Hangover',
        ageRating: '15',
        description: 'Three friends wake up in Las Vegas.',
        posterImagePath: 'assets/images/thehangover.jpg',
        showtimes: ['Thursday 22 Oct 2026 18:00'],
        price: 7.50,
      );

      expect(movie.id, 'the-hangover');
      expect(movie.title, 'The Hangover');
      expect(movie.ageRating, '15');
      expect(movie.description, 'Three friends wake up in Las Vegas.');
      expect(movie.posterImagePath, 'assets/images/thehangover.jpg');
      expect(movie.showtimes, ['Thursday 22 Oct 2026 18:00']);
      expect(movie.price, 7.50);
    });
  });

  group('formattedPrice', () {
    test('formats a whole number with two decimal places', () {
      expect(createMovie(price: 6).formattedPrice, '£6.00');
    });

    test('adds a trailing zero to one decimal place', () {
      expect(createMovie(price: 7.5).formattedPrice, '£7.50');
    });

    test('keeps two decimal places unchanged', () {
      expect(createMovie(price: 12.99).formattedPrice, '£12.99');
    });

    test('rounds to two decimal places', () {
      expect(createMovie(price: 9.999).formattedPrice, '£10.00');
    });
  });

  group('isChildFriendly', () {
    test('returns true for U', () {
      expect(createMovie(ageRating: 'U').isChildFriendly, isTrue);
    });

    test('returns true for PG', () {
      expect(createMovie(ageRating: 'PG').isChildFriendly, isTrue);
    });

    test('returns false for 12A', () {
      expect(createMovie(ageRating: '12A').isChildFriendly, isFalse);
    });

    test('returns false for 15', () {
      expect(createMovie(ageRating: '15').isChildFriendly, isFalse);
    });

    test('returns false for 18', () {
      expect(createMovie(ageRating: '18').isChildFriendly, isFalse);
    });
  });

  group('isAdultOnly', () {
    test('returns true for 18', () {
      expect(createMovie(ageRating: '18').isAdultOnly, isTrue);
    });

    test('returns false for U', () {
      expect(createMovie(ageRating: 'U').isAdultOnly, isFalse);
    });

    test('returns false for PG', () {
      expect(createMovie(ageRating: 'PG').isAdultOnly, isFalse);
    });

    test('returns false for 12A', () {
      expect(createMovie(ageRating: '12A').isAdultOnly, isFalse);
    });

    test('returns false for 15', () {
      expect(createMovie(ageRating: '15').isAdultOnly, isFalse);
    });
  });
}
