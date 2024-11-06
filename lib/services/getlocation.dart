import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return Future.error('Location services are disabled.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // Location permissions are denied
          return Future.error('Location permissions are denied.');
        }
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );



      // Return a map with latitude and longitude
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      // Handle exceptions and errors
      return Future.error('Error getting location: $e');
    }
  }
}
