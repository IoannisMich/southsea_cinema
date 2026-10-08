class Movie {
  final String id;
  final String title;
  final int releaseYear;
  final String description;
  final String screen;
  final DateTime startTime;
  final DateTime endTime;
  final double adultTicketPrice;

  Movie({
    required this.id,
    required this.title,
    required this.releaseYear,
    required this.description,
    required this.screen,
    required this.startTime,
    required this.endTime,
    required this.adultTicketPrice,
    });
}