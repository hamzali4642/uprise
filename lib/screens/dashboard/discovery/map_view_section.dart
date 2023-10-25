import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/provider/data_provider.dart';

class MapViewSection extends StatefulWidget {
  const MapViewSection({Key? key}) : super(key: key);

  @override
  _MapViewSectionState createState() => _MapViewSectionState();
}

class _MapViewSectionState extends State<MapViewSection> {
  late CameraPosition cameraPosition;

  late DataProvider dataProvider;

  Set<Circle> circles = {};

  @override
  void initState()  {
    super.initState();

    dataProvider = context.read<DataProvider>();
    cameraPosition =
        const CameraPosition(target: LatLng(31.5212832, 74.4375577), zoom: 8);
    addCircles();
  }

  addCircles() {
    Map<String, dynamic> cities = {};

    for (var element in dataProvider.songs) {
      cities["${element.city},${element.country}"] =
          (cities["${element.city},${element.country}"] == null)
              ? 1
              : cities["${element.city},${element.country}"] + 1;
    }

    cities.forEach((key, value) async {
      Map<String, dynamic> position =
          await Functions.getLatLongFromAddress(key);
      print("$key $value");
      print(position);

      circles.add(Circle(
          strokeWidth: 1,
          center: LatLng(position["lat"], position["long"]),
          circleId: CircleId(key),
          radius: 10000,
          fillColor: value <= 2
              ? Colors.red.shade300.withOpacity(0.5)
              : value > 2 && value <= 5
                  ? Colors.red.shade500.withOpacity(0.5)
                  : Colors.red.shade700.withOpacity(0.5)));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Map View Section",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        circles: circles,
        scrollGesturesEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: cameraPosition,
      ),
    );
  }
}
