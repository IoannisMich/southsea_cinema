import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
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

  List<Movie> getMoviesByAgeRating(String rating) {
    return getMovies().where((movie) => movie.ageRating == rating).toList();
  }

  List<Movie> getMoviesUnderPrice(double maxPrice) {
    return getMovies().where((movie) => movie.price < maxPrice).toList();
  }
}
