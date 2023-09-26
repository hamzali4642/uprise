import 'dart:math';
import 'package:geocoding/geocoding.dart';

import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart' hide Location;

import 'colors.dart';

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

  static Future<String> getCityFromLatLong(double lat, double long) async {
    String location = "";

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String? city = placemark.locality;

        location = "$city";
      } else {
        print('No placemarks found.');
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    return location;
  }
}
