import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData? locationData;
  bool fetchingLocation = false;
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

    setState(() {
      fetchingLocation = false;
    });

    print(locationData!.latitude);
    print(locationData!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

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
              onPressed: null,
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
