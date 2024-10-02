import 'package:flutter/material.dart';
import 'package:meals_app/models/place.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet.',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        );
      },
      itemCount: places.length,
    );
  }
}
