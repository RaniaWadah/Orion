import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  Future<Position> fetchCurrentLocation() async {
    bool _serviceEnabled;
    Location location = new Location();

    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location Denied once');
      }
    }

    final _locationData = await location.getLocation();

    if (_locationData != null) {
      return Position(
          latitude: _locationData.latitude!,
          longitude: _locationData.longitude!,
          accuracy: _locationData.accuracy!,
          altitude: _locationData.altitude!,
          heading: _locationData.heading!,
          speed: _locationData.speed!,
          speedAccuracy: _locationData.speedAccuracy!,
          timestamp: null);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> determinePosition() async {
    bool _serviceEnabled;
    Location location = new Location();

    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location Denied once');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> isLocationPermissionGranted(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> checkAndRequestPermissionWithDialog(BuildContext context) async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }

    if (permission == LocationPermission.denied) {
      print("Permission denied ");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        return true;
      }
    }
    return checkLocationPermissionWithDialog(context: context);
  }

  Future<bool> checkLocationPermissionWithDialog({required BuildContext context}) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text("", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal)),
          content: Text('Allow access to your location to better performance',
              style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.transparent),
              child: Text('Ok', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal)),
            ),
          ],
        );
      },
    );

    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings(); // to redirect GPS settings,
    return false;
  }
}
