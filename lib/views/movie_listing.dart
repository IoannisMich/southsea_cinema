import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({super.key, required this.movie});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _ticketQuantity = 1;
  String _feedback = '';
  void _addToBasket() {
    if (_ticketQuantity > 0) {
      final TicketItem item = TicketItem(
        movie: widget.movie,
        quantity: _ticketQuantity,
      );
      BasketRepository.instance.addItem(item);
      setState(() {
        _feedback =
            'Added $_ticketQuantity ticket(s) for ${widget.movie.title} to basket';
      });
    } else {
      setState(() {
        _feedback = 'Please select at least 1 ticket';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${movie.title} (${movie.ageRating})',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.asset(
              movie.posterImagePath,
              width: 150,
              height: 225,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(movie.description),
            const SizedBox(height: 20),
            const Text('Southsea Cinema Room'),
            const SizedBox(height: 10),
            Text(movie.showtimes.join(', ')),
            const SizedBox(height: 30),
            const Text(
              'Please note that Discounts / Membership Benefits will be applied once you have selected your tickets',
            ),
            const SizedBox(height: 20),
            const Text('Select Quantities (Up to 5 in total)'),
            const SizedBox(height: 30),
            const Text(
              'Tickets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownMenu<int>(
                  initialSelection: 1,
                  onSelected: (int? value) {
                    if (value != null) {
                      setState(() {
                        _ticketQuantity = value;
                      });
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 1, label: '1'),
                    DropdownMenuEntry(value: 2, label: '2'),
                    DropdownMenuEntry(value: 3, label: '3'),
                    DropdownMenuEntry(value: 4, label: '4'),
                    DropdownMenuEntry(value: 5, label: '5'),
                  ],
                ),
                const SizedBox(width: 15),
                Text('Adult (${movie.formattedPrice})'),
              ],
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label: 'ADD TO ORDER',
              onPressed: _addToBasket,
            ),
            const SizedBox(height: 20),
            Text(_feedback),
          ],
        ),
      ),
    );
  }
}
