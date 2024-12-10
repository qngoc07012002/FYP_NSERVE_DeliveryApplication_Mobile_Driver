import 'package:deliveryapplication_mobile_driver/controllers/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import '../models/user_model.dart';
import '../services/getlocation.dart';
import '../ultilities/Constant.dart';
import '../controllers/order_controller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isMultipleStop = false;
  final OrderController orderController = Get.find<OrderController>();
  LocationService _locationService = LocationService();
  MapBoxNavigationViewController? _controller;
  late MapBoxOptions _navigationOption;
  String? _platformVersion;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  double? _distanceRemaining, _durationRemaining;
  String? _instruction;
  double? _latitude;
  double? _longitude;
  DriverController driverController = Get.find();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();

  }

  Future<void> _getCurrentLocation() async {
    try {
      Map<String, double>? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _latitude = location['latitude'];
          _longitude = location['longitude'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> initialize() async {
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.language = "en";
    _navigationOption.bannerInstructionsEnabled = true;
    _navigationOption.mapStyleUrlDay = "mapbox://styles/mapbox/dark-v11";
    _navigationOption.mapStyleUrlNight = "mapbox://styles/mapbox/dark-v11";
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF39c5c8),
        title: const Text(
          'Invoice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 80.0,
      ),
      body: Obx(() {
        final currentOrder = orderController.currentOrder.value;


        if (currentOrder == null) {
          return const Center(
            child: Text(
              'No Order Details Available',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        }

        final orderId = currentOrder.id;
        final orderType = currentOrder.orderType;
        final orderCode = currentOrder.orderCode;
        final shippingFee = currentOrder.shippingFee;
        final restaurantInfo = currentOrder.restaurantInfo;
        final userInfo = currentOrder.userInfo;
        final startLocation = currentOrder.startLocation.address;
        final endLocation = currentOrder.endLocation.address;
        final formattedTime = currentOrder.formattedCreatedAt;



        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Code
                Text(
                  'Order Code: $orderCode',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Thông tin chi tiết
                if (orderType == 'FOOD' && restaurantInfo != null)
                  _buildFoodOrderSection(restaurantInfo, userInfo, endLocation)
                else
                  _buildRideOrderSection(userInfo, startLocation, endLocation),

                const SizedBox(height: 16.0),

                // Shipping Fee
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping Fee',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      Text(
                        '\$$shippingFee',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Color(0xFF39c5c8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Order Time
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Order Time: $formattedTime',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() {
        final currentOrder = orderController.currentOrder.value;

        if (currentOrder == null) {
          return const SizedBox.shrink();
        }


        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (orderController.currentOrder.value?.orderStatus == 'PREPARING') ...[
                FloatingActionButton.extended(
                  heroTag: "preparing",
                  backgroundColor: const Color(0xFF39c5c8),
                  onPressed: () {
                    print('Restaurant is preparing');
                  },
                  label: Row(
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Preparing Order',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                FloatingActionButton(
                  heroTag: "navigate_preparing",
                  backgroundColor: Colors.white,
                  onPressed: () async{
                    final _start = WayPoint(
                        name: "Start",
                        latitude: _latitude,
                        longitude: _longitude,
                        isSilent: false);

                    final _end = WayPoint(
                        name: "End",
                        latitude: orderController.currentOrder.value?.startLocation.latitude,
                        longitude: orderController.currentOrder.value?.startLocation.longitude,
                        isSilent: false);

                    var wayPoints = <WayPoint>[];
                    wayPoints.add(_start);
                    wayPoints.add(_end);

                    await MapBoxNavigation.instance
                        .startNavigation(wayPoints: wayPoints, options: _navigationOption);
                    print('Navigate to Store');
                  },
                  child: const Icon(
                    Icons.navigation,
                    color: Color(0xFF39c5c8),
                  ),
                  mini: true,
                ),
              ] else if (orderController.currentOrder.value?.orderStatus == 'PREPARED' || orderController.currentOrder.value?.orderStatus == 'DELIVERING') ...[
                FloatingActionButton.extended(
                  heroTag: "delivering",
                  backgroundColor: const Color(0xFF39c5c8),
                  onPressed: () {
                    if (orderController.currentOrder.value?.orderStatus == 'PREPARED') {
                      // TODO: Logic Proceed to Deliver
                      print('Proceed to Deliver');
                      orderController.sendOrderStatusUpdate(orderController.currentOrder.value!.id!, orderController.driverId.value, "DRIVER_DELIVERING_ORDER");
                      orderController.currentOrder.value?.orderStatus = "DELIVERING";
                      setState(() {

                      });

                    } else if (orderController.currentOrder.value?.orderStatus == 'DELIVERING') {
                      // TODO: Logic complete Order
                      print('Complete Order');
                      orderController.sendOrderStatusUpdate(orderController.currentOrder.value!.id!, orderController.driverId.value, "DRIVER_DELIVERED_ORDER");
                      orderController.currentOrder.value?.orderStatus = "DELIVERED";
                      driverController.fetchDriverInfo();
                      setState(() {

                      });
                    }
                  },
                  label: Text(
                    orderController.currentOrder.value?.orderStatus == 'PREPARED' ? 'Proceed to Deliver' : 'Complete Order',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(
                    orderController.currentOrder.value?.orderStatus == 'PREPARED' ? Icons.delivery_dining : Icons.done,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                if (orderController.currentOrder.value?.orderStatus == 'DELIVERING')
                FloatingActionButton(
                  heroTag: "navigate_delivering",
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    final _start = WayPoint(
                        name: "Start",
                        latitude: orderController.currentOrder.value?.startLocation.latitude,
                        longitude: orderController.currentOrder.value?.startLocation.longitude,
                        isSilent: false);

                    final _end = WayPoint(
                        name: "End",
                        latitude: orderController.currentOrder.value?.endLocation.latitude,
                        longitude: orderController.currentOrder.value?.endLocation.longitude,
                        isSilent: false);

                    var wayPoints = <WayPoint>[];
                    wayPoints.add(_start);
                    wayPoints.add(_end);

                    await MapBoxNavigation.instance
                        .startNavigation(wayPoints: wayPoints, options: _navigationOption);
                    print('Open Navigation');
                  },
                  child: const Icon(
                    Icons.navigation,
                    color: Color(0xFF39c5c8),
                  ),
                  mini: true, // Nút nhỏ
                ),
              ],
            ],
          ),
        );
      }),


    );
  }

  // Widget cho FOOD order
  Widget _buildFoodOrderSection(Restaurant restaurantInfo, User userInfo, String endLocation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Restaurant Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: restaurantInfo.img,
          name: restaurantInfo.name,
          address: restaurantInfo.restaurantLocation,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Delivery To:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: userInfo.img,
          name: userInfo.name,
          address: endLocation,
        ),
      ],
    );
  }

  // Widget cho RIDE order
  Widget _buildRideOrderSection(
      User userInfo, String startLocation, String endLocation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: userInfo.img,
          name: userInfo.name,
          address: startLocation,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'From - To:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildAddressCard(startLocation, endLocation),
      ],
    );
  }

  Widget _buildInfoCard({
    required String imageUrl,
    required String name,
    required String address,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(Constant.IMG_URL + imageUrl),
          radius: 30.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                address,
                style: const TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(String start, String end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start: $start',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          'End: $end',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
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
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
    setState(() {});
  }
}
