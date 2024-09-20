import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:deliveryapplication_mobile_driver/screens/message_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/order_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/profile_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/services/getlocation.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;
  bool isOnline = false;
  bool _isLoading = true; // Thêm biến trạng thái loading
  MapboxMap? mapboxMap;
  LocationService _locationService = LocationService();
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Map<String, double>? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _latitude = location['latitude']!;
          _longitude = location['longitude']!;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected index: $_selectedIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF39c5c8),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          OrderPage(),
          MessagePage(),
          ProfilePage(),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Stack(
      children: [
        // Map section
        Positioned.fill(
          child: _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : MapWidget(
            key: const ValueKey("mapWidget"),
            resourceOptions: ResourceOptions(
                accessToken:
                "pk.eyJ1IjoicW5nb2MwNzAxMjAwMiIsImEiOiJjbTE0MDkwbWkxZ3IwMnZxMjB2ejBkaGZnIn0.cuJH5sW_W10ZWlQpIb67dw"),
            cameraOptions: CameraOptions(
                center: Point(coordinates: Position(_longitude, _latitude)).toJson(),
                zoom: 17),
            styleUri: MapboxStyles.DARK,
            textureView: true,
            onMapCreated: _onMapCreated,
          ),
        ),
        // Header with avatar, name, and status toggle button
        Positioned(
          top: 40, // Adjust as needed
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6), // Semi-transparent background for better readability
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFQv4gzmNtZTnbl7lQMMmV5JWDO2_fIO2luA&s',
                  ),
                  radius: 30,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Béo Shipper',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isOnline ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isOnline = !isOnline;
                    });
                  },
                  child: Text(isOnline ? 'Go Offline' : 'Go Online'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF39c5c8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DriverHomePage(),
  ));
}
