import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/places_provider.dart';
import 'package:meals_app/screens/add_place.dart';
import 'package:meals_app/widgets/places_list.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesList = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Places',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddPlaceScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlaceList(places: placesList),
      ),
    );
  }
}
