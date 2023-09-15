import 'dart:io';

import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  static const appName = "learnfinity";
  static const bullet = "  •  ";

  static const demoImage =
      "https://img.freepik.com/premium-photo/natural-real-person-portrait-closeup-woman-girl-female-outside-nature-forest-artistic-edgy-cute-pretty-face-ai-generated_590464-133625.jpg?w=2000";
  static const demoCoverImage =
      "https://static.vecteezy.com/system/resources/previews/002/909/206/original/abstract-background-for-landing-pages-banner-placeholder-cover-book-and-print-geometric-pettern-on-screen-gradient-colors-design-vector.jpg";
  static const homePadding = 10.0;
  static const horizontalPadding = 20.0;
  static const boxRadius = 20.0;


  static List<String> payPalAccountTypes = [
    "Personal",
    "Business"
  ];


  static String mapKey = "AIzaSyCNNmfTGsBatXy77JEAcjxuHCR2WSxVhvg";

  static List<PopupMenuItem> menuItem = [
    returnMenu("profile", "Profile"),
    returnMenu("discovery", "Discovery"),
    returnMenu("favourites", "Favourites"),
    returnMenu("instruments", "Music Skills"),
    returnMenu("logout", "Logout"),
  ];

  static List<Color> colors = [
    const Color(0xff7E4C11),
    const Color(0xff7DA0B3),
    const Color(0xff7A5791),
    const Color(0xff931A07),
    const Color(0xffDF5B11),
    const Color(0xff8F3C6A),
    const Color(0xff2B138D),
    const Color(0xff3B8B70),
    const Color(0xffA8433B),
    const Color.fromRGBO(255, 255, 255, 0.15),
  ];

  static PopupMenuItem returnMenu(String value, String text) {
    return PopupMenuItem(
      value: '/$value',
      child: Text(
        text,
        style: const TextStyle(color: CColors.primary),
      ),
    );
  }

  static List<BoxShadow> shadow() {
    return const [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 10,
        offset: Offset(0, 3), // Shadow position
      ),
    ];
  }
}
