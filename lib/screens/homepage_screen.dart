import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:deliveryapplication_mobile_driver/screens/message_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/order_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/profile_screen.dart';
import 'package:deliveryapplication_mobile_driver/services/getlocation.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;
  bool isOnline = false;
  bool _isLoading = true;
  MapboxMap? mapboxMap;
  LocationService _locationService = LocationService();
  double? _latitude;
  double? _longitude;
  PointAnnotationManager? pointAnnotationManager;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation(); // Lấy vị trí đầu tiên khi mở ứng dụng
    setState(() {
      _isLoading = false;
    });
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    _moveCameraToCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Map<String, double>? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _latitude = location['latitude'];
          _longitude = location['longitude'];
        });
        if (isOnline) {
          _updateLocationOnMap();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _moveCameraToCurrentLocation() async {
    if (mapboxMap != null && _latitude != null && _longitude != null) {
      CameraOptions camera = CameraOptions(
        center: Point(coordinates: Position(_longitude ?? 0.0, _latitude ?? 0.0)),
        zoom: 15,
        bearing: 0,
        pitch: 30,
      );
      mapboxMap?.setCamera(camera);
    }
  }

  Future<void> _updateLocationOnMap() async {
    if (mapboxMap != null && _latitude != null && _longitude != null) {
      // Xóa tất cả điểm cũ
      pointAnnotationManager?.deleteAll();

      // Tải icon và tạo annotation
      final ByteData bytes = await rootBundle.load('assets/icons/pin.png');
      final Uint8List imageData = bytes.buffer.asUint8List();
      PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position(_longitude!, _latitude!)),
        image: imageData,
        iconSize: 0.2,
      );
      pointAnnotationManager?.create(pointAnnotationOptions);
    }
  }

  void _toggleOnlineStatus() {
    setState(() {
      isOnline = !isOnline;
      if (isOnline) {
        // Bắt đầu cập nhật vị trí mỗi 5 giây
        _locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
          _getCurrentLocation();
        });
        _updateLocationOnMap(); // Vẽ icon vị trí lên map
      } else {
        // Dừng cập nhật và xóa icon vị trí trên map
        _locationUpdateTimer?.cancel();
        pointAnnotationManager?.deleteAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    MapboxOptions.setAccessToken("pk.eyJ1IjoicW5nb2MwNzAxMjAwMiIsImEiOiJjbTE0MDkwbWkxZ3IwMnZxMjB2ejBkaGZnIn0.cuJH5sW_W10ZWlQpIb67dw");

    CameraOptions camera = CameraOptions(
      center: Point(coordinates: Position(_longitude ?? 0.0, _latitude ?? 0.0)),
      zoom: 15,
      bearing: 0,
      pitch: 30,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : MapWidget(
            cameraOptions: camera,
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.DARK,
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
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
                  onPressed: _toggleOnlineStatus,
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
