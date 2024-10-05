import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  }, version: 1);

  return db;
}

class PlacesProviderNotifier extends StateNotifier<List<Place>> {
  PlacesProviderNotifier() : super(const []);

  Future<void> getPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final listOfPlaces = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            locationDetails: PlaceLocationDetails(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();

    state = listOfPlaces;
  }

  void addPlace(
      String title, File imageFile, PlaceLocationDetails location) async {
    final appDir = await sys_path.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final copiedImage = await imageFile.copy('${appDir.path}/$fileName');
    final newPlace =
        Place(title: title, image: copiedImage, locationDetails: location);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.locationDetails.latitude,
      'lng': newPlace.locationDetails.longitude,
      'address': newPlace.locationDetails.address,
    });

    state = [...state, newPlace];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesProviderNotifier, List<Place>>(
  (ref) => PlacesProviderNotifier(),
);
