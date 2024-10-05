import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meals_app/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocationDetails(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocationDetails location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _sendCurrentPickedLocation() {
    Navigator.of(context).pop(_pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick your Location' : 'Your Location',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _sendCurrentPickedLocation,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          if (widget.isSelecting) {
            setState(() {
              _pickedLocation = position;
            });
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
