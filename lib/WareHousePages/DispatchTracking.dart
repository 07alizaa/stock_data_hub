import 'dart:async';
import 'dart:math'; // For calculating distances
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom LatLng class for truck and destination
class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

class DispatchTrackingPage extends StatefulWidget {
  final String dispatchId;

  const DispatchTrackingPage({Key? key, required this.dispatchId}) : super(key: key);

  @override
  _DispatchTrackingPageState createState() => _DispatchTrackingPageState();
}

class _DispatchTrackingPageState extends State<DispatchTrackingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LatLng _currentTruckLocation = LatLng(27.6660, 85.3227); // Example starting point
  LatLng? _destinationLocation; // Destination location
  double _distanceToDestination = 0.0;
  bool _isCompleted = false;

  Timer? _movementTimer;

  @override
  void initState() {
    super.initState();
    _loadDispatchData(); // Load Firestore data
    _startMovementSimulation(); // Simulate truck movement
  }

  // Fetch dispatch data from Firestore
  Future<void> _loadDispatchData() async {
    final dispatchDoc = await _firestore.collection('dispatchRecords').doc(widget.dispatchId).get();

    if (dispatchDoc.exists) {
      final data = dispatchDoc.data();
      setState(() {
        if (data != null) {
          final location = data['deliveryLocation'];
          _destinationLocation = LatLng(location['lat'], location['lng']);
          _calculateDistance();
        }
      });
    }
  }

  // Simulate truck movement toward the destination
  void _startMovementSimulation() {
    _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_destinationLocation == null || _isCompleted) {
        timer.cancel();
        return;
      }

      _moveTruckCloser();

      if (_distanceToDestination <= 0.01) {
        setState(() {
          _isCompleted = true;
        });
        _firestore
            .collection('dispatchRecords')
            .doc(widget.dispatchId)
            .update({'status': 'Completed'});
        timer.cancel();
      }
    });
  }

  // Move the truck closer to the destination
  void _moveTruckCloser() {
    if (_destinationLocation != null) {
      final latDiff = (_destinationLocation!.latitude - _currentTruckLocation.latitude) * 0.1;
      final lngDiff = (_destinationLocation!.longitude - _currentTruckLocation.longitude) * 0.1;

      setState(() {
        _currentTruckLocation = LatLng(
          _currentTruckLocation.latitude + latDiff,
          _currentTruckLocation.longitude + lngDiff,
        );
        _calculateDistance();
      });
    }
  }

  // Calculate the distance between the truck and the destination
  void _calculateDistance() {
    if (_destinationLocation != null) {
      const double radius = 6371; // Earth's radius in km
      final double dLat = (_destinationLocation!.latitude - _currentTruckLocation.latitude) * (pi / 180);
      final double dLng = (_destinationLocation!.longitude - _currentTruckLocation.longitude) * (pi / 180);

      final double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(_currentTruckLocation.latitude * (pi / 180)) *
              cos(_destinationLocation!.latitude * (pi / 180)) *
              sin(dLng / 2) *
              sin(dLng / 2);

      final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      setState(() {
        _distanceToDestination = radius * c;
      });
    }
  }

  @override
  void dispose() {
    _movementTimer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Tracking'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildDetailsSection(), // Dispatch details
          _buildSimulatedMap(), // Simulated map with truck and destination
          _buildProgressBar(), // Progress bar showing distance
        ],
      ),
    );
  }

  // Display dispatch details
  Widget _buildDetailsSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Truck Location: (${_currentTruckLocation.latitude}, ${_currentTruckLocation.longitude})'),
            if (_destinationLocation != null)
              Text('Destination: (${_destinationLocation!.latitude}, ${_destinationLocation!.longitude})'),
            Text('Distance Remaining: ${_distanceToDestination.toStringAsFixed(2)} km'),
            Text('Status: ${_isCompleted ? "Completed" : "In Transit"}'),
          ],
        ),
      ),
    );
  }

  // Simulated map with truck and destination
  Widget _buildSimulatedMap() {
    return Container(
      height: 300,
      color: Colors.grey[300],
      child: Stack(
        children: [
          if (_destinationLocation != null)
            Positioned(
              top: 50,
              left: 100,
              child: Icon(Icons.location_on, color: Colors.red, size: 30), // Destination icon
            ),
          Positioned(
            top: 150,
            left: 200,
            child: Icon(Icons.local_shipping, color: Colors.blue, size: 30), // Truck icon
          ),
        ],
      ),
    );
  }

  // Progress bar to show distance remaining
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Distance to Destination: ${_distanceToDestination.toStringAsFixed(2)} km',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _distanceToDestination > 0 ? 1 - (_distanceToDestination / 10) : 1,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            minHeight: 8.0,
          ),
        ],
      ),
    );
  }
}
