import 'package:flutter/material.dart';

import '../models/place.dart';
import 'map.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  String get locationImage {
    final lat = place.locationDetails.latitude;
    final lng = place.locationDetails.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDKGjqFSpEAv-eZuYF4UMPOxWrXtgs-E9g';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          location: place.locationDetails,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  child: Text(
                    place.locationDetails.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
