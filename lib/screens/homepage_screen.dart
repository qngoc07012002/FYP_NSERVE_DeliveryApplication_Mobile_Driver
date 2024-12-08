import 'dart:async';
import 'dart:typed_data';
import 'package:deliveryapplication_mobile_driver/controllers/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:deliveryapplication_mobile_driver/screens/message_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/order_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/profile_screen.dart';
import 'package:deliveryapplication_mobile_driver/services/getlocation.dart';

import '../ultilities/Constant.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  DriverController driverController = Get.find();
  int _selectedIndex = 0;
  bool _isLoading = true;
  LocationService _locationService = LocationService();
  double? _latitude;
  double? _longitude;
  Timer? _locationUpdateTimer;
  bool _isMultipleStop = false;
  MapBoxNavigationViewController? _controller;
  late MapBoxOptions _navigationOption;
  String? _platformVersion;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  double? _distanceRemaining, _durationRemaining;
  String? _instruction;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    initialize();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.language = "en";
    _navigationOption.bannerInstructionsEnabled = false;
    // _navigationOption.mapStyleUrlDay = "mapbox://styles/mapbox/dark-v11";
    // _navigationOption.mapStyleUrlNight = "mapbox://styles/mapbox/dark-v11";
    _navigationOption.initialLatitude = _latitude;
    _navigationOption.initialLongitude = _longitude;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Map<String, double>? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _latitude = location['latitude'];
          _longitude = location['longitude'];
        });
        if (driverController.isOnline.value) {
          //_updateLocationOnMap();
          driverController.updateDriverLocation(_latitude!, _longitude!);
        }
      }
    } catch (e) {
      print(e);
    }
  }



  void _toggleOnlineStatus() {
    setState(() {
      driverController.isOnline.value = !driverController.isOnline.value;
      if (driverController.isOnline.value){
        driverController.driver.value?.status = "ONLINE";
      } else {
        driverController.driver.value?.status = "OFFLINE";
      }
      driverController.updateDriverStatus();
      if (driverController.isOnline.value) {
        // Bắt đầu cập nhật vị trí mỗi 5 giây
        _locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
          _getCurrentLocation();
        });
       // _updateLocationOnMap(); // Vẽ icon vị trí lên map
      } else {
        // Dừng cập nhật và xóa icon vị trí trên map
        _locationUpdateTimer?.cancel();
      //  pointAnnotationManager?.deleteAll();
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

    return Stack(
      children: [
        Positioned.fill(
          child: MapBoxNavigationView(
            options: _navigationOption,
            onRouteEvent: _onEmbeddedRouteEvent,
            onCreated: (MapBoxNavigationViewController controller) async {
              _controller = controller;
              controller.initialize();
            },
          ),
        ),
        Positioned(
          top: 50,
          left: 10,
          right: 80,
          child: Obx(() {
            // Lấy thông tin tài xế từ controller
            var driver = driverController.driver.value;
            if (driver == null) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${Constant.BACKEND_URL}${driver.imgUrl}'),
                    radius: 30,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.driverName ?? 'Driver Name',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                                color: driverController.isOnline.value ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              driverController.isOnline.value ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: driverController.isOnline.value ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleOnlineStatus,
                    child: Text(driverController.isOnline.value ? 'Go Offline' : 'Go Online'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xFF39c5c8),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        print("Navigation Canceled");
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
