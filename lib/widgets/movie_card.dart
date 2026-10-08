import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(color: cinemaFontWhite, fontSize: 16);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + age rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  movie.title.toUpperCase(),
                  style: cinemaHeaderStyle.copyWith(
                    color: cinemaBrand,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${movie.ageRating})',
                style: const TextStyle(color: cinemaFontMuted, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Poster + synopsis
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                movie.posterImagePath,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(movie.description, style: bodyStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Screening times + booking button
          const Text('BOOK TICKETS', style: bodyStyle),
          const SizedBox(height: 8),
          for (final showtime in movie.showtimes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(showtime, style: bodyStyle),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cinemaBrand,
                      foregroundColor: cinemaFontWhite,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('BOOK NOW'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
