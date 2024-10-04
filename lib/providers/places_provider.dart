import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/place.dart';

class PlacesProviderNotifier extends StateNotifier<List<Place>> {
  PlacesProviderNotifier() : super(const []);

  void addPlace(String title, File imageFile, PlaceLocationDetails location) {
    final newPlace =
        Place(title: title, image: imageFile, locationDetails: location);
    state = [...state, newPlace];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesProviderNotifier, List<Place>>(
  (ref) => PlacesProviderNotifier(),
);
