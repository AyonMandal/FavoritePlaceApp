import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/place.dart';

class PlacesProviderNotifier extends StateNotifier<List<Place>> {
  PlacesProviderNotifier() : super(const []);

  void addPlace(String title) {
    final newPlace = Place(title: title);
    state = [...state, newPlace];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesProviderNotifier, List<Place>>(
  (ref) => PlacesProviderNotifier(),
);
