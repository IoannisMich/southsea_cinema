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
            const Text("A comedy about a bachelor party in Las Vegas."),
          ]
        ),
      )
    );
  }
  
}
