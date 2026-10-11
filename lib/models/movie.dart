class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String description;
  final String posterImagePath;
  final List<String> showtimes;
  final double price;

  Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.description,
    required this.posterImagePath,
    required this.showtimes,
    required this.price,
  });

  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  bool get isAdultOnly => ageRating == '18';
}
