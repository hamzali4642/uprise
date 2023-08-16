import 'package:flutter/material.dart';
import 'package:uprise/screens/dashboard/discovery.dart';
import 'package:uprise/screens/dashboard/home.dart';
import 'package:uprise/screens/dashboard/home/promos.dart';
import 'package:uprise/screens/dashboard/home/statistics.dart';
import '../screens/dashboard/home/event.dart';
import '../screens/dashboard/home/feed.dart';
import '../screens/dashboard/profile_details/profile_details.dart';

class DashboardProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  List<Widget?> pages = [
    const Home(),
    null,
    const Discovery(),
    const ProfileDetails(),

  ];

  String _homeSelected = "Feed";

  String get homeSelected => _homeSelected;

  set homeSelected(String value) {
    _homeSelected = value;
    notifyListeners();
  }

  Widget homePage() {
    switch (_homeSelected) {
      case "Feed":
        return const Feed();
      case "Events":
        return const Events();
      case "Promos":
        return const Promos();
      case "Statistics":
        return const Statistics();
      default:
        return const Statistics();
    }
  }

  List<String> selectedGenres = [];
  refresh(){
    notifyListeners();
  }


  bool _showOverlay = false;

  bool get showOverlay => _showOverlay;

  set showOverlay(bool value) {
    _showOverlay = value;
    notifyListeners();
  }
}
