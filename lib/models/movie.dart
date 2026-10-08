class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String description;
  final String posterImagePath;
  final List<String> showtimes;

  Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.description,
    required this.posterImagePath,
    required this.showtimes,
    });
}