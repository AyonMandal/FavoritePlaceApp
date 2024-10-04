import 'dart:io';

import 'package:uuid/uuid.dart';

class PlaceLocationDetails {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocationDetails(
      {required this.latitude, required this.longitude, required this.address});
}

class Place {
  final String title;
  final String id;
  final File image;
  final PlaceLocationDetails locationDetails;

  Place(
      {required this.title, required this.image, required this.locationDetails})
      : id = const Uuid().v4();
}
