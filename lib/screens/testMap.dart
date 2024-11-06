import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => MyAppState();
// This widget is the root of your application.
}

class MyAppState extends State<MyApp> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  @override
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
    await mapboxMap.annotations.createPointAnnotationManager();

    // Load the image from assets
    final ByteData bytes =
    await rootBundle.load('D:\Github\FYP_NSERVE_DeliveryApplication_Mobile_Driver\assets\icons\nserve_icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    // Create a PointAnnotationOptions
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position(-74.00913, 40.75183)), // Example coordinates
        image: imageData,
        iconSize: 3.0
    );

    // Add the annotation to the map
    pointAnnotationManager?.create(pointAnnotationOptions);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    // Pass your access token to MapboxOptions so you can load a map
    String ACCESS_TOKEN = const String.fromEnvironment("pk.eyJ1IjoicW5nb2MwNzAxMjAwMiIsImEiOiJjbTE0MDkwbWkxZ3IwMnZxMjB2ejBkaGZnIn0.cuJH5sW_W10ZWlQpIb67dw");
    MapboxOptions.setAccessToken("pk.eyJ1IjoicW5nb2MwNzAxMjAwMiIsImEiOiJjbTE0MDkwbWkxZ3IwMnZxMjB2ejBkaGZnIn0.cuJH5sW_W10ZWlQpIb67dw");

    // Define options for your camera
    CameraOptions camera = CameraOptions(
        center: Point(coordinates: Position(-74.00913, 40.75183)),
        zoom: 9.6,
        bearing: 0,
        pitch: 30);

    return MaterialApp(
      title: 'Flutter Demo',
      home: MapWidget(
        cameraOptions: camera,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
