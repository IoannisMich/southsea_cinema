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
    test('fromJson and toJson convert all fields', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 'test-movie',
        'title': 'Test Movie',
        'ageRating': '15',
        'description': 'A test movie.',
        'posterImagePath': 'assets/images/fightclub.jpg',
        'showtimes': ['18:00', '20:30'],
        'price': 9.50,
      };

      final Movie movie = Movie.fromJson(json);

      expect(movie.id, 'test-movie');
      expect(movie.title, 'Test Movie');
      expect(movie.ageRating, '15');
      expect(movie.description, 'A test movie.');
      expect(movie.posterImagePath, 'assets/images/fightclub.jpg');
      expect(movie.showtimes, ['18:00', '20:30']);
      expect(movie.price, 9.50);
      expect(movie.toJson(), json);
    });

    test('fromJson converts a whole-number price to a double', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 'whole-price',
        'title': 'Whole Price Movie',
        'ageRating': 'PG',
        'description': 'A movie with a whole-number price.',
        'posterImagePath': 'assets/images/thehangover.jpg',
        'showtimes': ['19:00'],
        'price': 8,
      };

      final Movie movie = Movie.fromJson(json);

      expect(movie.price, isA<double>());
      expect(movie.price, 8.0);
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
