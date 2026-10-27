import 'package:southsea_cinema/models/movie.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MovieRepository {
  List<Movie>? _cachedMovies;
  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return cachedMovies;
    }
    return [
      Movie(
        id: 'the-hangover',
        title: 'The Hangover',
        ageRating: '15',
        description:
            'Three friends wake up in Las Vegas after a wild bachelor party '
            'with no memory of the night before, and the groom is missing.',
        posterImagePath: 'assets/images/thehangover.jpg',
        showtimes: ['Thursday 22 Oct 2026 18:00'],
        price: 7.50,
      ),
      Movie(
        id: 'fight-club',
        title: 'Fight Club',
        ageRating: '18',
        description:
            'A frustrated office worker with insomnia meets a reckless soap '
            'salesman, and together they start an underground fighting club '
            'that spirals out of control.',
        posterImagePath: 'assets/images/fightclub.jpg',
        showtimes: ['Saturday 24 Oct 2026 20:00'],
        price: 6.00,
      ),
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Movie> loadedMovies = [];

    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(itemMap);
      loadedMovies.add(movie);
    }

    _cachedMovies = loadedMovies;
    return loadedMovies;
  }

  List<Movie> getMoviesByAgeRating(String rating) {
    return getMovies().where((movie) => movie.ageRating == rating).toList();
  }

  List<Movie> getMoviesUnderPrice(double maxPrice) {
    return getMovies().where((movie) => movie.price < maxPrice).toList();
  }
}
