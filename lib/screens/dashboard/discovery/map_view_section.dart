import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uprise/helpers/textstyles.dart';

class MapViewSection extends StatefulWidget {
  const MapViewSection({Key? key}) : super(key: key);

  @override
  _MapViewSectionState createState() => _MapViewSectionState();
}

class _MapViewSectionState extends State<MapViewSection> {

  late CameraPosition cameraPosition;

  Set<Polygon> polygons = {};

  @override
  void initState() {
    super.initState();

    cameraPosition =
    const CameraPosition(target: LatLng(39.3426728, 9.2390613), zoom: 2);

    polygons.add(Polygon(
      polygonId: PolygonId('highlight_polygon'),
      points: [
        LatLng(38.9357948,-9.241254),
        LatLng(38.9357948, -9.241254),
        LatLng(38.9357948, -9.241254),
        LatLng(38.6112076, -9.2115624),
      ],
      fillColor: Colors.red.withOpacity(0.5),
      strokeWidth: 2,
      strokeColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View Section",style: TextStyle(color: Colors.white),),
      ),
        body: GoogleMap(
      polygons: polygons,
      scrollGesturesEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: cameraPosition,
    ));
  }
}
