import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart' hide Location;
import 'package:google_geocoding/google_geocoding.dart' as gc;

import 'colors.dart';
import 'constants.dart';

class Functions {
  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static showLoaderDialog(BuildContext context, {String text = 'Loading'}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: CColors.primary,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                "$text...",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Color generateColorFromString(String input) {
    int hashCode = input.hashCode;

    // Use the hash code to generate a seed for randomization
    int seed = hashCode % 1000000;

    // Create a random number generator with the determined seed
    Random random = Random(seed);

    // Generate RGB values with random variations to create different shades of dark colors
    int red = random.nextInt(128);
    int green = random.nextInt(128);
    int blue = random.nextInt(128);

    return Color.fromARGB(255, red + 128, green + 128, blue + 128);
  }

  static Future<Map<String, dynamic>> getLatLongFromAddress(
      String address) async {
    List<Location> locations = await locationFromAddress(address);

    return {"lat": locations.first.latitude, "long": locations.first.longitude};
  }

  static Future<Map<String, String>> getCityFromLatLong(
      double lat, double long) async {
    String location = "";
    String state = "";
    String country = "";

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String? city = placemark.locality;
        state = placemark.administrativeArea ?? "";
        country = placemark.country ?? "";

        location = "$city";
      } else {
        print('No placemarks found.');
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    return {"city": location, "state": state, "country": country};
  }

  static Future<bool> doesEmailExist(String email) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'dummy_password', // Provide a dummy password
      );
      return true; // Email exists
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false; // Email does not exist
      } else {
        return true;
      }
    }
  }

  static Future<List<List<String>>> autoCompleteCity(String input) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&components=country:us&key=${Constants.mapKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List<dynamic>;

      List<String> citySuggestions = [];
      List<String> placeIds = [];
      for (var prediction in predictions) {
        print(prediction);
        citySuggestions.add(prediction['description']);
        placeIds.add(prediction["place_id"]);
      }

      return [citySuggestions, placeIds];
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  static getAddress(double lat, double lng) async {
    var googleGeocoding =
        gc.GoogleGeocoding("AIzaSyDielMrqePDtgCxZUHSbWkKr4SyTZjXWAk");
    var l = gc.LatLon(lat, lng);
    gc.GeocodingResponse? result =
        await googleGeocoding.geocoding.getReverse(l);

    if (result != null &&
        result.results != null &&
        result.results!.isNotEmpty) {
      var element = result.results![0];
      return element.addressComponents;
    }
  }

  static Future<Map<String, double>> determinePosition(
      BuildContext context) async {
    bool serviceEnabled;


    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showError('Location services are disabled.', context);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          showError('Location permissions are denied', context);
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showError(
          'Location permissions are permanently denied, we cannot request permissions. Turn these on from settings',
          context);
    }

    var position = await Geolocator.getCurrentPosition();

    return {"lat": position.latitude, "long": position.longitude};
  }

  static showError(String message, BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
              message,
            ),
          );
        });
  }
}
