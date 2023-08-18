import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_geocoding/google_geocoding.dart' as gc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../helpers/colors.dart';
import '../helpers/functions.dart';
import '../models/address_model.dart';


class SelectLocation extends StatefulWidget {
  Color primary;

  SelectLocation({Key? key, this.primary = CColors.primary}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  CameraPosition position = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? _controller;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late double height, width;

  String searchResults = "Search Address";
  var controller = TextEditingController();

  String postalCode = "", city = "", country = "", state = "";

  @override
  void initState() {
    // _determinePosition();
    super.initState();
  }

  bool fromPlaces = false;

  String? code;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            onCameraIdle: () {
              if (latLng != null) {
                if (!fromPlaces) {
                  getAddress();
                }
                fromPlaces = false;
                addMarker(latLng!);
              }
            },
            onCameraMove: (CameraPosition position) {
              latLng = position.target;
            },
            mapType: MapType.normal,
            initialCameraPosition: position,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: Set<Marker>.of(markers.values),
          ),
          InkWell(
            onTap: () async {
              var p = await PlacesAutocomplete.show(
                context: context,
                apiKey: "AIzaSyDielMrqePDtgCxZUHSbWkKr4SyTZjXWAk",
                onError: (error) {},
                mode: Mode.overlay,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                types: [],
                strictbounds: false,
                components: [
                  // Component(Component.country, "pk"),
                ],
              );
              displayPrediction(p);
            },
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.01),
                // decoration: Constants.shadowDecoration(),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.01),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Expanded(
                      child: Text(
                        searchResults,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "jr",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.015,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: widget.primary,
                  padding: EdgeInsets.symmetric(vertical: height * 0.025),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  if (latLng == null || searchResults == "Search Address") {
                    Functions.showSnackBar(
                      context,
                      "Please select the location",
                    );
                  } else {
                    AddressModel model = AddressModel(
                      latitude: latLng!.latitude,
                      longitude: latLng!.longitude,
                      country: country,
                      city: city,
                      postalCode: postalCode,
                      address: searchResults,
                    );
                    Navigator.of(context).pop(model);
                  }
                },
                child: const Text(
                  "Select Location",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "jr",
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getAddress() async {
    var googleGeocoding =
    gc.GoogleGeocoding("AIzaSyDielMrqePDtgCxZUHSbWkKr4SyTZjXWAk");
    var l = gc.LatLon(latLng!.latitude, latLng!.longitude);
    gc.GeocodingResponse? result =
    await googleGeocoding.geocoding.getReverse(l);

    String address = "";
    searchResults = "";
    city = "";
    country = "";
    postalCode = "";
    if (result != null &&
        result.results != null &&
        result.results!.isNotEmpty) {
      var element = result.results![0];
      if (element.formattedAddress != null) {
        address = element.formattedAddress!;
      }

      if (element.addressComponents != null) {
        for (var element in element.addressComponents!) {
          if (element.types == null || element.longName == null) {
            return;
          }
          var types = element.types!;
          print(types);
          print(element.longName);
          if (types.contains("locality")) {
            city = element.longName!;
          }


          if(types.contains("administrative_area_level_1")){
            state = element.longName!;
          }

          if (types.contains("postal_code")) {
            postalCode = element.longName!;
          }
          if (types.contains("country")) {
            country = element.longName!;
          }
        }
      }

      setState(() {
        searchResults = address;
      });
    }
  }

  addMarker(LatLng model) {
    var markerIdVal = "Selected Location";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        model.latitude,
        model.longitude,
      ),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    markers[markerId] = marker;
    setState(() {});
  }

  LatLng? latLng;

  Future<void> displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: "AIzaSyDielMrqePDtgCxZUHSbWkKr4SyTZjXWAk",
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      searchResults = "";
      city = "";
      country = "";
      postalCode = "";

      PlacesDetailsResponse detail =
      await places.getDetailsByPlaceId(p.placeId!);
      var element = detail.result;
      for (var element in element.addressComponents) {
        var types = element.types;
        if (types.contains("locality")) {
          city = element.longName;
        }
        if (types.contains("postal_code")) {
          postalCode = element.longName;
        }
        if (types.contains("country")) {
          country = element.longName;
        }
      }
      fromPlaces = true;
      setState(() {
        searchResults = element.formattedAddress ?? "";
      });

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      var position = LatLng(lat, lng);
      latLng = position;
      if (_controller != null) {
        _controller!.animateCamera(CameraUpdate.newLatLng(position));
      }
    }
  }
}