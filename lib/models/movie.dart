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
  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String title = json['title'] as String;
    final String ageRating = json['ageRating'] as String;
    final String description = json['description'] as String;
    final String posterImagePath = json['posterImagePath'] as String;
    final List<dynamic> showtimesJson = json['showtimes'] as List<dynamic>;
    final List<String> showtimes = [];
    for (final dynamic time in showtimesJson) {
      showtimes.add(time as String);
    }
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();

    return Movie(
      id: id,
      title: title,
      ageRating: ageRating,
      description: description,
      posterImagePath: posterImagePath,
      showtimes: showtimes,
      price: price,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'title': title,
      'ageRating': ageRating,
      'description': description,
      'posterImagePath': posterImagePath,
      'showtimes': showtimes,
      'price': price,
    };
    return data;
  }

  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  bool get isAdultOnly => ageRating == '18';
}
