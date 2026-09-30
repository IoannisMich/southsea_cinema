import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _ticketquantiry = 1;
  String _feedback = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The Hangover (2009)",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Southsea Ciname Room"),
            const SizedBox(height: 20),
            const Text("Thursday 22 Oct 2026, 18:00 - ends at 19.14"),
            const SizedBox(height: 40),
            const Text(
                "Please note that Discounts / Membership Benefits will be applied once you have selected your tickets"),
            const SizedBox(height: 20),
            const Text("Select Quantiities (Up to 5 in total)"),
            const SizedBox(height: 40),
            const Text(
              "Tickets",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownMenu<int>(
                  initialSelection: 1,
                  onSelected: (int? value) {
                    if (value != null) {
                      setState(() {
                        _ticketquantiry = value;
                      });
                    }
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 1, label: '1'),
                    DropdownMenuEntry(value: 2, label: '2'),
                    DropdownMenuEntry(value: 3, label: '3'),
                    DropdownMenuEntry(value: 4, label: '4'),
                    DropdownMenuEntry(value: 5, label: '5'),
                  ],
                ),
                const SizedBox(width: 15),
                const Text(
                  "Adult (£7.50)",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _feedback = '$_ticketquantiry ticket(s) added to basket';
                });
              },
              child: const Text("ADD TO ORDER"),
            ),
            const SizedBox(height: 20),
            Text(_feedback)
          ],
        ),
      ),
    );
  }
}
