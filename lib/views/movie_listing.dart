import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
          children:[
            const Text("The Hangover (2009)",
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
            const Text("Please note that Discounts / Membership Benefits will be applied once you have selected your tickets"),

            const SizedBox(height: 20),
            const Text("Select Quantiities (Up to 5 in total)"),

            const SizedBox(height: 40),
            const Text("Tickets",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              ),
            ),

            

          
          ]
        ),
      )
    );
  }
  
}
