import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:meals_app/models/place.dart';
import 'package:meals_app/screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationSelect});

  final void Function(PlaceLocationDetails locationDetails) onLocationSelect;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData? locationData;
  PlaceLocationDetails? locationDetails;
  bool fetchingLocation = false;

  String get locationImage {
    if (locationDetails == null) {
      return '';
    }
    final lat = locationDetails!.latitude;
    final lng = locationDetails!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDKGjqFSpEAv-eZuYF4UMPOxWrXtgs-E9g';
  }

  void _onGetLocationTapped() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      fetchingLocation = true;
    });

    locationData = await location.getLocation();

    final longitude = locationData!.longitude;
    final latitude = locationData!.latitude;

    if (latitude == null || longitude == null) {
      return;
    }

    getAddressFromLatLong(latitude, longitude);
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDKGjqFSpEAv-eZuYF4UMPOxWrXtgs-E9g',
    );
    final response = await http.get(url);
    final decodedResponse = json.decode(response.body);
    final address = decodedResponse['results'][0]['formatted_address'];
    setState(() {
      locationDetails = PlaceLocationDetails(
          latitude: latitude, longitude: longitude, address: address);
      fetchingLocation = false;
    });

    widget.onLocationSelect(locationDetails!);
  }

  void _openMapScreen() async {
    final LatLng? locationData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );

    if (locationData == null) return;
    getAddressFromLatLong(locationData.latitude, locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    if (locationDetails != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (fetchingLocation) {
      content = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: content),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _onGetLocationTapped,
              label: Text(
                'Get Current Location',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton.icon(
              onPressed: _openMapScreen,
              label: Text(
                'Select On Map',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              icon: Icon(
                Icons.map,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        )
      ],
    );
  }
}
