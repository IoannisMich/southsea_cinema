import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = MovieRepository();

  group('getMovies', () {
    test('returns at least two movies', () {
      expect(repository.getMovies().length, greaterThanOrEqualTo(2));
    });

    test('every movie has a non-empty id', () {
      for (final movie in repository.getMovies()) {
        expect(movie.id, isNotEmpty);
      }
    });

    test('every movie id is unique', () {
      final ids = repository.getMovies().map((movie) => movie.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every movie has a non-empty title', () {
      for (final movie in repository.getMovies()) {
        expect(movie.title, isNotEmpty);
      }
    });

    test('every movie has an age rating', () {
      for (final movie in repository.getMovies()) {
        expect(movie.ageRating, isNotEmpty);
      }
    });

    test('every movie has a ticket price greater than zero', () {
      for (final movie in repository.getMovies()) {
        expect(movie.price, greaterThan(0));
      }
    });
  });

  group('getMovieById', () {
    test('returns The Hangover for "the-hangover"', () {
      final movie = repository.getMovieById('the-hangover');
      expect(movie, isNotNull);
      expect(movie!.title, 'The Hangover');
    });

    test('returns Fight Club for "fight-club"', () {
      final movie = repository.getMovieById('fight-club');
      expect(movie, isNotNull);
      expect(movie!.title, 'Fight Club');
    });

    test('returns null for an id that does not exist', () {
      expect(repository.getMovieById('not-a-real-movie'), isNull);
    });
  });

  group('getMoviesByAgeRating', () {
    test('returns only movies rated 15', () {
      final movies = repository.getMoviesByAgeRating('15');
      expect(movies, isNotEmpty);
      for (final movie in movies) {
        expect(movie.ageRating, '15');
      }
    });

    test('returns only movies rated 18', () {
      final movies = repository.getMoviesByAgeRating('18');
      expect(movies, isNotEmpty);
      for (final movie in movies) {
        expect(movie.ageRating, '18');
      }
    });

    test('returns an empty list when no movie has that rating', () {
      expect(repository.getMoviesByAgeRating('U'), isEmpty);
    });
  });

  group('getMoviesUnderPrice', () {
    test('returns only movies cheaper than the max price', () {
      final movies = repository.getMoviesUnderPrice(7.00);
      expect(movies, isNotEmpty);
      for (final movie in movies) {
        expect(movie.price, lessThan(7.00));
      }
    });

    test('returns all movies when the max price is above every price', () {
      expect(
        repository.getMoviesUnderPrice(100.00).length,
        repository.getMovies().length,
      );
    });

    test('returns an empty list when the max price is below every price', () {
      expect(repository.getMoviesUnderPrice(1.00), isEmpty);
    });
    test('loadMoviesFromAsset reads the bundled JSON films', () async {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = await repository.loadMoviesFromAsset();

      expect(movies.length, 2);
      expect(movies[0].id, 'the-hangover');
      expect(movies[1].id, 'fight-club');
      expect(repository.getMovies(), movies);
    });
  });
}
