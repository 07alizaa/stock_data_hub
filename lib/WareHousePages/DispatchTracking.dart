import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DispatchTrackingPage extends StatefulWidget {
  final String dispatchId;

  const DispatchTrackingPage({Key? key, required this.dispatchId}) : super(key: key);

  @override
  _DispatchTrackingPageState createState() => _DispatchTrackingPageState();
}

class _DispatchTrackingPageState extends State<DispatchTrackingPage> {
  late GoogleMapController _mapController;
  LatLng _currentTruckLocation = const LatLng(27.6660, 85.3227); // Example starting point
  LatLng? _destinationLocation;

  @override
  void initState() {
    super.initState();
    _loadDispatchData();
  }

  Future<void> _loadDispatchData() async {
    final dispatchDoc = await FirebaseFirestore.instance
        .collection('dispatchRecords')
        .doc(widget.dispatchId)
        .get();

    if (dispatchDoc.exists) {
      final data = dispatchDoc.data();
      setState(() {
        if (data != null) {
          final location = data['deliveryLocation'];
          _destinationLocation = LatLng(location['lat'], location['lng']);
        }
      });
    }
  }

  void _updateTruckLocation() {
    // Example logic to simulate truck movement
    if (_destinationLocation != null) {
      final latDiff = (_destinationLocation!.latitude - _currentTruckLocation.latitude) * 0.1;
      final lngDiff = (_destinationLocation!.longitude - _currentTruckLocation.longitude) * 0.1;

      setState(() {
        _currentTruckLocation = LatLng(
          _currentTruckLocation.latitude + latDiff,
          _currentTruckLocation.longitude + lngDiff,
        );
      });

      if (_currentTruckLocation == _destinationLocation) {
        FirebaseFirestore.instance
            .collection('dispatchRecords')
            .doc(widget.dispatchId)
            .update({'status': 'Completed'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Dispatch'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentTruckLocation,
              zoom: 12.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('truck'),
                position: _currentTruckLocation,
                infoWindow: const InfoWindow(title: 'Truck Location'),
              ),
              if (_destinationLocation != null)
                Marker(
                  markerId: const MarkerId('destination'),
                  position: _destinationLocation!,
                  infoWindow: const InfoWindow(title: 'Destination'),
                ),
            },
            onMapCreated: (controller) => _mapController = controller,
          ),
        ],
      ),
    );
  }
}
